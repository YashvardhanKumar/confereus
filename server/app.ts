import bodyParser from 'body-parser';
import express from 'express';
import userRouter from './routes/user_router';
const app = express();
app.use(bodyParser.json());

app.use('/', userRouter);

export default app;

