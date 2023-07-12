import { Request, Response } from "express";
import { User } from "../models/User Profile Models/user.model";
import { WorkExperience, WorkExperienceSchema } from "../models/User Profile Models/sub_documents/work_experience.model";
import { Education } from "../models/User Profile Models/sub_documents/education.model";
import { Skills } from "../models/User Profile Models/sub_documents/skills.model";

export async function fetchProfile(req: Request, res: Response) {
    const id = req.params.id;
    try {
        const data = await User.findById(id);
        console.log(data);
        
        res.json({ status: true, data });

    } catch (error) {
        console.log(error);
        res.json({ status: false, message: "Something went wrong" });
    }

}

export async function editProfile(req: Request, res: Response) {
    const id = req.params.id;
    try {
        const data = await User.findByIdAndUpdate(id, {$set: req.body.data});
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
        const user = await User.findById(id);
        const data = new WorkExperience(req.body.data);

        await user.updateOne({$push: {workExperience: data}})
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
        const user = await WorkExperience.findByIdAndUpdate(wid,{$set: req.body.data });
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

export async function deleteWorkSpace(req: Request, res: Response) {
    const id = req.params.id;
    const wid = req.params.wid;

    try {
        const user = await WorkExperience.findByIdAndDelete(wid);
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
        const user = await User.findById(id);
        const data = new Education(req.body.data);

        await user.updateOne({$push: {education: data}})
        res.json({ status: true, data });

    } catch (error) {
        console.log(error);
        res.json({ status: false, message: "Something went wrong" });
    }

}

export async function editEducation(req: Request, res: Response) {
    const id = req.params.id;
    const eid = req.params.wid;

    try {
        const user = await Education.findByIdAndUpdate(eid,{$set: req.body.data });
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
    const eid = req.params.wid;

    try {
        const user = await Education.findByIdAndDelete(eid);
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
        const user = await User.findById(id);
        const data = new Skills(req.body.data);

        await user.updateOne({$push: {skills: data}});
        res.json({ status: true, data });

    } catch (error) {
        console.log(error);
        res.json({ status: false, message: "Something went wrong" });
    }

}

export async function editSkill(req: Request, res: Response) {
    const id = req.params.id;
    const sid = req.params.wid;

    try {
        const user = await Skills.findByIdAndUpdate(sid,{$set: req.body.data});
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

export async function deleteSkills(req: Request, res: Response) {
    const id = req.params.id;
    const sid = req.params.wid;

    try {
        const user = await Skills.findByIdAndDelete(sid);
        // const data = new WorkExperience(req.body);
        // let workExperience = user.workExperience;
        // workExperience.push(data);
        res.json({ status: true });

    } catch (error) {
        console.log(error);
        res.json({ status: false, message: "Something went wrong" });
    }

}