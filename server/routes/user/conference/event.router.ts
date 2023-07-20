import { Router } from "express";
import { addEvent, deleteEvent, editEvent, getEvent } from "../../../controller/event.controller";
import { isAuthenticated, isTokenNotExpired } from "../../../middlewares/user.middleware";
import catchAsync from "../../../services/catchAsync";

const eventRoute = Router({ mergeParams : true });

eventRoute
    .get('/', isAuthenticated, isTokenNotExpired, getEvent)
    .post('/add', isAuthenticated, isTokenNotExpired, catchAsync(addEvent))
    .patch('/edit/:eventId', isAuthenticated, isTokenNotExpired, catchAsync(editEvent))
    .delete('/delete/:eventId', isAuthenticated, isTokenNotExpired, catchAsync(deleteEvent))

export default eventRoute;