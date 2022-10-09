import 'package:flutter/material.dart';

import 'third/custom_image_canvas_3.dart';
import 'first/custom_image_canvas.dart';
import 'second/custom_image_canvas_2.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CustomImageCanvas3(title: "some title"),
    );
  }
}
