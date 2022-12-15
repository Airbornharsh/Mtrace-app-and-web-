import DbConnect from "../../../Server/config/DB_config";
import jwt from "jsonwebtoken";

const Post = async (req, res, next) => {
  const authHeader = req.headers["authorization"];
  const accessToken = authHeader && authHeader.split(" ")[1];
  
  try {
    const { expenses } = await DbConnect();

    let tempUser;
    let tempErr;

    jwt.verify(accessToken, process.env.JWT_SECRET, (err, temp) => {
      tempErr = err;
      tempUser = temp;
    });

    if (tempErr) return res.status(401).send("Not Authorized");

    const Expense = new expenses({
      amount: req.body.amount,
      title: req.body.title,
      time: Date.now(),
      category: req.body.category.toLowerCase(),
      emailId: tempUser.emailId,
    });
    const data = await Expense.save();

    res.send(data);
  } catch (e) {
    console.log(e);
  }
};

export default Post;
