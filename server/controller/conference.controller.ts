import { Request, Response } from "express";
import { User } from "../models/User Profile Models/user.model";
import { Conference, Event } from "../models/conference.model";
import mongoose, { Schema, Types } from "mongoose";

export async function fetchConferences(req: Request, res: Response) {
    let type = req.query.type;
    if (!type)
        type = "public";
    try {
        
        let data = await Conference.find((type == 'all') ? {} : { visibility: type });
        console.log(data);

        res.json({ status: true, data });

    } catch (error) {
        console.log(error);
        res.json({ status: false, message: "Something went wrong" });
    }
}

export async function addConference(req: Request<{ id: string }>, res: Response) {
    const { subject, about, startTime, endTime } = req.body.data;
    const id = req.params['id'];
    // let user = await User.findById(id);
    // const _id = new Types.ObjectId(id);
    console.log(req.params);

    try {

        let data = new Conference({ subject, about, startTime, endTime, admin: id });
        await data.save();
        // let userList = await User.find();
        console.log(data);

        res.json({ status: true, data: data.toJSON() });
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
        await Conference.findByIdAndDelete(conferenceId);
    } catch (error) {
        console.log(error);
        res.json({ status: false, message: "Something went wrong" });
    }
    res.json({ status: true });
}

export async function getEvent(req: Request, res: Response) {
    const confId = req.params.confId;
    console.log(req.params);

    try {

        let data = await Conference.findById(confId);
        console.log(data.events);

        res.json({ status: true, data: data.events });
    } catch (error) {
        console.log(error);
        res.json({ status: false, message: "Something went wrong" });
    }
} export async function addEvent(req: Request<{ id: string, confId: string }>, res: Response) {
    const { subject,
        presenter,
        startTime,
        endTime,
        location } = req.body.data;
    const confId = req.params.confId;
    try {

        let event = new Event({ subject, presenter, startTime, endTime, location });
        let data = await Conference.findByIdAndUpdate(confId, {
            $push: { "events": event },
        });

        await data.save();


        res.json({ status: true, data: event });
    } catch (error) {
        console.log(error);
        res.json({ status: false, message: "Something went wrong" });
    }
}

export async function editEvent(req: Request<{ id: string, confId: string, eventId: string }>, res: Response) {
    const eventId = req.params.eventId;
    try {
        let data = await Event.findByIdAndUpdate(eventId , {
            $set: req.body.data,
        });
        res.json({ status: true, data });

    } catch (error) {
        console.log(error);
        res.json({ status: false, message: "Something went wrong" });
    }
}

export async function deleteEvent(req: Request<{ id: string, confId: string, eventId: string }>, res: Response) {
    const eventId = req.params.eventId;
    try {
        await Event.findByIdAndUpdate(eventId);
    } catch (error) {
        console.log(error);
        res.json({ status: false, message: "Something went wrong" });
    }
    res.json({ status: true });
}