import { Request, Response, NextFunction } from "express";
import { User } from "../models/User Profile Models/user.model";
import * as bcrypt from "bcrypt";
import { createTransport } from "nodemailer";
import { Blacklist } from "../models/blacklist.model";
import UserService from "../services/user.services";
import { JwtPayload } from "jsonwebtoken";

export async function hashPassword(req: Request, res: Response, next: NextFunction) {
    try {
        const salt = await (bcrypt.genSalt(10));
        const hashedPassword = await bcrypt.hash(req.body.password, salt);
        //@ts-ignore
        req.hashedPassword = hashedPassword;
        next();
    } catch (error) {
        throw error;
    }
}

export async function canCreateUser(req: Request, res: Response, next: NextFunction) {
    try {
        let user = await User.findOne({ email: req.body.email });
        if (user == null) {
            return next();
        } else {
            res.json({ status: false, success: "Already have account!", });
        }

    } catch (e) {
        throw e;
    }
}

export async function doesUserExist(req: Request, res: Response, next: NextFunction) {
    try {
        let user = await User.findOne({ email: req.body.email });
        if (user != null) {
            // @ts-ignore
            req.userPass = user.password;
            return next();
        } else {
            res.json({ status: false, success: "Account doesn't exists!", });

        }
    } catch (e) {
        throw e;
    }
}

export async function checkPassword(req: Request, res: Response, next: NextFunction) {
    try {
        let user = await User.findOne({ email: req.body.email });
        /* @ts-ignore */
        console.log(req.body.password,);
        /* @ts-ignore */
        const isMatch = await bcrypt.compare(req.body.password, req.userPass);
        if (isMatch) {
            next();
        } else {
            res.json({ status: false, success: "Incorrect email or password", });
        }
    } catch (error) {
        throw error;

    }

}

export async function sendOTPToMail(req: Request, res: Response, next: NextFunction) {
    const OTP = Math.floor(Math.random() * 1000000);
    let stringOTP: string = OTP.toString();

    for (let index = 0; index < 5 - Math.log10(OTP); index++) {
        stringOTP = '0' + stringOTP;
    }
    const transporter = createTransport({
        secure: true,
        service: 'gmail',
        auth: {
            user: process.env.FROM_EMAIL,
            pass: process.env.EMAIL_PASSWORD,
        },
        tls: { rejectUnauthorized: false }
    })

    const message = {
        from: `${process.env.FROM_NAME} <${process.env.FROM_EMAIL}>`,
        to: req.body.email,
        subject: 'Verify Email Confereus',
        html: `<div>
                <p>Hello,</p>
                <p>Copy and paste the OTP to verify your email address.</p>
                <p><h3><b>${stringOTP}</b></h3></p>
                <p>If you didn't ask to verify this address, you can ignore this email.</p>
                <p>Thanks,</p>
                <p>Your Confereus team</p>
                </div>`
    }
    const info = await transporter.sendMail(message);
    console.log('Message sent : %s', info.messageId);
    console.log(stringOTP);

    const otpSalt = await bcrypt.genSalt(10);
    const encryptedOTP = await bcrypt.hash(stringOTP, otpSalt);
    // @ts-ignore
    req.otp = encryptedOTP;
    next();
}

export async function verifyOTP(req: Request, res: Response, next: NextFunction) {
    console.log(req.body);
    const bcrypt_otp_token = req.body.encrypted_otp_token;
    console.log(bcrypt_otp_token);
    let bcryptOTP = UserService.verifyToken(bcrypt_otp_token) as JwtPayload;
    console.log(bcryptOTP);
    const success = await bcrypt.compare(req.body.otp, bcryptOTP.otp);
    if (success) {
        return next();
    } else {
        res.json({ status: false, success: "Wrong OTP" });
    }
}

export async function isTokenNotExpired(req: Request, res: Response, next: NextFunction) {
    let accessToken = req.headers['authorization'];
    console.log(accessToken);
    accessToken = accessToken.slice(7, accessToken.length)

    try {

        let aData = UserService.verifyToken(accessToken, async () => {
            const refreshToken = req.body.login_refresh_token;
            let blacklist = await Blacklist.findOne({ refreshToken: refreshToken });
            let data = UserService.verifyToken(refreshToken) as JwtPayload;
            console.log(data);

            if (blacklist || !data) {
                res.json({ status: false, success: "Session Expired!" })
            }
            else {
                //@ts-ignore
                req.data = data.email;
                accessToken = UserService.generateToken({ email: data.email }, 15 * 60);
                res.cookie(`login_access_token`, accessToken);
                next();
                // res.json({ status: true, token: accessToken });
                // res.json({ status: false, success: "Session Expired!" })

            }
        });
        if (aData) {
            //@ts-ignore
            req.data = aData.email;
            next();
        }
    } catch (e) {
        // if (aData) {
        //     //@ts-ignore
        //     req.data = aData.email;
        //     next();
        // } else {
        const refreshToken = req.body.login_refresh_token;
        let blacklist = await Blacklist.findOne({ refreshToken: refreshToken });
        let data = UserService.verifyToken(refreshToken) as JwtPayload;
        console.log(data);

        if (blacklist || !data) {
            res.json({ status: false, success: "Session Expired!" })
        }
        else {
            //@ts-ignore
            req.data = data.email;
            accessToken = UserService.generateToken({ email: data.email }, 15 * 60);
            res.cookie(`login_access_token`, accessToken);
            next();
            // res.json({ status: true, token: accessToken });
            // res.json({ status: false, success: "Session Expired!" })

        }
    }
}

export async function checkTokenForLogin(req: Request, res: Response, next: NextFunction) {
    let accessToken = req.headers['authorization'];
    console.log(accessToken);
    accessToken = accessToken.slice(7, accessToken.length)
    let aData = UserService.verifyToken(accessToken);

    if (UserService.verifyToken(accessToken)) {
        //@ts-ignore
        // req.data = aData.email;
        // next();
        res.json({ status: true, token: accessToken, success: "Not Expired Yet" });
    } else {
        const refreshToken = req.body.login_refresh_token;
        let blacklist = await Blacklist.findOne({ refreshToken: refreshToken });
        let data = UserService.verifyToken(refreshToken) as JwtPayload;
        console.log(data);

        if (blacklist || !data) {
            res.json({ status: false, success: "Session Expired!" })
        }
        else {
            //@ts-ignore
            req.data = data.email;
            // res.json({ status: false, success: "Session Expired!" })
            next();

        }
    }
}

export async function isAuthenticated(req: Request, res: Response, next: NextFunction) {
    console.log(req.body.login_refresh_token);
    if (UserService.verifyToken(req.body.login_refresh_token)) {
        return next();
    }
    res.json({ status: false, success: "Login Needed" });
}