const express = require("express");
const cors = require("cors");
const app = express();
const port = 3000;

app.use(cors());
app.use(express.json());

let users = [
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

app.delete("/users/:id", (req, res) => {
  const { id } = req.params;
  console.log(id);
  users = users.filter((u) => u.id !== id);
  console.log(users);
  res.json({ status: "success", message: "Deleted sucessFull" });
});

app.put("/users/:id", (req, res) => {
  const { id } = req.params;
  const { name } = req.body;
  const user = users.find((u) => u.id === id);
  if (!user) res.status(404).json({ message: "User not found" });
  user.name = name;
  console.log(user);
  res.json(user);
});

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`);
});
