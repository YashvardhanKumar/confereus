import { NextFunction, Request, Response } from "express";

export default catchAsync => {
    return (req: Request, res: Response, next:NextFunction) => {
        catchAsync(req, res, next).catch(next);
    }
}