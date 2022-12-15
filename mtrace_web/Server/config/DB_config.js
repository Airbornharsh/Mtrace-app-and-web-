import dotenv from "dotenv";
import mongoose from "mongoose";
import user from "../models/user";
import expenses from "../models/expenses";

const DB_URI = process.env.DB_URI;

let count = 0;

const DbConnect = async () => {
  try {
    const connect = await mongoose.connect(DB_URI);
    console.log(count++);
    console.log("DB Connected");

    return {
      connect,
      user,
      expenses,
    };
  } catch (e) {
    console.log(e);
  }
};

export default DbConnect;
