
import 'package:flutter/material.dart';
import 'package:flutter_supabase_app/pages/chat/widget/profile_list_widget.dart';


class ChatPage extends StatefulWidget {
  const ChatPage({ Key? key }) : super(key: key);

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        centerTitle: true,
      ),
      body: const CustomScrollView(
        slivers: [

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Members'),
            ),
          ),

          SliverFillRemaining(
            child: ProfileListWidget(),
          )

        ],
      ),
    );
  }
}