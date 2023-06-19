import { connect } from "mongoose";
import * as dotenv from "dotenv";

dotenv.config();


connect(`mongodb+srv://${process.env.MONGO_USERNAME}:${process.env.MONGO_PASSWORD}@confereusauth.7ihufgu.mongodb.net`)
    .then((_) => console.log("Connected to database."))
    .catch((e) => console.log("Error:", e)); // Open MongoDB.