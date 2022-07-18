import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lifelog_app/stores/app.store.dart';
import 'package:lifelog_app/views/auth/login.view.dart';
import 'package:provider/provider.dart';
// import 'package:lifelog_app/themes/app.theme.dart';

// Esta classe permite acesso ao LocalHost com certificados HTTPS inválidos
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    HttpClient client = super.createHttpClient(context);
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    return client;
  }
}

void main() async {
  HttpOverrides.global = MyHttpOverrides(); // localhost https

  WidgetsFlutterBinding.ensureInitialized(); // firebase
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AppStore>.value(
          value: AppStore(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Lifelog',
        theme: ThemeData(
          primaryColor: Colors.deepPurple,
          colorScheme: ColorScheme.fromSwatch().copyWith(
            brightness: Brightness.light,
            secondary: Colors.amber,
          ),
        ),
        darkTheme: ThemeData(
          primaryColor: Colors.purple,
          colorScheme: ColorScheme.fromSwatch().copyWith(
            brightness: Brightness.dark,
            secondary: Colors.green,
          ),
        ),
        themeMode: ThemeMode.light,
        home: const LoginView(),
      ),
    );
  }
}

extension ColorSchemeExtension on ColorScheme {
  Color get warn => Colors.red;
}
