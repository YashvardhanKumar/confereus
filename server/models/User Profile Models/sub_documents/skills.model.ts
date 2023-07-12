import { Schema, Types, model } from 'mongoose';

export interface ISkills {
    skill: string,
    expertise: string,
}

export const SkillsSchema = new Schema<ISkills>({
    skill: {
        type: String,
        required: true,
    },
    expertise: {
        type: String,
        required: true,
    },
});

export const Skills = model<ISkills>('skills',SkillsSchema);