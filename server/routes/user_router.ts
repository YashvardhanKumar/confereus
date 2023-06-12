import { Router } from "express";
import { registerUser } from "../controller/user_controller";

const router = Router();

const userRouter = router.post('/signup', registerUser);

export default userRouter;