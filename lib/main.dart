import 'package:SplashApp/constants/widgets.dart';
import 'package:SplashApp/views/home.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(
            seconds: 5,
            navigateAfterSeconds: HomePage(),
            title: Text('SplashApp',
                style: GoogleFonts.sniglet(
                  textStyle: TextStyle(fontSize: 25.0, color: Colors.white),
                )),
            image: Image(
              image: AssetImage("assets/image.png"),
            ),
            backgroundColor: mainColor,
            styleTextUnderTheLoader: TextStyle(),
            photoSize: 50.0,
            // onClick: () {},
            loaderColor: Colors.white));
  }
}
