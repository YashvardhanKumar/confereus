import { Schema, model, } from "mongoose";
import * as bcrypt from "bcrypt";

export interface IUser {
    email: string;
    password: string;
    name: string,
    dob: Date,
    emailVerified: boolean,
    profileImageURL: string,
    provider: string,
    workExperience: Schema.Types.ObjectId,
    education: Schema.Types.ObjectId,
    skills: Schema.Types.ObjectId,
}

const UserSchema = new Schema<IUser>({
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
    workExperience:
    {
        type: Schema.Types.ObjectId,
        ref: 'workExperience',
    },
    education: {
        type: Schema.Types.ObjectId,
        ref: 'education'
    },
    skills: {
        type: Schema.Types.ObjectId,
        ref: 'skills'
    }
    
}, { timestamps: true });

export const User = model<IUser>('users', UserSchema);