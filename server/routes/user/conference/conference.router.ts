import { Router } from "express";
import { addConference, deleteConference, editConference, fetchConferences } from "../../../controller/conference.controller";
import { isAuthenticated, isTokenNotExpired } from "../../../middlewares/user.middleware";
import catchAsync from "../../../services/catchAsync";

const conferenceRoute = Router({ mergeParams : true });

conferenceRoute.get('/', isAuthenticated, isTokenNotExpired, catchAsync(fetchConferences))
    .post('/add', isAuthenticated, isTokenNotExpired, catchAsync(addConference))
    .patch('/edit/:confId', isAuthenticated, isTokenNotExpired, catchAsync(editConference))
    .delete('/delete/:confId', isAuthenticated, isTokenNotExpired, catchAsync(deleteConference))

export default conferenceRoute;