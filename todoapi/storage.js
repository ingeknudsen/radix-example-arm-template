const azure = require("azure-storage");

exports.todo = () => {
  const tableName = "todos";
  const partitionKey = "a-user";

  const bootstrap = () => {
    const tableService = azure.createTableService();
    tableService.createTableIfNotExists(tableName, function(error) {
      if (error) {
        throw error;
      }
    });
  };

  const getTodos = callback => {
    var tableService = azure.createTableService();
    var query = new azure.TableQuery().where("PartitionKey eq ?", partitionKey);

    tableService.queryEntities(tableName, query, null, function(error, result) {
      if (!error) {
        const todos = result.entries.map(entity => entityToTodo(entity));
        callback(todos);
      } else {
        callback(null, error);
      }
    });
  };

  const getTodoById = (id, callback) => {
    var tableService = azure.createTableService();
    tableService.retrieveEntity(tableName, partitionKey, id, function(
      error,
      result
    ) {
      if (!error) {
        callback(entityToTodo(result));
      } else {
        callback(null, error);
      }
    });
  };

  const saveTodo = todo => {
    const tableService = azure.createTableService();
    const entity = todoToEntity(todo);
    tableService.insertOrReplaceEntity(tableName, entity, function(error) {
      if (error) {
        console.log(error);
      }
    });
  };

  const deleteTodo = todoId => {
    getTodoById(todoId, function(todo) {
      const tableService = azure.createTableService();
      const entity = todoToEntity(todo);
      tableService.deleteEntity(tableName, entity, function(error) {
        if (error) {
          console.log(error);
        }
      });
    });
  };

  const todoToEntity = todo => {
    const entGen = azure.TableUtilities.entityGenerator;
    return {
      PartitionKey: entGen.String(partitionKey),
      RowKey: entGen.String(todo.id),
      name: entGen.String(todo.name),
      description: entGen.String(todo.description),
      isDone: entGen.Boolean(todo.isDone)
    };
  };

  const entityToTodo = entity => {
    return {
      id: entity.RowKey ? entity.RowKey._ : "",
      name: entity.name ? entity.name._ : "",
      description: entity.description ? entity.description._ : "",
      isDone: entity.isDone ? entity.isDone._ : false
    };
  };

  return {
    bootstrap,
    getTodos,
    getTodoById,
    saveTodo,
    deleteTodo
  };
};
