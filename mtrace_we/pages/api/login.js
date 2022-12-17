import { compare } from "bcrypt";
import { sign } from "jsonwebtoken";
import { default as DbConnect } from "../../Server/config/DB_config";

const Login = async (req, res) => {
  try {
    const DbModels = await DbConnect();

    const tempUser = await DbModels.user.findOne({ emailId: req.body.emailId });
    if (!tempUser) {
      return res.status(400).send(`No Such ${req.body.emailId} Id Exist`);
    }
    

    const passwordSame = await compare(req.body.password, tempUser.password);

    if (!passwordSame) {
      return res.status(401).send("Wrong Password");
    }

    const authUser = { emailId: req.body.emailId };

    const accessToken = sign(authUser, process.env.JWT_SECRET);

    res.send({ accessToken });
  } catch (e) {
    console.log(e);
    res.send(e.message);
  }
};

export default Login;
