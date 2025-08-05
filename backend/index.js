const express = require("express");
const cors = require("cors");
const app = express();
const port = 3000;

app.use(cors());
app.use(express.json());

const users = [
  { id: 1, name: "Luli Manucians" },
  { id: 2, name: "Luli 123" },
  { id: 3, name: "Luli" },
  { id: 4, name: "Thái Bình Độ" },
  { id: 5, name: "Thái Bình Độ 123" },
];

app.get("/users", (req, res) => {
  res.json(users);
});

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`);
});
