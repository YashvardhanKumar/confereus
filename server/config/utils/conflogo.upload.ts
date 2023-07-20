import multer, { diskStorage } from "multer";

const storage = diskStorage({
    destination(req, file, callback) {
        callback(null, './uploads');
    },
    filename(req, file, callback) {
        callback(null, new Date().toISOString().replace(/:/g, '-') + '-' + file.originalname)
    },

})

const fileFilter = (req, file: Express.Multer.File, callback) => {
    if (file.mimetype === 'image/png' || file.mimetype === 'image/jpg' || file.mimetype === 'image/jpej') {
        callback(null, true);
    } else {
        callback(null, true);
    }

}

export const uploads = multer({storage: storage, fileFilter: fileFilter,dest: 'uploads/',limits: {
    fileSize: 1024 * 1024 * 6,
  },});