import { Router } from "express";
import { login, logout, refreshToken, sendMail, signUp, verifiedEmail } from "../../controller/user.controller";
import { canCreateUser, checkPassword, doesUserExist, hashPassword, isAuthenticated, isTokenNotExpired, sendOTPToMail, verifyOTP } from "../../middlewares/user.middleware";
import { getLinkedinUser } from "../../config/linkedin.config";

const userRouter = Router();

userRouter.post('/signup', canCreateUser, hashPassword, signUp)
userRouter.post('/login',doesUserExist,checkPassword,login);
userRouter.post('/sendmail',isAuthenticated,sendOTPToMail,sendMail);
userRouter.post('/verifymail',isAuthenticated,verifyOTP,verifiedEmail);
userRouter.post('/logout', isAuthenticated,logout);
userRouter.put('/refreshtoken',isAuthenticated,isTokenNotExpired,refreshToken);

// userRouter.post('/signin-linkedin',getLinkedinUser)

export default userRouter;