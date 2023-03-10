/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./pages/**/*.{js,ts,jsx,tsx}",
    "./components/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        // Color1: "#FFE74C",
        // Color2: "#D9D9D9",
        // Color3: "#FCDA00",
        Color1: "white",
        Color2: "#D9D9D9",
        Color3: "#FCDA00",
        Color4: "#ffffff",
        Color5: "rgba(255, 231, 76,0.6)",
      },
      screens: {
        max800: { max: "800px" },
        max550: { max: "550px" },
        max500: { max: "500px" },
        max400: { max: "400px" },
      },
    },
  },
  plugins: [],
};
