import { NextFunction, Request, Response } from "express";
import UserService from "../services/user.services";
import { User } from "../models/User Profile Models/user.model";
import { JwtPayload } from "jsonwebtoken";
import { Blacklist } from "../models/blacklist.model";

export async function signUp(req: Request, res: Response, next: NextFunction) {
    const { name, email, dob, } = req.body;
    //@ts-ignore
    const success = await UserService.signUpWithEmailAndPassword(name, new Date(Date.parse(dob)), email, req.hashedPassword);
    const accessToken = UserService.generateToken({ email }, 5 * 60);
    const refreshToken = UserService.generateToken({ email }, 30 * 24 * 60 * 60);

    res.cookie("login_access_token", accessToken);
    res.cookie("login_refresh_token", refreshToken);
    res.status(200).json({ status: true, token: accessToken, });

}

export async function login(req: Request, res: Response, next: NextFunction) {
    const { email, password } = req.body;
    const accessToken = UserService.generateToken({ email }, 15 * 60);
    const refreshToken = UserService.generateToken({ email }, 30 * 24 * 60 * 60);
    res.cookie("login_access_token", accessToken);
    res.cookie("login_refresh_token", refreshToken);
    res.status(200).json({ status: true, token: accessToken, });
}

export function sendMail(req: Request, res: Response, next: NextFunction) {
    // @ts-ignore
    const token = UserService.generateToken({ otp: req.otp }, 2 * 60);
    res.cookie("encrypted_otp_token", token, { maxAge: 2 * 60 * 1000 });
    res.status(200).json({ status: true });
}

export async function verifiedEmail(req: Request, res: Response, next: NextFunction) {
    try {
        const data = UserService.verifyToken(req.body.login_access_token) as JwtPayload;
        if(!data) {
            return res.json({status: false, success: "Session Expired"});
        }
        var user = await User.findOneAndUpdate({ email: data.email }, {
            $set: {
                emailVerified: true,
            }
        });
        res.status(200).json({ status: true,  user});
    } catch (error) {
        console.log(error.message);
        throw error;
    }
}

export async function logout(req: Request, res: Response, next: NextFunction) {
    let blacklist = new Blacklist({
        accessToken: req.body.login_access_token,
        refreshToken: req.body.login_refresh_token
    })
    blacklist.save();
    res.clearCookie("login_access_token");
    res.clearCookie("login_refresh_token");
    res.clearCookie("encrypted-otp-token");
    res.status(200).json({ status: true });
}

export async function refreshToken(req: Request, res: Response, next: NextFunction) {
    //@ts-ignore
    const accessToken = UserService.generateToken({ email: req.data }, 15 * 60);
    res.cookie(`login_access_token`, accessToken);
    res.json({ status: true, token: accessToken });
}