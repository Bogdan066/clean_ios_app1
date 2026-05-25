import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:clean_ios_app/pages/signupAndRegistration/onboardpage.dart';
import 'package:clean_ios_app/pages/mainpage/mainpage1.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  var box = await Hive.openBox('usersBox');
  bool isLoggedIn = box.get('isLoggedIn', defaultValue: false);
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Fridge',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.interTextTheme(),
        useMaterial3: true,
      ),
      home: isLoggedIn
          ? const MainPage(userName: "guest", userEmail: "guest123@gmail.com")
          : const WelcomePage(),
    );
  }
}
