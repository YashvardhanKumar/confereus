import bodyParser from 'body-parser';
import express from 'express';
import userRouter from './routes/user/user.router';
import session, { CookieOptions } from 'express-session';
import UserService from './services/user.services';
import cors from 'cors';
import cookieParser from 'cookie-parser';
import deeplinkRouter from './routes/user/deeplink/r/deeplink.router';

declare module 'express-session' {
    interface SessionData {
        user: { [key: string]: any };
    }
}

const app = express();
app.use(cookieParser());
app.use(cors(
    {
    origin: ["http://localhost:3000", "http://127.0.0.1:3000", "http://192.168.64.144:3000"],
    credentials: true,
}
));
app.use(bodyParser.urlencoded({extended: true}));
app.use(bodyParser.json());

app.use('/', userRouter);
app.use('/applink/r', deeplinkRouter);
// app.use('/:id/profile');
// app.use('/:id/home');


export default app;

