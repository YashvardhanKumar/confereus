import { Schema, model} from "mongoose";

export interface IBlacklist {
    refreshToken: string,
    accessToken: string,
}

const BlacklistSchema = new Schema<IBlacklist>({
    refreshToken: String,
    accessToken: String,
    
}, { timestamps: true });



export const Blacklist = model<IBlacklist>('blacklist', BlacklistSchema);