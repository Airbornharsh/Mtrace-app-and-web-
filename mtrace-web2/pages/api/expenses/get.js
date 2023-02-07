import DbConnect from "../../../Server/config/DB_config";
import jwt from "jsonwebtoken";

const ExpensesGet = async (req, res, next) => {
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

    const data = await expenses.find({ emailId: tempUser.emailId });

    res.send(data);
  } catch (e) {
    console.log(e);
    res.status(500).send(e);
  }
};

module.exports = ExpensesGet;
