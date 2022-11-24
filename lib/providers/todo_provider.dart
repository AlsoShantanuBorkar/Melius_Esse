import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:melius_esse/models/todo_database_model.dart';
import 'package:melius_esse/models/todo_model.dart';

class TodoProvider extends ChangeNotifier {
  final _myBox = Hive.box("myBox");

  List<dynamic> _todoList = [];
  List<dynamic> _completeTodoList = [];
  bool isLoading = false;
  List<dynamic> get todos => _todoList;
  List<dynamic>? get completedTodos {
    return updateCompletedTodos();
  }

  appendTodo(int id, String description) {
    isLoading = true;
    notifyListeners();
    _todoList.add(Todo(todoId: id, description: description));
    _saveToDB();
    isLoading = false;
    notifyListeners();
  }

  removeTodo(int id) {
    isLoading = true;
    notifyListeners();
    _todoList.removeWhere((element) => element.todoId == id);
    _completeTodoList.removeWhere((element) => element.todoId == id);
    _saveToDB();
    isLoading = false;
    notifyListeners();
  }

  updateTodo(Todo todo) {
    isLoading = true;
    notifyListeners();
    int index = _todoList.indexOf(todo);
    _todoList[index].isCompleted = !_todoList[index].isCompleted;
    updateCompletedTodos();
    _saveToDB();
    isLoading = false;
    notifyListeners();
  }

  _saveToDB() async {
    isLoading = true;
    notifyListeners();
    await _myBox.put('TODOLIST', _todoList);
    isLoading = false;
    notifyListeners();
  }

  loadFromDB() async {
    _todoList = await _myBox.get('TODOLIST');
  }

  updateCompletedTodos() {
    _completeTodoList =
        _todoList.where((element) => element.isCompleted == true).toList();
  }
}
