// import WebSocket from 'ws';
// import { connect } from "mongoose";
// import * as dotenv from "dotenv";
// Used to hash passwords
import { getOTP, signUp } from './routes/sign_up_function';
import { login } from './routes/login_function';
import app from './app';
import './server/db';


// dotenv.config();

const PORT = process.env.PORT || 3000; //port for https

app.get('/',(req,res) => {
    res.send('hello');
})

app
    .listen(PORT, () => console.log(`Listening on ${PORT}`));

// const wss = new WebSocket.Server({  });

// // TODO: Change connection


// wss.on('connection', function (ws) {
//     ws.on('message', message => { // If there is any message
//         var datastring = message.toString();
//         if (datastring.charAt(0) == "{") { // Check if message starts with '{' to check if it's json
//             datastring = datastring.replace(/\'/g, '"');
//             var data = JSON.parse(datastring)
//             console.log(data);
//             if (data.auth === "8hi38h4n4jr8fj4j4nriio1903") {
//                 if (data.cmd === 'signup') {
//                     signUp(data, ws);
//                 }
//                 if (data.cmd === 'login') {
//                     login(data, ws)
//                 }
//                 if (data.cmd === 'get_OTP') {
//                     getOTP(data, ws);
//                 }
//                 // TODO: Create login function
//                 // signUp(data, ws);
//             }
//         }
//     })
// })

// class Routes {
//     constructor() {
        
//     }
//     static signup = "signup";
//     static login = "login";
//     static get_OTP = "get_OTP";

//     static add_work_experience = ""
// }

// function routes(data: any, ws: WebSocket.WebSocket) {
//     switch (data.cmd) {
//         case 'signup':
//             signUp(data, ws);
//             break;
//         case 'login':
//             login(data, ws);
//             break;
//         case 'get_OTP':
//             getOTP(data, ws);
//             break;
//         default:
//             break;
//     }
// }