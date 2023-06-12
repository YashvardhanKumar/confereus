import { Schema, model, } from "mongoose";
import * as bcrypt from "bcrypt";
export interface User {
    email: string;
    password: string;
    name: string,
    dob: Date,
    workExperience: Schema.Types.ObjectId,
    education: Schema.Types.ObjectId,
    skills: Schema.Types.ObjectId,
}

const UserSchema = new Schema<User>({
    name: {
        type: String,
        required: true,
    },
    email: {
        type: String,
        required: true,
        // trim: true,
        // lowercase: true,
        // match: /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/,
    },
    password: {
        type: String,
        required: true,
        // minlength: 8,
    },
    dob: {
        type: Date,
        required: true,
    },
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

});

UserSchema.pre('save',async () => {
    try {
        let user: User = this;
        const salt = await(bcrypt.genSalt(10));
        const hashedPassword = await bcrypt.hash(user.password, salt);
        user.password = hashedPassword;
    } catch (error) {
        throw error;
    }
    
});

export const User = model<User>('users', UserSchema);