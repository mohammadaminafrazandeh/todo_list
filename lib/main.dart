import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list/data/model/data.dart';
import 'package:todo_list/data_source/hive_task_datasource.dart';
import 'package:todo_list/home/home.dart';
import 'package:todo_list/repository/repository.dart';
import 'package:provider/provider.dart';

const taskBoxName = 'tasks';
void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(PriorityAdapter());
  await Hive.openBox<TaskEntity>(taskBoxName);
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: primaryVariantColor));
  runApp(
    ChangeNotifierProvider(
        create: (context) => Repository<TaskEntity>(
              HiveTaskDataSource(
                Hive.box(taskBoxName),
              ),
            ),
        child: const MyApp()),
  );
}

const Color primaryColor = Color(0xff794cff);
const Color primaryVariantColor = Color(0xff5c0aff);
const Color secondaryTextColor = Color(0xffafbed0);
const Color normalPriorityColor = Color(0xfff09819);
const Color lowPriorityColor = Color(0xff3be1f1);
const Color highPriorityColor = primaryColor;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryTextColor = Color(0xff1d2830);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo List',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(const TextTheme(
            titleLarge: TextStyle(fontWeight: FontWeight.bold))),
        inputDecorationTheme: const InputDecorationTheme(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          labelStyle: TextStyle(color: secondaryTextColor),
          prefixIconColor: secondaryTextColor,
          border: InputBorder.none,
        ),
        colorScheme: const ColorScheme.light(
            primary: primaryColor,
            primaryContainer: primaryVariantColor,
            background: Color(0xfff3f5f8),
            onPrimary: Colors.white,
            onSurface: primaryTextColor,
            onBackground: primaryTextColor,
            secondary: primaryColor,
            onSecondary: Colors.white),
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}
