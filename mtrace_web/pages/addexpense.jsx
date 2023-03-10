import React, { useContext, useState } from "react";
import axios from "axios";
import Context from "../Context/Context";
import { useRouter } from "next/router";
import Wrapper from "../components/Wrapper";

const AddExpense = () => {
  const [category, setCategory] = useState("food");
  const [title, setTitle] = useState("");
  const [amount, setAmount] = useState("");
  const UtilCtx = useContext(Context).util;
  const Ctx = useContext(Context);

  const router = useRouter();

  const submitExpense = async (e) => {
    e.preventDefault();
    UtilCtx.setLoader(true);

    try {
      const data = await axios.post(
        `http://localhost:3000/expenses`,
        {
          title,
          amount,
          category,
        },
        {
          headers: {
            authorization: `Bearer ${localstorage.getItem(
              "TracerAccessToken"
            )}`,
          },
        }
      );

      Ctx.setExpenseData([...Ctx.expenseData, data.data]);
      UtilCtx.setLoader(false);
      router.push("/");
    } catch (e) {
      console.log(e.message);
      UtilCtx.setLoader(false);
    }
  };

  return (
    <Wrapper>
      <div className="mt-12">
        <div className="max-w-[28rem] w-[90vw]  bg-white mb-28 rounded-xl shadow-xl relative">
          <form className="inderFont flex flex-col px-[4rem] py-12  items-center">
            <ul className="mb-7">
              <li className="flex flex-col mb-6">
                <label className="text-[1.5rem]">Category</label>
                <select
                  className="max-w-[20rem] w-[80vw] h-10 bg-Color2 p-1 px-2"
                  placeholder="Select Your Type"
                  value={category}
                  onChange={(e) => {
                    setCategory(e.target.value);
                  }}
                >
                  <option value="food">Food</option>
                  <option value="travel">Travel</option>
                  <option value="drink">Drink</option>
                  <option value="bill">Bill</option>
                  <option value="study">Study</option>
                  <option value="cloth">Cloth</option>
                </select>
              </li>
              <li className="flex flex-col mb-6">
                <label className="text-[1.5rem]">Title</label>
                <input
                  type="text"
                  className="max-w-[20rem] w-[80vw] h-10 bg-Color2 p-1 px-2"
                  placeholder="Write Your Title Here ..."
                  value={title}
                  onChange={(e) => {
                    setTitle(e.target.value);
                  }}
                />
              </li>
              <li className="flex flex-col mb-6">
                <label className="text-[1.5rem]">Amount</label>
                <input
                  type="Number"
                  className="max-w-[20rem] w-[80vw] h-10 bg-Color2 p-1 px-2"
                  placeholder="Write Your Amount Here ..."
                  value={amount}
                  onChange={(e) => {
                    setAmount(e.target.value);
                  }}
                />
              </li>
            </ul>
            <button
              className="bg-Color3 rounded-md shadow-md w-[7.1rem] py-2 flex justify-center items-center"
              onClick={submitExpense}
            >
              Add Expense
            </button>
          </form>
        </div>
      </div>
    </Wrapper>
  );
};

export default AddExpense;
