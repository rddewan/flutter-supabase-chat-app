
import 'package:flutter/material.dart';
import 'package:flutter_supabase_app/pages/auth/login_page.dart';
import 'package:flutter_supabase_app/pages/chat/chat_page.dart';
import 'package:flutter_supabase_app/utils/constants.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({ Key? key }) : super(key: key);

  @override
  DashboardPageState createState() => DashboardPageState();
}

class DashboardPageState extends State<DashboardPage> {
  String numberOfUsers = '0';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await supabase.auth.signOut();
              _navigateToLogInPage();
            }, 
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Text('Number of users: $numberOfUsers')
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _navigateToChatPage();
        }, 
        label: const Text('Chat'),
        icon: const Icon(Icons.chat),
      ),
      
    );
  }

  void _navigateToLogInPage() {
    Navigator.pushAndRemoveUntil(
      context, 
      MaterialPageRoute(builder: (_) => const LoginPage()), 
      (route) => false,
    );
  }

  void _navigateToChatPage() {

    Navigator.push(
      context, 
      MaterialPageRoute(builder: (_) => const ChatPage()),
    );

  }
}