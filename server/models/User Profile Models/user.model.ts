import { Model, Schema, model, } from "mongoose";
import * as bcrypt from "bcrypt";
import { IWorkExperience, WorkExperienceSchema } from "./sub_documents/work_experience.model";
import { EducationSchema, IEducation } from "./sub_documents/education.model";
import { ISkills, SkillsSchema } from "./sub_documents/skills.model";

export interface IUser {
    email: string;
    password: string;
    name: string,
    dob: Date,
    emailVerified: boolean,
    profileImageURL: string,
    provider: string,
    workExperience?: Array<IWorkExperience>,
    education?: Array<IEducation>,
    skills?: Array<ISkills>,
}

const UserSchema = new Schema<IUser, Model<IUser>>({
    emailVerified: Boolean,
    name: {
        type: String,
        required: true,
    },
    email: {
        type: String,
        required: true,
    },
    password: String,
    dob: Date,
    profileImageURL: String,
    provider: String,
    workExperience: [WorkExperienceSchema],
    education: [EducationSchema],
    skills: [SkillsSchema],

}, { timestamps: true });

export const User = model<IUser, Model<IUser>>('users', UserSchema);