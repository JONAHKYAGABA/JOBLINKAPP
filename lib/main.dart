import 'package:flutter/material.dart';

import 'package:flutter_application_2/page/home_page.dart';
import 'package:flutter_application_2/page/main_page.dart';
import 'package:flutter_application_2/page/sign_in_page.dart';
import 'package:flutter_application_2/page/sign_up_page.dart';

import 'package:flutter_application_2/page/splash_screen.dart';
import 'package:flutter_application_2/page/started_page.dart';
import 'package:flutter_application_2/providers/auth_provider.dart';
import 'package:flutter_application_2/providers/category_provider.dart';
import 'package:flutter_application_2/providers/page_provider.dart';
import 'package:flutter_application_2/providers/user_provider.dart';
import 'package:flutter_application_2/providers/posted_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

// Future<void> main() async {
//   // Set default app if not already set.
//   await Firebase.initializeApp();
//   WidgetsFlutterBinding.ensureInitialized();
//   // Run your app.
//   runApp(MyApp());
// }

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProvider<UserProvider>(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider<CategoryProvider>(
          create: (context) => CategoryProvider(),
        ),
        ChangeNotifierProvider<PostedProvider>(
          create: (context) => PostedProvider(),
        ),
        ChangeNotifierProvider<PageProvider>(
          create: (context) => PageProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Job Link',
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => SplashScreen(),
          '/main-page': (context) => MainPage(),
          '/onboarding': (context) => StartedPage(),
          '/sign-in': (context) => SignInPage(),
          '/sign-up': (context) => SignUpPage(),
          '/home': (context) => HomePage(),
        },
        initialRoute: '/',
      ),
    );
  }
}
