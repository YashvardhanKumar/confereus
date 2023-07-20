import { NextFunction, Request, Response } from "express";
import UserService from "../services/user.services";
import { User } from "../models/User Profile Models/user.model";
import { JwtPayload } from "jsonwebtoken";
import { Blacklist } from "../models/blacklist.model";

export async function signUp(req: Request, res: Response) {
    const { name, email, dob, } = req.body;
    //@ts-ignore
    const success = await UserService.signUpWithEmailAndPassword(name, new Date(Date.parse(dob)), email, req.hashedPassword);
    const accessToken = UserService.generateToken({ email }, 5 * 60);
    const refreshToken = UserService.generateToken({ email }, 30 * 24 * 60 * 60);

    res.cookie("login_access_token", accessToken);
    res.cookie("login_refresh_token", refreshToken);
    res.status(200).json({ status: true, token: accessToken, userId: success._id });

}

export async function login(req: Request, res: Response) {
    const { email, password } = req.body;
    const accessToken = UserService.generateToken({ email }, 15 * 60);
    const refreshToken = UserService.generateToken({ email }, 30 * 24 * 60 * 60);
    const userId = (await User.findOne({ email }))._id;
    res.cookie("login_access_token", accessToken);
    res.cookie("login_refresh_token", refreshToken);
    res.status(200).json({ status: true, token: accessToken, userId });
}

export function sendMail(req: Request, res: Response) {
    // @ts-ignore
    const token = UserService.generateToken({ otp: req.otp }, 2 * 60);
    res.cookie("encrypted_otp_token", token, { maxAge: 2 * 60 * 1000 });
    res.status(200).json({ status: true });
}

export async function verifiedEmail(req: Request, res: Response) {
    try {
        let accessToken = req.headers['authorization'];
        accessToken = accessToken.slice(7, accessToken.length);
        const data = UserService.verifyToken(accessToken) as JwtPayload;
        console.log(data);
        
        if (!data) {
            return res.json({ status: false, success: "Session Expired" });
        }
        var user = await User.findOneAndUpdate({ email: data.email }, {
            $set: {
                emailVerified: true,
            }
        });
        console.log(user);
        res.status(200).json({ status: true, user });
    } catch (error) {
        console.log(error.message);
        throw error;
    }
}

export async function logout(req: Request, res: Response) {
    let accessToken = req.headers['authorization'];
    let blacklist = new Blacklist({
        accessToken,
        refreshToken: req.body.login_refresh_token
    })
    blacklist.save();
    res.clearCookie("login_access_token");
    res.clearCookie("login_refresh_token");
    res.clearCookie("encrypted-otp-token");
    res.status(200).json({ status: true });
}

export async function refreshToken(req: Request, res: Response) {
    //@ts-ignore
    const accessToken = UserService.generateToken({ email: req.data }, 15 * 60);
    res.cookie(`login_access_token`, accessToken);
    res.json({ status: true, token: accessToken });
}

export async function getAllUsers(req: Request, res: Response) {
    try {
        const data = await User.find().populate(['workExperience', 'education', 'skills']);
        console.log(data);

        res.json({ status: true, data });
    } catch (error) {
        console.log(error);
        res.json({ status: false, message: error });
    }

}
