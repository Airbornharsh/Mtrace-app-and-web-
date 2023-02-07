import { hash } from "bcrypt";
import DbConnect from "../../Server/config/DB_config";

const Register = async (req, res, next) => {
  try {
    const DbModels = await DbConnect();

    const tempUser = await DbModels.user.find({ emailId: req.body.emailId });
    if (tempUser[0]) {
      return res.status(400).send("Email Id Exist!");
    }

    const hashPassword = await hash(req.body.password.trim(), 10);

    const newUser = new DbModels.user({
      emailId: req.body.emailId,
      name: req.body.name,
      income: req.body.income || null,
      password: hashPassword,
    });

    const data = await newUser.save();

    return res.send(data);
  } catch (e) {
    console.log(e);
    res.status(500).send(e.message);
  }
};

export default Register;
