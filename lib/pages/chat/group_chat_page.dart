
import 'package:flutter/material.dart';

class GroupChatPage extends StatefulWidget {
  final String roomId;
  const GroupChatPage({ Key? key, required this.roomId }) : super(key: key);

  @override
  GroupChatPageState createState() => GroupChatPageState();
}

class GroupChatPageState extends State<GroupChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Chat'),
        centerTitle: true,
      ),
      body: Column(),
    );
  }
}