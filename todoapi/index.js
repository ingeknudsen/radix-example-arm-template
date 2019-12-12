var express = require("express");
var bodyParser = require("body-parser");
var app = express();

app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

var todos = [];
app.get("/todos", (req, res) => {
  res.json(todos);
});

app.get("/todos/:todoId", (req, res) => {
  const todo = todos.find(t => t.id == req.params.todoId);
  res.json(todo);
});

app.post("/todos", (req, res) => {
  todos.push(req.body);
  res.end();
});

app.delete("/todos/:todoId", (req, res) => {
  todos.splice(
    todos.findIndex(x => x.id == req.params.todoId),
    1
  );
});

app.listen(3000, () => {
  console.log("Server running on port 3000");
});
