
import 'package:flutter/material.dart';
import 'package:flutter_supabase_app/models/group.dart';
import 'package:flutter_supabase_app/pages/chat/group_chat_page.dart';
import 'package:flutter_supabase_app/utils/constants.dart';
import 'package:flutter_supabase_app/utils/snackbar_extension.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GroupPage extends StatefulWidget {
  final Group group;
  const GroupPage({ Key? key, required this.group }) : super(key: key);

  @override
  GroupPageState createState() => GroupPageState();
}

class GroupPageState extends State<GroupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [

            CircleAvatar(
              radius: 80,
              child: Text(widget.group.name),
            ),

            const SizedBox(height: 16.0,),

            FilledButton.tonal(
              onPressed: () {
                _joinGroup();
              }, 
              child: const Text('Join'),
            )

          ],
        ),
      ),
    );
  }

  void _joinGroup() async {
    try {

      await supabase.from('chat_room_participants')
      .insert({
        'room_id': widget.group.id,
        'user_id': supabase.auth.currentUser?.id,
      });

      _navigateToGroupChatPage();
      
    } on PostgrestException catch (e) {
      context.showSnackbar(message: e.message,backgroundColor: Colors.red);
      
    } catch (e) {
      context.showSnackbar(message: e.toString(),backgroundColor: Colors.red);
    }
  }

  void _navigateToGroupChatPage() {
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (_) => const GroupChatPage()));
  }
}