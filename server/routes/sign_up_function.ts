import { User } from "../models/User Profile Models/user";
import * as bcrypt from "bcrypt"
import WebSocket from 'ws';
import { createTransport } from 'nodemailer';

const saltRounds = 10;

export function signUp(data: any, ws: WebSocket.WebSocket) {
    // On Signup
    // If mail doesn't exists it will return null
    User.findOne({ email: data.email }).then((user) => {

        if (user == null) {
            console.log(signupData);
            bcrypt
                .genSalt(saltRounds)
                .then((salt: string) => {
                    console.log('Salt: ', salt);
                    return bcrypt.hash(data.hash, salt);
                })
                .then((hash: string) => {
                    console.log('Hash: ', hash);
                    var signupData = "{'cmd':'" + data.cmd + "','status':'success'}";
                    const user = new User({
                        email: data.email,
                        password: hash,
                        name: data.name,
                        dob: new Date(Date.parse(data.dob))
                    });
                    // Insert new user in db
                    User.insertMany(user).then((data) => {
                        console.log(data[0]);
                    }).catch((e) => console.log(e));
                    // user.save();
                    // Send info to user
                    ws.send(signupData);
                })
                .catch(err => console.error(err.message));

        } else {
            // Send error message to user.
            var signupData = "{'cmd':'" + data.cmd + "','status':'user_exists'}";
            console.log(signupData);
            ws.send(signupData);
        }
    });
}

export async function getOTP(data: any, ws: WebSocket.WebSocket) {
    const OTP = Math.floor(Math.random() * 1000000);
    let stringOTP: string = OTP.toString();

    for (let index = 0; index < 5 - Math.log10(OTP); index++) {
        stringOTP = '0' + stringOTP;
    }

    const transporter = createTransport({
        // host: "smtp.gmail.com",
        // port: "465",
        // secure: true,
        service: 'gmail',
        auth: {
            user: process.env.FROM_EMAIL,
            pass: process.env.EMAIL_PASSWORD,
        },
        tls: { rejectUnauthorized: false }
    })

    const message = {
        from: `${process.env.FROM_NAME} <${process.env.FROM_EMAIL}>`,
        to: data.email,
        subject: 'Verify Email Confereus',
        html: `<div>
        <p>Hello,</p>
        <p>Copy and paste the OTP to verify your email address.</p>
        <p><h3><b>${stringOTP}</b></h3></p>
        <p>If you didn't ask to verify this address, you can ignore this email.</p>
        <p>Thanks,</p>
        <p>Your Confereus team</p>
        </div>`
    }
    ws.send(`{"cmd": "${data.cmd}","otp": "${stringOTP}"}`);
    const info = await transporter.sendMail(message);
    console.log('Message sent : %s', info.messageId)
}