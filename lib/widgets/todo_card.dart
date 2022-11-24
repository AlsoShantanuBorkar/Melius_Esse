import 'package:flutter/material.dart';
import 'package:melius_esse/constants.dart';
import 'package:melius_esse/models/todo_model.dart';
import 'package:melius_esse/providers/todo_provider.dart';
import 'package:provider/provider.dart';

class TodoCard extends StatelessWidget {
  final Todo todo;

  const TodoCard({
    Key? key,
    required this.todo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoProvider>(builder: (context, provider, child) {
      if (provider.isLoading) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(),
            ],
          ),
        );
      }
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 15),
        child: ListTile(
          onTap: () {
            provider.updateTodo(todo);
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          tileColor: Colors.white,
          leading: Icon(
            todo.isCompleted ? Icons.check_box : Icons.check_box_outline_blank,
            color: backgroundDeepShade,
          ),
          title: Text(
            todo.description,
            style: TextStyle(
              fontSize:18 ,
              color: primaryShade,
              decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
          trailing: Container(
            padding: const EdgeInsets.all(0),
            margin: const EdgeInsets.symmetric(vertical: 12),
            height: 35,
            width: 35,
            decoration: BoxDecoration(
              color: blueVariant2,
              borderRadius: BorderRadius.circular(5),
            ),
            child: IconButton(
              color: Colors.white,
              iconSize: 18,
              icon: const Icon(Icons.delete),
              onPressed: () {
                provider.removeTodo(todo.todoId);
                // print('Clicked on delete icon');
              },
            ),
          ),
        ),
      );
    });
  }
}
