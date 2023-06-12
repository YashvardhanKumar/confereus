import { User } from "../models/User Profile Models/user";
import * as bcrypt from "bcrypt";
class UserService {
    static async registerUser(name: string, dob: Date, email: string, password: string) {
        try {

            const createUser = new User({ name, email, password, dob })

        } catch (error) {
            throw error;
        }
    }

    static async loginUser(email: string, password: string) {
        
    }
}

export default UserService;