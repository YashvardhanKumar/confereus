import { Router } from "express";
import { isAuthenticated, isTokenNotExpired } from "../../../middlewares/user.middleware";
import { addEducation, addSkill, addWorkSpace, deleteEducation, deleteSkills, deleteWorkSpace, editEducation, editProfile, editSkill, editWorkSpace, fetchProfile } from "../../../controller/profile.controller";
import catchAsync from "../../../services/catchAsync";

const profileRouter = Router({ mergeParams: true });

profileRouter.get('/', isAuthenticated, isTokenNotExpired, fetchProfile)
    .patch('/edit', isAuthenticated, isTokenNotExpired, editProfile)

profileRouter.post('/workspace/add', isAuthenticated, isTokenNotExpired, catchAsync(addWorkSpace))
    .patch('/workspace/:wid/edit', isAuthenticated, isTokenNotExpired, catchAsync(editWorkSpace))
    .delete('/workspace/:wid/delete', isAuthenticated, isTokenNotExpired, catchAsync(deleteWorkSpace));

profileRouter.post('/education/add', isAuthenticated, isTokenNotExpired, catchAsync(addEducation))
    .patch('/education/:eid/edit', isAuthenticated, isTokenNotExpired, catchAsync(editEducation))
    .delete('/education/:eid/delete', isAuthenticated, isTokenNotExpired, catchAsync(deleteEducation));

profileRouter.post('/skills/add', isAuthenticated, isTokenNotExpired, catchAsync(addSkill))
    .patch('/skills/:sid/edit', isAuthenticated, isTokenNotExpired, catchAsync(editSkill))
    .delete('/skills/:sid/delete', isAuthenticated, isTokenNotExpired, catchAsync(deleteSkills));

export default profileRouter;