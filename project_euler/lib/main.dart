import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_euler/finished_problems.dart';
import 'package:project_euler/current_problem.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var answer = "Solving...";

  void solveProblem() async {
    answer = (await compute(problem12, null)).toString();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    solveProblem();
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.black));
    return MaterialApp(
      title: 'Project Euler',
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(title: Text("Project Euler")),
        body: Center(child: Text("$answer")),
      ),
    );
  }
}
