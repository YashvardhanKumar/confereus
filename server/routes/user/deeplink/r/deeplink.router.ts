import { Router } from "express";
import { getLinkedinUser } from "../../../../config/linkedin.config";
import catchAsync from "../../../../services/catchAsync";

const deeplinkRouter = Router({ mergeParams : true });

deeplinkRouter.post('/linkedinlogin',catchAsync(getLinkedinUser));
deeplinkRouter.get('/facebooklogin',catchAsync(getLinkedinUser));

export default deeplinkRouter;