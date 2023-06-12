import { Schema, Types, model } from 'mongoose';

export interface Education {
    institution: string,
    degree: string,
    field: string,
    start: Date,
    end: Date,
    location: string,
}

const EducationSchema = new Schema<Education>({
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

export const Education = model<Education>('education',EducationSchema);