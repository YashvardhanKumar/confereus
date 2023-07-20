'use strict'
import bodyParser from 'body-parser';
import express from 'express';
import userRouter from './routes/user/user.router';
import session, { CookieOptions } from 'express-session';
import UserService from './services/user.services';
import cors from 'cors';
import {createServer} from 'http';
import cookieParser from 'cookie-parser';
import deeplinkRouter from './routes/user/deeplink/r/deeplink.router';
import conferenceRoute from './routes/user/conference/conference.router';
import profileRouter from './routes/user/profile/profile.router';
import eventRoute from './routes/user/conference/event.router';
import {diskStorage} from 'multer';
import path from 'path';
declare module 'express-session' {
    interface SessionData {
        user: { [key: string]: any };
    }
}



const app = express();
let http = createServer(app);

app.use(cookieParser());
app.use(cors(
    {
    origin: ["http://localhost:3000", "http://127.0.0.1:3000", "http://192.168.64.144:3000"],
    credentials: true,
}
));
app.use(bodyParser.urlencoded({extended: true}));
// app.use(express.urlencoded({extended: true}));
app.use(bodyParser.json());
app.use('/uploads',express.static(path.join(__dirname, 'uploads')));

app.use('/', userRouter);
app.use('/applink/r', deeplinkRouter);
app.use('/:id/conferences',conferenceRoute);
app.use('/:id/conferences/:confId/events',eventRoute);
app.use('/:id/profile',profileRouter);


// app.use('/:id/profile');
// app.use('/:id/home');


export {app, http};

