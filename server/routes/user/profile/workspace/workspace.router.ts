import { Router } from "express";

const workspaceRouter = Router();

workspaceRouter.get('/profile/workspace')
    .post('/profile/workspace/add')
    .put('/profile/workspace/edit')
    .delete('/profile/workspace/remove');

workspaceRouter.get('/profile/education')
    .post('/profile/add/education')
    .put('/profile/edit/education/edit')
    .delete('/profile/del/education/');