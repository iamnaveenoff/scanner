import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scanner/screens/home.dart';
import 'package:scanner/screens/login.dart';

void main() {
  runApp(const MyApp());
}

ColorScheme defaultColorScheme = const ColorScheme(
  primary: Colors.blue,
  secondary: Color(0xff03DAC6),
  surface: Color(0xff181818),
  background: Color(0xff121212),
  error: Color(0xffCF6679),
  onPrimary: Color(0xff000000),
  onSecondary: Color(0xff000000),
  onSurface: Color(0xffffffff),
  onBackground: Color(0xffffffff),
  onError: Color(0xff000000),
  brightness: Brightness.dark,
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: '/login',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: defaultColorScheme,
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
      },
      // home: LoginPage(),
    );
  }
}
