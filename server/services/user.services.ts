import { User } from "../models/User Profile Models/user.model";
import * as jwt from 'jsonwebtoken';
import fs from "fs";
import path from "path";
class UserService {
    static async signUpWithEmailAndPassword(name: string, dob: Date, email: string, password: string) {
        try {

            const createUser = new User({ name, email, password, dob, provider: 'email_login' });
            await createUser.save();
            return createUser;
        } catch (error) {
            throw error;
        }
    }

    static async signUpWithFacebook(name: string, dob: Date, email: string, password: string) {
        try {

            const createUser = new User({ name, email, password, dob })
        } catch (error) {
            throw error;
        }
    }

    static async signUpWithLinkedin(name: string, dob: Date, email: string, password: string) {
        try {

            const createUser = new User({ name, email, password, dob })

        } catch (error) {
            throw error;
        }
    }

    static async signUpWithTwitter(name: string, dob: Date, email: string, password: string) {
        try {

            const createUser = new User({ name, email, password, dob })

        } catch (error) {
            throw error;
        }
    }

    static generateToken(payload: jwt.JwtPayload, jwt_expire: number) {
        const privateKey = fs.readFileSync(path.join(__dirname, '..','keys', 'rsa.key'), 'utf8')
        try {
            return jwt.sign(payload, privateKey, { expiresIn: jwt_expire, algorithm: 'RS256'});
        } catch (err) {
            console.log(err);
            return null;
        }
    }

    static verifyToken(token: string, onError: Function = () => {}) {
        
        const publicKey = fs.readFileSync(path.join(__dirname, '..','keys', 'rsa.key.pub'), 'utf8');
        try {
            return jwt.verify(token, publicKey, { algorithms: ['RS256']});
        } catch (err) {
            console.log(err);
            onError();
            return null;
        }
    }
}

export default UserService;