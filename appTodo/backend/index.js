const express = require("express");
const cors = require("cors");
const app = express();
const port = 3000;

app.use(cors());
app.use(express.json());

const users = [
  { id: "1", name: "Luli Manucians" },
  { id: "2", name: "Thái Bình Độ" },
  { id: "3", name: "Thái Bình Độ 123" },
];

app.get("/users", (req, res) => {
  res.json(users);
});

app.post("/users", (req, res) => {
  const { name } = req.body;
  if (!name) return res.json({ status: "error" });
  const newUser = { id: Date.now().toString(), name };
  users.push(newUser);
  res.json({ status: "success", user: newUser });
});

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`);
});
