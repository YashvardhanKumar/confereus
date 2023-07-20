import { Request, Response } from "express";
import { User } from "../models/User Profile Models/user.model";
import { WorkExperience, WorkExperienceSchema } from "../models/User Profile Models/sub_documents/work_experience.model";
import { Education } from "../models/User Profile Models/sub_documents/education.model";
import { Skills } from "../models/User Profile Models/sub_documents/skills.model";
import { Types } from "mongoose";

export async function fetchProfile(req: Request, res: Response) {
    const id = req.params.id;
    console.log(id);
    
    const { ObjectId } = Types;
    try {
        const data = await User.aggregate([
            { $match: { _id: new ObjectId(id) } },
            {
                $lookup: {
                    from: 'work_experiences',
                    localField: 'workExperience',
                    foreignField: '_id',
                    as: 'workExperience',
                    pipeline: [
                        { $sort: { start: -1 } }
                    ]
                }
            },
            {
                $lookup: {
                    from: 'educations',
                    localField: 'education',
                    foreignField: '_id',
                    as: 'education',
                    pipeline: [
                        { $sort: { start: -1 } }
                    ]
                }
            },
            {
                $lookup: {
                    from: 'skills',
                    localField: 'skills',
                    foreignField: '_id',
                    as: 'skills',
                }
            },
            { $limit: 1 },

        ]);
        // .findById(id).populate(['workExperience', 'education', 'skills']);
        console.log(data);

        res.json({ status: true, data: data[0] });

    } catch (error) {
        console.log(error);
        res.json({ status: false, message: "Something went wrong" });
    }

}

export async function editProfile(req: Request, res: Response) {
    const id = req.params.id;
    try {
        const data = await User.findByIdAndUpdate(id, { $set: req.body.data });
        console.log(data);

        res.json({ status: true, data });

    } catch (error) {
        console.log(error);
        res.json({ status: false, message: "Something went wrong" });
    }

}

export async function addWorkSpace(req: Request, res: Response) {
    const id = req.params.id;
    try {
        const data = new WorkExperience(req.body.data);
        await data.save();
        console.log(data);
        
        const user = await User.findByIdAndUpdate(id, { $push: { workExperience: data._id } });

        res.json({ status: true, data });

    } catch (error) {
        console.log(error);
        res.json({ status: false, message: "Something went wrong" });
    }

}

export async function editWorkSpace(req: Request, res: Response) {
    const id = req.params.id;
    const wid = req.params.wid;

    try {
        const data = await WorkExperience.findByIdAndUpdate(wid, { $set: req.body.data });
        // const data = new WorkExperience(req.body);
        // let workExperience = user.workExperience;
        // workExperience.push(data);
        console.log(data);

        res.json({ status: true, data });

    } catch (error) {
        console.log(error);
        res.json({ status: false, message: "Something went wrong" });
    }

}

export async function deleteWorkSpace(req: Request, res: Response) {
    const id = req.params.id;
    const wid = req.params.wid;

    try {
        const user = await WorkExperience.findByIdAndDelete(wid);
        await User.findByIdAndUpdate(id, { $pull: { workExperience: user._id } });
        // const data = new WorkExperience(req.body);
        // let workExperience = user.workExperience;
        // workExperience.push(data);
        res.json({ status: true });

    } catch (error) {
        console.log(error);
        res.json({ status: false, message: "Something went wrong" });
    }

}

export async function addEducation(req: Request, res: Response) {
    const id = req.params.id;
    try {
        const data = new Education(req.body.data);
        await data.save();
        await User.findByIdAndUpdate(id, { $push: { education: data._id } })
        res.json({ status: true, data });

    } catch (error) {
        console.log(error);
        res.json({ status: false, message: "Something went wrong" });
    }

}

export async function editEducation(req: Request, res: Response) {
    const id = req.params.id;
    const eid = req.params.eid;

    try {
        // const user = await Education.findByIdAndUpdate(eid,{$set: req.body.data });
        const user = await Education.findByIdAndUpdate(eid, { $set: req.body.data })
        // const data = new WorkExperience(req.body);
        // let workExperience = user.workExperience;
        // workExperience.push(data);
        let data = user;
        res.json({ status: true, data });

    } catch (error) {
        console.log(error);
        res.json({ status: false, message: "Something went wrong" });
    }

}

export async function deleteEducation(req: Request, res: Response) {
    const id = req.params.id;
    const eid = req.params.eid;

    try {
        const data = await Education.findByIdAndDelete(eid);
        await User.findByIdAndUpdate(id, { $pull: { education: data._id } })
        // const data = new WorkExperience(req.body);
        // let workExperience = user.workExperience;
        // workExperience.push(data);
        res.json({ status: true });

    } catch (error) {
        console.log(error);
        res.json({ status: false, message: "Something went wrong" });
    }

}

export async function addSkill(req: Request, res: Response) {
    const id = req.params.id;
    try {

        const data = new Skills(req.body.data);
        await data.save();

        await User.findByIdAndUpdate(id, { $push: { skills: data } });
        res.json({ status: true, data });

    } catch (error) {
        console.log(error);
        res.json({ status: false, message: "Something went wrong" });
    }

}

export async function editSkill(req: Request, res: Response) {
    const id = req.params.id;
    const sid = req.params.sid;

    try {
        // const user = await Skills.findByIdAndUpdate(sid,{$set: req.body.data});
        const data = await Skills.findByIdAndUpdate(sid, { $set: req.body.data });

        // const data = new WorkExperience(req.body);
        // let workExperience = user.workExperience;
        // workExperience.push(data);
        console.log(data);
        
        res.json({ status: true, data });

    } catch (error) {
        console.log(error);
        res.json({ status: false, message: "Something went wrong" });
    }

}

export async function deleteSkills(req: Request, res: Response) {
    const id = req.params.id;
    const sid = req.params.sid;

    try {
        const data = await Skills.findByIdAndDelete(sid);
        await User.findByIdAndUpdate(id, { $pull: { skills: data._id } })
        // const data = new WorkExperience(req.body);
        // let workExperience = user.workExperience;
        // workExperience.push(data);
        res.json({ status: true });

    } catch (error) {
        console.log(error);
        res.json({ status: false, message: "Something went wrong" });
    }

}

