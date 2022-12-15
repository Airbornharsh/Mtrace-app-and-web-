import { compare, hash } from "bcrypt";
import { default as DbConnect } from "../../Server/config/DB_config";

const ChangePassword = async (req, res, next) => {
  try {
    const { user } = await DbConnect();

    const tempUser = await user.findOne({ emailId: req.user.emailId });
    if (!tempUser) {
      return res.status(400).send(`No Such ${req.user.emailId} Id Exist`);
    }

    const passwordSame = await compare(req.body.password, tempUser.password);
    
    if (!passwordSame) {
      return res.status(402).send("Wrong Password");
    }

    const hashPassword = await hash(req.body.newPassword, 10);
    const updatedUser = await user.findByIdAndUpdate(tempUser._id, {
      password: hashPassword,
    });
    res.send(updatedUser);
  } catch (e) {
    console.log(e);
    res.send(e.message);
  }
};

export default ChangePassword;
