import { Router } from "express";
import { addConference, deleteConference, editConference, fetchConferences, fetchRegisteredConferences, registerConference } from "../../../controller/conference.controller";
import { checkAccessToken, isAuthenticated, isTokenNotExpired } from "../../../middlewares/user.middleware";
import catchAsync from "../../../services/catchAsync";
import { uploads } from "../../../config/utils/conflogo.upload";
import { editLogoConf } from "../../../controller/fileUploader.controller";

const conferenceRoute = Router({ mergeParams: true });

conferenceRoute.get('/', isAuthenticated, isTokenNotExpired, catchAsync(fetchConferences))
.patch('/:confId/uploadLogo', checkAccessToken,uploads.single("picture"),catchAsync(editLogoConf))
    .post('/add', isAuthenticated, isTokenNotExpired, catchAsync(addConference))
    .patch('/edit/:confId', isAuthenticated, isTokenNotExpired, catchAsync(editConference))
    .delete('/delete/:confId', isAuthenticated, isTokenNotExpired, catchAsync(deleteConference))

conferenceRoute.get('/registered', isAuthenticated, isTokenNotExpired, catchAsync(fetchRegisteredConferences))
    .post('/:confId/register', isAuthenticated, isTokenNotExpired, catchAsync(registerConference));

export default conferenceRoute;