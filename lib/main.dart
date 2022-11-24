import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:melius_esse/models/todo_model.dart';
import 'package:melius_esse/providers/todo_provider.dart';
import 'package:melius_esse/screens/home.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDirectory.path);
  Hive.registerAdapter(TodoAdapter());
  var box = await Hive.openBox('myBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TodoProvider>(
            create: (context) => TodoProvider())
      ],
      child: const MaterialApp(
        title: 'Melius Esse',
        home: MyHomePage(title: 'Melius Esse'),
      ),
    );
  }
}
