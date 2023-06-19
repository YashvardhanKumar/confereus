import { Router } from "express";
import { getLinkedinUser } from "../../../../config/linkedin.config";

const deeplinkRouter = Router();

deeplinkRouter.post('/linkedinlogin',getLinkedinUser);
deeplinkRouter.get('/facebooklogin',getLinkedinUser);

export default deeplinkRouter;