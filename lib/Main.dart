import 'package:flutter/material.dart';
import 'IntroPage.dart';
import 'WeeklyTable.dart';

void main() {

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: FutureBuilder(
        future: Future.delayed(const Duration(seconds: 3), () => "Intro Completed!"),
        builder: (context, snapshot) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 1000),
            child: LoadingWidget(snapshot),
          );
        },
      )
    );
  }

  Widget LoadingWidget(AsyncSnapshot<Object?> snapshot) {
    print(snapshot);
    if(snapshot.hasError) {
      return const Text("Error!!");
    } else if(snapshot.hasData) {
      return const WeeklyTable();
    } else {
      return const IntroPage();
    }
  }
}

