import { Schema, models, model } from "mongoose";

const expensesSchema = new Schema({
  time: {
    type: Date,
    default: Date.now(),
  },
  amount: {
    type: Number,
    required: true,
  },
  title: {
    type: String,
    required: true,
  },
  category: {
    type: String,
    required: true,
  },
  emailId: {
    type: String,
    required: true,
  },
});

export default models.Expenses || model("Expenses", expensesSchema);
