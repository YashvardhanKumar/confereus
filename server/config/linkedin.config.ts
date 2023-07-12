import { Request, Response } from "express";
import axios from "axios";
import * as qs from "querystring";
import { User } from "../models/User Profile Models/user.model";
import UserService from "../services/user.services";
const urlToGetLinkedInAccessToken = 'https://www.linkedin.com/oauth/v2/accessToken';
const urlToGetUserProfile = 'https://api.linkedin.com/v2/me?projection=(id,localizedFirstName,localizedLastName,profilePicture(displayImage~digitalmediaAsset:playableStreams))'
const urlToGetUserEmail = 'https://api.linkedin.com/v2/clientAwareMemberHandles?q=members&projection=(elements*(primary,type,handle~))';

export async function getLinkedinUser(req: Request, res: Response) {
  const { firstName, lastName, profilePicture, email } = req.body;

  console.log(req.body);
  const accessToken = UserService.generateToken({ email }, 15 * 60);
  const refreshToken = UserService.generateToken({ email }, 30 * 24 * 60 * 60);
  res.cookie("login_access_token", accessToken);
  res.cookie("login_refresh_token", refreshToken);
  // const accessToken = getAccessToken(code);
  // const userProfile = getUserProfile(accessToken);
  // const userEmail = getUserEmail(accessToken);
  // console.log(userEmail);

  // let resStatus = 400;
  // if(!(accessToken === null || userProfile === null || userEmail === null)) {
  let user = await userBuilder({ firstName, lastName, profilePicture }, email);
  let resStatus = 200;
  console.log(user._id);
  // }
  res.status(resStatus).json({ user, token: accessToken, userId: user });
}

// function getAccessToken(code) {
//   let accessToken = null;
//   const config = {
//     headers: { "Content-Type": 'application/x-www-form-urlencoded' }
//   };
//   const parameters = {
//     "grant_type": "authorization_code",
//     "code": code,
//     "redirect_uri": "http://localhost:3000/signin-linkedin",
//     "client_id": process.env.CLIENT_ID,
//     "client_secret": process.env.CLIENT_SECRET,
//   };
//   axios
//     .post(
//       urlToGetLinkedInAccessToken,
//       qs.stringify(parameters),
//       config)
//     .then(response => {
//       accessToken = response.data["access_token"];
//     })
//     .catch(err => {
//       console.log("Error getting LinkedIn access token");
//     })
//     return accessToken;
// }

// function getUserProfile(accessToken) {
//   let userProfile = null;
//   const config = {
//     headers: {
//       "Authorization": `Bearer ${accessToken}`
//     }
//   }
//   axios
//     .get(urlToGetUserProfile, config)
//     .then(response => {
//       userProfile.firstName = response.data["localizedFirstName"];
//       userProfile.lastName = response.data["localizedLastName"];
//       userProfile.profileImageURL = response.data.profilePicture["displayImage~"].elements[0].identifiers[0].identifier;
//       // I mean, couldn't they have burried it any deeper?
//     })
//     .catch(error => console.log("Error grabbing user profile"))
//   return userProfile;
// }

// function getUserEmail(accessToken) {
//   let email = null;
//   const config = {
//     headers: {
//       "Authorization": `Bearer ${accessToken}`
//     }
//   };
//   axios
//     .get(urlToGetUserEmail, config)
//     .then(response => {
//       email = response.data.elements[0]["handle~"];
//     })
//     .catch(error => console.log("Error getting user email"))

//   return email;
// }
async function userBuilder(userProfile, userEmail) {
  let user = await User.findOne({
    email: userEmail,
    // provider: 'linkedin_login'
  });
  let data = {
    name: `${userProfile.firstName} ${userProfile.lastName}`,
    profileImageURL: userProfile.profilePicture,
    email: userEmail,
    password: null,
    // dob: user.dob,
    emailVerified: true,
    provider: 'linkedin_login'
  }
  if (!user) {
    await User.insertMany(data);
    user = await User.findOne({
      email: userEmail,
      // provider: 'linkedin_login'
    });
    return user._id;
  }
  if (user.provider == 'linkedin_login') {
    // await User.insertMany(data);
    // user = await User.findOne({ email: userEmail, provider: { $ne: 'linkedin_login' } });
    return user._id;
  } else {
   
    await user.updateOne({
      $set: data,
    })
  }
  return user._id;
}