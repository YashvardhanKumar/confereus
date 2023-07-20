import { Request, Response } from "express";
import { Conference, Event } from "../models/conference.model";
import mongoose, { Schema, Types } from "mongoose";

export async function getEvent(req: Request, res: Response) {
    const confId = req.params.confId;
    console.log(req.params);
    const { ObjectId } = Types;
    try {
        let data = await Conference.aggregate([
            { $match: { _id: new ObjectId(confId) } },
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
            { $limit: 1 },
        ]);
        console.log(data);

        res.json({ status: true, data: data[0].events });
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
        await event.save();
        let data = await Conference.findByIdAndUpdate(confId, {
            $push: { events: event._id },
        });
        res.json({ status: true, data: event });
    } catch (error) {
        console.log(error);
        res.json({ status: false, message: "Something went wrong" });
    }
}

export async function editEvent(req: Request<{ id: string, confId: string, eventId: string }>, res: Response) {
    const eventId = req.params.eventId;
    console.log(req.body.data);

    try {
        let data = await Event.findByIdAndUpdate(eventId,
            {
                $set: req.body.data
            });
        res.json({ status: true, data: data });

    } catch (error) {
        console.log(error);
        res.json({ status: false, message: "Something went wrong" });
    }
}

export async function deleteEvent(req: Request<{ id: string, confId: string, eventId: string }>, res: Response) {
    const eventId = req.params.eventId;
    const confId = req.params.confId;
    try {
        let data = await Event.findByIdAndDelete(eventId);
        await Conference.findByIdAndUpdate(confId, {
            $pull: { events: data._id },
        });
    } catch (error) {
        console.log(error);
        res.json({ status: false, message: "Something went wrong" });
    }
    res.json({ status: true });
}