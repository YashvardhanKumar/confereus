import { Request, Response } from "express";
import { User } from "../models/User Profile Models/user.model";
import { Conference, Event, IEvent } from "../models/conference.model";
import mongoose, { Schema, Types } from "mongoose";
import { createReadStream, createWriteStream, unlinkSync, writeFileSync } from "fs";

export async function fetchConferences(req: Request, res: Response) {
    let type = req.query.type;
    if (!type)
        type = "public";
    try {

        // let data = await Conference.find((type == 'all') ? {} : { visibility: type }).sort({startTime: 1}).populate('events');
        let data = await Conference.aggregate([
            {
                $lookup: {
                    from: 'events',
                    localField: 'events',
                    foreignField: '_id',
                    as: 'events',
                    pipeline: [
                        { $sort: { startTime: 1 } }
                    ]
                }
            },
        ]);
        console.log(data);

        res.json({ status: true, data });

    } catch (error) {
        console.log(error);
        res.json({ status: false, message: "Something went wrong" });
    }
}


export async function addConference(req: Request<{ id: string }>, res: Response) {
    const { subject, about, startTime, endTime } = req.body.data;
    const id = req.params.id;
    // let user = await User.findById(id);
    // const _id = new Types.ObjectId(id);
    console.log(req.params);

    try {

        let data = new Conference({ subject, about, startTime, endTime, admin: id });
        await data.save();
        // let userList = await User.find();
        console.log(data);
        data = await data.populate('events')

        res.json({ status: true, data });
    } catch (error) {
        console.log(error);
        res.json({ status: false, message: "Something went wrong" });
    }
}

export async function editConference(req: Request<{ id: string, confId: string }>, res: Response) {
    const conferenceId = req.params.confId;
    console.log(req.body.data);

    try {
        let data = await Conference.findByIdAndUpdate(conferenceId, {
            $set: req.body.data,
        });
        data = await data.populate('events')
        res.json({ status: true, data });

    } catch (error) {
        console.log(error);
        res.json({ status: false, message: "Something went wrong" });
    }
}

export async function deleteConference(req: Request<{ id: string, confId: string }>, res: Response) {
    const conferenceId = req.params.confId;
    let type = req.query.type;
    try {
        let data = await Conference.findById(conferenceId);
        await Event.deleteMany({ _id: { $in: data.events } });
        await Conference.findByIdAndDelete(conferenceId);
    } catch (error) {
        console.log(error);
        res.json({ status: false, message: "Something went wrong" });
    }
    res.json({ status: true });
}

export async function registerConference(req: Request<{ id: string, confId: string }>, res: Response) {
    const conferenceId = req.params.confId;
    const userId = req.params.id;
    try {
        let data = await Conference.findByIdAndUpdate(conferenceId, { $push: { registered: userId } });

    } catch (error) {
        console.log(error);
        res.json({ status: false, message: "Something went wrong" });
    }
    res.json({ status: true });
}

export async function fetchRegisteredConferences(req: Request<{ id: string }>, res: Response) {
    const userId = req.params.id;
    console.log(userId + 'yash');
    
    try {
        let data = await Conference.find({ registered:  new Types.ObjectId(userId) }).sort({startTime: 1}).populate('events');
        console.log(data);
        
        res.json({ status: true, data });

    } catch (error) {
        console.log(error);
        res.json({ status: false, message: "Something went wrong" });
    }
}