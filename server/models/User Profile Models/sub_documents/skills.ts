import { Schema, Types, model } from 'mongoose';

export interface Skills {
    skill: string,
    expertise: string,
}

const SkillsSchema = new Schema<Skills>({
    skill: {
        type: String,
        required: true,
    },
    expertise: {
        type: String,
        required: true,
    },
});

export const Skills = model<Skills>('skills',SkillsSchema);