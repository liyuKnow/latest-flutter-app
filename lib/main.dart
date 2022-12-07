import 'package:flutter/material.dart';
import 'package:latest_app/src/widgets/pages/home_page.dart';
import "package:latest_app/src/helper/object_box.dart";

late ObjectBox objectbox;

void main() async {
  // ASSERT THAT OBJECT BOX IS INITIALIZED
  WidgetsFlutterBinding.ensureInitialized();

  objectbox = await ObjectBox.create();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
