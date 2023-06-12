import WebSocket from 'ws';
import { User } from "../models/User Profile Models/user";
import * as bcrypt from "bcrypt"

export function login(data: any, ws: WebSocket.WebSocket) {
    // Check if email exists 
    User.findOne({ email: data.email }).then((r) => {
        // If email doesn't exists it will return null
        if (r != null) {
            bcrypt
                .compare(data.hash, r.password)
                .then((res: boolean) => {
                    if (res) {
                        // Send username to user and status code is succes.
                        var loginData = '{"email":"' + r.email + '","status":"success"}';
                        // Send data back to user
                        ws.send(loginData);
                    } else {
                        // Send error
                        var loginData = '{"cmd":"' + data.cmd + '","status":"wrong_pass"}';
                        ws.send(loginData);
                    }
                    console.log(loginData);
                })
                .catch(err => console.error(err.message));

        } else {
            // Send error
            var loginData = '{"cmd":"' + data.cmd + '","status":"wrong_mail"}';
            ws.send(loginData);
        }
    });
}