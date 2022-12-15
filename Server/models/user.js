import { Schema, models, model } from "mongoose";


const userSchema = new Schema({
  emailId: {
    type: String,
    unique: true,
    required: true,
  },
  name: {
    type: String,
    required: true,
  },
  income: {
    type: Number,
    required: false,
  },
  password: {
    type: String,
    required: true,
  },
  createdAt: {
    type: Date,
    default: Date.now(),
  },
});

export default models.User || model("User", userSchema);
