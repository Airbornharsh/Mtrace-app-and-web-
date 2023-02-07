import axios from "axios";
import { useContext, useEffect, useRef, useState } from "react";
import { useRouter } from "next/router";
import Context from "../Context/Context";
import NavBar from "./NavBar";
import Loader from "../Utils/Loader";

const Wrapper = (props) => {
  // const [expenses, setExpenses] = useState([]);
  const [loader, setLoader] = useState(false);
  const Ctx = useRef(useContext(Context));
  const UserCtx = useRef(useContext(Context).user);

  // Ctx.setExpenseData(expenses);

  const router = useRef(useRouter());

  // useEffect(() => {
  //   setLoader(true);

  //   if (Ctx.current.accessToken) {
  //     UserCtx.current.setIsLogged(true);
  //     const onLoad = async () => {
  //       try {
  //         const userData = await axios.get(
  //           `http://localhost:3000/api/userdata`,
  //           {
  //             headers: {
  //               authorization: `Bearer ${window.localStorage.getItem(
  //                 "TracerAccessToken"
  //               )}`,
  //             },
  //           }
  //         );

  //         Ctx.current.setUserData(userData.data);

  //         const data = await axios.get(
  //           `http://localhost:3000/api/expenses/get`,
  //           {
  //             headers: {
  //               authorization: `Bearer ${window.localStorage.getItem(
  //                 "TracerAccessToken"
  //               )}`,
  //             },
  //           }
  //         );
  //         Ctx.current.setExpenseData(data.data);
  //         setLoader(false);
  //       } catch (e) {
  //         if (e.response.status === 401) {
  //           router.current.push("/user/login");
  //         }
  //         setLoader(false);
  //       }
  //     };

  //     onLoad();
  //   } else {
  //     console.log("not Logged");
  //     UserCtx.current.setIsLogged(false);
  //     setLoader(false);
  //   }
  // }, []);

  return (
    <div className="flex flex-col items-center justify-start min-h-screen min-w-screen bg-slate-300">
      {loader ? (
        <div className=" wrapper gooey">
          <span className="dot"></span>
          <div className="dots">
            <span></span>
            <span></span>
            <span></span>
          </div>
        </div>
      ) : (
        <div className="relative flex flex-col items-center justify-start min-h-screen min-w-screen ">
          <Loader />
          <NavBar />
          {props.children}
        </div>
      )}
    </div>
  );
};

export default Wrapper;
