const express = require("express");
const bodyParser = require("body-parser");
const storageAccount = require("./storage");

const storage = storageAccount.todo();
const app = express();

// TODO: error handling in general
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

app.get("/todos", (req, res) => {
  storage.getTodos(function(todos) {
    res.json(todos);
  });
});

app.get("/todos/:todoId", (req, res) => {
  storage.getTodoById(req.params.todoId, function(todo) {
    res.json(todo);
  });
});

app.post("/todos", (req, res) => {
  storage.saveTodo(req.body);
  res.end();
});

app.put("/todos/:todoId", (req, res) => {
  storage.saveTodo(req.body);
  res.end();
});

app.delete("/todos/:todoId", (req, res) => {
  storage.deleteTodo(req.params.todoId);
  res.end();
});

app.listen(3000, () => {
  storage.bootstrap();

  console.log("Server running on port 3000");
});
