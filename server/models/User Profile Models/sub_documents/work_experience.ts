import { Schema, Types, model } from 'mongoose';

export interface WorkExperience {
    position: string,
    company: string,
    jobType: string,
    start: Date,
    end: Date,
    location: string,
}

const WorkExperienceSchema = new Schema<WorkExperience>({
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

export const WorkExperience = model<WorkExperience>('work_experience',WorkExperienceSchema);