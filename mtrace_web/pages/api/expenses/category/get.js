import DbConnect from "../../../../Server/config/DB_config";

const ExpensesCategoryGet = async (req, res, next) => {
  try {
    const { expenses } = await DbConnect();

    const data = await expenses.find({
      category: req.params.categoryId,
      emailId: req.user.emailId,
    });
    res.send(data);
  } catch (e) {
    console.log(e);
    res.status(500).send(e);
  }
};

module.exports = ExpensesCategoryGet;
