import type { Config } from "tailwindcss";
const config: Config = {
  content: ["./app/**/*.{js,ts,jsx,tsx,mdx}", "./src/**/*.{js,ts,jsx,tsx,mdx}"],
  theme: {
    extend: {
      colors: {
        petal: { 50: "#fff6f8", 100: "#ffe7ee", 200: "#ffcdda", 300: "#ffa4bd", 400: "#fb6b96", 500: "#df2b68", 600: "#c71955", 700: "#a81245", 800: "#8d123d", 900: "#761437" },
        leaf: { 50: "#f2f8f4", 100: "#dcecdf", 500: "#2f6d51", 700: "#214b3b", 900: "#17372c" },
        cream: "#fffaf2"
      },
      boxShadow: { soft: "0 18px 55px rgba(89, 45, 61, 0.10)", card: "0 12px 30px rgba(89, 45, 61, 0.08)" },
      borderRadius: { "4xl": "2rem" }
    }
  },
  plugins: []
};
export default config;
