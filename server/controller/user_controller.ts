import { NextFunction, Request, Response } from "express";
import UserService from "../services/user_services";
import { User } from "../models/User Profile Models/user";

export async function registerUser(req: Request, res: Response, next: NextFunction) {
    try {
        const { name, email, password, dob, } = req.body;
        User.findOne({ email: email }).then(async (user) => {
            if (user == null) {
                const success = await UserService.registerUser(name, new Date(Date.parse(dob)), email, password);
                res.json({ status: true, success: "Registered", });
            }
            else {
                res.json({ status: false, success: "Already have account!", });
            }
        });
    } catch (error) {
        throw error;
    }

}