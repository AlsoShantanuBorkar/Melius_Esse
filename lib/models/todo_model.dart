import 'package:hive/hive.dart';

part 'todo_model.g.dart';

@HiveType(typeId: 0)
class Todo {
  @HiveField(0)
  int todoId;
  @HiveField(1)
  String description;
  @HiveField(2)
  bool isCompleted;

  Todo({
    required this.todoId,
    required this.description,
    this.isCompleted = false,
  });
}
