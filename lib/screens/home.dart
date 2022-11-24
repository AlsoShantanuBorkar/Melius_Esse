import 'dart:math';

import 'package:flutter/material.dart';
import 'package:melius_esse/constants.dart';
import 'package:melius_esse/providers/todo_provider.dart';
import 'package:melius_esse/widgets/todo_card.dart';
import 'package:provider/provider.dart';

import 'package:google_fonts/google_fonts.dart';
import '../models/todo_model.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();

  int currentTab = 0;

  @override
  void initState() {
    Provider.of<TodoProvider>(context, listen: false).loadFromDB();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: brightGreen,
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              TextEditingController descriptionController =
                  TextEditingController();
              return Consumer<TodoProvider>(
                builder: ((context, provider, child) {
                  return AlertDialog(
                    content: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Todo Description"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              validator: ((value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              }),
                              controller: descriptionController,
                            ),
                          ),
                          ElevatedButton(
                            child: const Text("Submit"),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                provider.appendTodo(Random().nextInt(999),
                                    descriptionController.text);
                                Navigator.pop(context);
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  );
                }),
              );
            },
          );
        },
      ),
      appBar: AppBar(
        backgroundColor: primaryShade,
        title: Text(widget.title, style: GoogleFonts.outfit()),
      ),
      backgroundColor: backgroundDeepShade,
      bottomNavigationBar: BottomAppBar(
          color: primaryShade,
          shape: const CircularNotchedRectangle(),
          notchMargin: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                color: currentTab == 1 ? Colors.white : blueVariant2,
                iconSize: 35,
                icon: const Icon(Icons.home),
                onPressed: (() {
                  setState(() {
                    currentTab = 1;
                  });
                }),
              ),
              IconButton(
                color: currentTab == 2 ? Colors.white : blueVariant2,
                iconSize: 35,
                icon: const Icon(Icons.check),
                onPressed: () {
                  setState(() {
                    currentTab = 2;
                  });
                },
              ),
            ],
          )),
      body: Consumer<TodoProvider>(
        builder: (context, provider, child) {
          List<dynamic> todoList = provider.todos;
          List<dynamic>? compeletedTodoList = provider.completedTodos;
          if (provider.isLoading || todoList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    child: const Text('Load Data'),
                    onPressed: () {
                      setState(() {
                        currentTab = 1;
                      });
                    },
                  ),
                  Container(
                    width: 200,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'If Load fails then there are no Tasks saved on device',
                      style: GoogleFonts.outfit(
                        color: const Color.fromRGBO(255, 255, 255, 0.5),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          } else {
            if (currentTab == 1) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: provider.todos.length,
                  itemBuilder: ((context, index) {
                    return TodoCard(todo: todoList[index]);
                  }),
                ),
              );
            } else {
              if (compeletedTodoList == null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 300,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          'TaskList Empty Please Complete a task',
                          style: GoogleFonts.outfit(
                              color: const Color.fromRGBO(255, 255, 255, 0.6),
                              fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: provider.completedTodos!.length,
                    itemBuilder: ((context, index) {
                      return TodoCard(todo: todoList[index]);
                    }),
                  ),
                );
              }
            }
          }
        },
      ),
    );
  }
}
