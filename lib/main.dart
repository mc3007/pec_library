import 'package:flutter/material.dart';
import 'package:pec_library/homePage.dart';
import 'package:pec_library/sharedPreferences.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await UserSimplePreferences.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );

  }
}