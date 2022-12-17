import React, { useContext } from "react";
import { useRouter } from "next/router";
import CategoryRenderData from "../Utils/Data/CategoryRenderData";
import Context from "../Context/Context";
import Wrapper from "../components/Wrapper";
import Image from "next/image";

const Home = () => {
  const UserCtx = useContext(Context).user;
  const Router = useRouter();

  return (
    <Wrapper>
      <div className="flex items-center justify-center min-h-[clac(100vh-8rem)]">
        {UserCtx.isLogged ? (
          <div className="flex flex-col items-center pt-10">
            <ul className="flex justify-center  max-w-[80rem] w-[80vw] flex-wrap max500:w-[97vw]">
              {CategoryRenderData.map((data) => {
                return (
                  <li
                    key={data.id}
                    className="bg-[] rounded-md mx-4 mb-7 p-4 pb-3 max500:mx-2 max500:mb-4 flex flex-col justify-center items-center cursor-pointer shadow-lg max500:p-3 max500:pb-1 backdrop-blur-3xl bg-slate-50"
                    onClick={() => {
                      Router.push(`/category/${data.id}?id=${data.id}`);
                    }}
                  >
                    <Image
                      src={data.imgSrc}
                      alt={data.name}
                      className="w-12 h-12 mx-3 max500:mx-2 max500:w-8 max500:h-8"
                      height={"2.5rem"}
                      width={"2.5rem"}
                    />

                    <h4
                      className={`${data.id}TextColor mt-3 max500:mt-2 inderFont`}
                    >
                      {data.name}
                    </h4>
                  </li>
                );
              })}
            </ul>
          </div>
        ) : (
          <div className="flex items-center justify-center mt-20">
            <button
              className="bg-slate-50 rounded-md shadow-md w-[7.1rem] mx-5 py-2 flex text-black justify-center items-center"
              onClick={() => {
                Router.push("/user/register");
              }}
            >
              Register
            </button>
            <button
              className="bg-slate-50 rounded-md shadow-md w-[7.1rem] py-2 mx-5 text-black flex justify-center items-center"
              onClick={() => {
                Router.push("/user/login");
              }}
            >
              Login
            </button>
          </div>
        )}
      </div>
    </Wrapper>
  );
};

export default Home;
