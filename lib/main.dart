import 'package:chatflutter/firebase_options.dart';
import 'package:chatflutter/pages/loginpage.dart';
import 'package:chatflutter/services/authservice.dart';
import 'package:chatflutter/services/navigatorservice.dart';
import 'package:chatflutter/services/uthils.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await registerServices();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final GetIt _getIt = GetIt.instance;
  late NavigationService _navigationService;
  late Authservice _authservice;
  MyApp({super.key}) {
    _navigationService = _getIt.get<NavigationService>();
    _authservice = _getIt.get<Authservice>();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: _navigationService.navigatorKey,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      // home: LoginPage(),
      initialRoute: _authservice.user != null ? "/home" : "/login",
      routes: _navigationService.routes,
    );
  }
}
