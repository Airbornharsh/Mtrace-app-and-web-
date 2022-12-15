import DbConnect from "../../../Server/config/DB_config";

const ExpenseGet = async (req, res) => {
  try {
    const { expenses } = await DbConnect();

    if (req.params.id.length !== 24) {
      return res.status(400).send("Wrong Expense Id");
    }
    const data = await expenses.findOne({
      _id: req.params.id,
      emailId: req.user.emailId,
    });

    res.send(data);
  } catch (e) {
    console.log(e);
  }
};

export default ExpenseGet;
