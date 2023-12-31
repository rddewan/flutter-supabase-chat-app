import 'package:flutter/material.dart';
import 'package:flutter_supabase_app/pages/splash_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://bldrzsebmarvfmaaslgj.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJsZHJ6c2VibWFydmZtYWFzbGdqIiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODgwMDEwNDgsImV4cCI6MjAwMzU3NzA0OH0.Q2McBV-5w-Q97CBiX4kzsjvuuyO6tqjSPjjvRGZaGeE'
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: FlexThemeData.light(
        scheme: FlexScheme.deepOrangeM3,
        useMaterial3: true,
        useMaterial3ErrorColors: true,
      ),
      darkTheme: FlexThemeData.dark(
        scheme: FlexScheme.deepOrangeM3,
        useMaterial3: true,
        useMaterial3ErrorColors: true,
      ),
      themeMode: ThemeMode.system,
      home: const SplashPage(),
    );
  }
}
