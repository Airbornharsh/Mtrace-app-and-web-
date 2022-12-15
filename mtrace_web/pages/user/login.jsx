import React, { useState } from "react";
import { useRouter } from "next/router";
import Link from "next/link";
import axios from "axios";
import { useContext } from "react";
import Context from "../../Context/Context";
import Wrapper from "../../components/Wrapper";

const Login = () => {
  const [emailId, setEmailId] = useState("");
  const [password, setPassword] = useState("");
  const UtilCtx = useContext(Context).util;
  const UserCtx = useContext(Context).user;
  const Ctx = useContext(Context);

  const router = useRouter();

  const LoginSubmit = async (e) => {
    e.preventDefault();

    UtilCtx.setLoader(true);

    try {
      const res = await axios.post(`http://localhost:3000/api/login`, {
        emailId,
        password,
      });
      Ctx.setAccessToken(res.data.accessToken);
      await AppFunction(res.data.accessToken);
      UtilCtx.setLoader(false);
      UserCtx.setIsLogged(true);
      router.push("/");
    } catch (e) {
      console.log(e);
      UtilCtx.setLoader(false);
    }
  };

  const AppFunction = async (token) => {
    UtilCtx.setLoader(true);

    if (token) {
      UserCtx.setIsLogged(true);
      try {
        const userData = await axios.get(`http://localhost:3000/api/userdata`, {
          headers: {
            authorization: `Bearer ${token}`,
          },
        });
        
        Ctx.setUserData(userData.data);
        
        const data = await axios.get(`http://localhost:3000/api/expenses/get`, {
          headers: {
            authorization: `Bearer ${token}`,
          },
        });
        Ctx.setExpenseData(data.data);
        UtilCtx.setLoader(false);
      } catch (e) {
        console.log(e);
        UtilCtx.setLoader(false);
      }
    }
  };

  return (
    <Wrapper>
      <div className="max-w-[25rem] bg-slate-50 my-28 rounded-xl shadow-xl relative flex flex-col items-center w-[90vw]">
        <form className="inderFont flex flex-col px-[2rem] py-6 max500:px-[1rem]  items-center ">
          <ul className="mb-7">
            <li className="flex flex-col mb-3">
              <label className="text-slate-700">Email Id</label>
              <input
                type="Email"
                className="w-[80vw] max-w-[20rem] h-10 bg-slate-200 p-1 px-2 text-[0.9rem]"
                placeholder="Enter Your EmailId"
                value={emailId}
                onChange={(e) => {
                  setEmailId(e.target.value);
                }}
              />
            </li>
            <li className="flex flex-col mb-3">
              <label className="text-slate-700">Password</label>
              <input
                type="Password"
                className="h-10 bg-slate-200 p-1 px-2 w-[80vw] max-w-[20rem] text-[0.9rem]"
                placeholder="Write Your Password Here ..."
                value={password}
                onChange={(e) => {
                  setPassword(e.target.value);
                }}
              />
            </li>
          </ul>
          <button
            className="bg-slate-700 text-slate-200 rounded-md shadow-md w-[7.1rem] py-2 flex justify-center items-center"
            onClick={LoginSubmit}
          >
            Login
          </button>
        </form>
        <Link href="/user/register" className="mb-5 text-slate-600">
          Register Instead
        </Link>
      </div>
    </Wrapper>
  );
};

export default Login;
