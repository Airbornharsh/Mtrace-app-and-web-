import DbConnect from "../../Server/config/DB_config";
import jwt from "jsonwebtoken";

const UserData = async (req, res, next) => {
  const authHeader = req.headers["authorization"];
  const accessToken = authHeader && authHeader.split(" ")[1];

  try {
    const { user } = await DbConnect();

    let tempUser;
    let tempErr;

    jwt.verify(accessToken, process.env.JWT_SECRET, (err, temp) => {
      tempErr = err;
      tempUser = temp;
    });

    if (tempErr) return res.status(401).send("Not Authorized");

    const userData = await user.findOne({ emailId: tempUser.emailId });

    res.send(userData);
  } catch (e) {
    res.status(500).send(e.message);
  }
};

export default UserData;
