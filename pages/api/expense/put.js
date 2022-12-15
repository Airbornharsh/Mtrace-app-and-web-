import DbConnect from "../../../Server/config/DB_config";

const Put = async (req, res) => {

  try {
    const { expenses } = await DbConnect();

    if (req.body.title) {
      await expenses.findByIdAndUpdate(req.body.id, {
        title: req.body.title,
        amount: req.body.amount,
      });
    }

    res.send("Updated");
  } catch (e) {
    console.log(e);
    res.send(500).send(e);
  }
};

export default Put;
