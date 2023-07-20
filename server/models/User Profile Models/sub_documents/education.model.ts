import { Schema, Types, model } from 'mongoose';

export interface IEducation {
    institution: string,
    degree: string,
    field: string,
    start: Date,
    end: Date,
    location: string,
}

export const EducationSchema = new Schema<IEducation>({
    institution: {
        type: String,
        required: true,
    },
    degree: {
        type: String,
        required: true,
    },
    field: {
        type: String,
        required: true,
    },
    start: {
        type: Date,
        required: true,
    },
    end: {
        type: Date,
        required: true,
    },
    location: String,
});

export const Education = model<IEducation>('educations',EducationSchema);