
import 'package:flutter/material.dart';
import 'package:flutter_supabase_app/pages/auth/login_page.dart';
import 'package:flutter_supabase_app/pages/dashboard_page.dart';
import 'package:flutter_supabase_app/utils/constants.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({ Key? key }) : super(key: key);

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {

  @override
  void initState() {    
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {      
      _checkUserSession();
    },);
  }

  void _checkUserSession() {
    final session = supabase.auth.currentSession;

    if (session == null) {
      Navigator.pushAndRemoveUntil(
        context, 
        MaterialPageRoute(builder: (_) => const LoginPage()), 
        (route) => false,
      );      
    } else {
      Navigator.pushAndRemoveUntil(
        context, 
        MaterialPageRoute(builder: (_) => const DashboardPage()), 
        (route) => false,
      );          
    }
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }
}