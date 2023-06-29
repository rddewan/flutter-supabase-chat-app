import 'package:flutter/material.dart';
import 'package:flutter_supabase_app/pages/auth/login_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
    return const MaterialApp(
      home: Scaffold(
        body: LoginPage()
      ),
    );
  }
}
