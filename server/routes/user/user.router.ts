import { Router } from "express";
import { getAllUsers, login, logout, refreshToken, sendMail, signUp, verifiedEmail } from "../../controller/user.controller";
import { canCreateUser, checkPassword, checkTokenForLogin, doesUserExist, hashPassword, isAuthenticated, isTokenNotExpired, sendOTPToMail, verifyOTP } from "../../middlewares/user.middleware";
import { getLinkedinUser } from "../../config/linkedin.config";
import catchAsync from "../../services/catchAsync";

const userRouter = Router({ mergeParams : true });

userRouter.post('/signup', canCreateUser, hashPassword, signUp)
userRouter.post('/login',doesUserExist,checkPassword,login);
userRouter.post('/sendmail',isAuthenticated,sendOTPToMail,sendMail);
userRouter.post('/verifymail',isAuthenticated,verifyOTP,verifiedEmail);
userRouter.post('/logout', isAuthenticated,catchAsync(logout));
userRouter.put('/refreshtoken',isAuthenticated,checkTokenForLogin,catchAsync(refreshToken));
userRouter.get('/getAllUsers', isAuthenticated,isTokenNotExpired, catchAsync(getAllUsers));

// userRouter.post('/signin-linkedin',getLinkedinUser)

export default userRouter;