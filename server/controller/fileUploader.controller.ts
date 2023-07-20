import { Request, Response } from "express";
import UserService from "../services/user.services";
import { User } from "../models/User Profile Models/user.model";
import { JwtPayload } from "jsonwebtoken";
import { Conference } from "../models/conference.model";



export async function editLogoConf(req: Request, res: Response) {
    console.log(req.params);
    
    try {
        let edit = await Conference.findByIdAndUpdate(req.params.confId, {
            $set: {
                eventLogo: req.file.path
            },
        },
            { new: true },
        );
        const response = { status: true, data: edit };
        return res.status(200).json(response);
    } catch (err) {
        return res.status(500).json({ status: false });
    }

    // (err, profile) => {
    //     if (err) return res.status(500).send(err);
    //     const response = {
    //       message: "image added successfully updated",
    //       data: profile,
    //     };
    //     return res.status(200).send(response);
    //   }
}
