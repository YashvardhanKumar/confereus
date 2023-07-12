import { Schema, Types, model } from 'mongoose';

export interface IWorkExperience {
    position: string,
    company: string,
    jobType: string,
    start: Date,
    end: Date,
    location: string,
}

export const WorkExperienceSchema = new Schema<IWorkExperience>({
    position: {
        type: String,
        required: true,
    },
    company: {
        type: String,
        required: true,
    },
    jobType: {
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

export const WorkExperience = model<IWorkExperience>('work_experience',WorkExperienceSchema);