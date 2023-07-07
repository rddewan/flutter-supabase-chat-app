
import 'package:flutter/material.dart';
import 'package:flutter_supabase_app/pages/chat/widget/group_chat_bubble.dart';

import '../../models/chat_message.dart';
import '../../utils/constants.dart';
import 'widget/chat_bar.dart';


class GroupChatPage extends StatefulWidget {
  final String roomId;
  const GroupChatPage({ Key? key, required this.roomId }) : super(key: key);

  @override
  GroupChatPageState createState() => GroupChatPageState();
}

class GroupChatPageState extends State<GroupChatPage> {

  Stream<List<ChatMessage>> _messageStream = Stream.value([]);
  String _groupName = '';

  @override
  void initState() {    
    super.initState();
    _loadChatMessages();
    _loadGroupName();
  }

  @override
  void dispose() {   
    super.dispose();
  }

  void _loadGroupName() async {
    final record = await supabase.from('chat_room')
      .select('name')
      .eq('id', widget.roomId)
      .limit(1)
      .maybeSingle();

    setState(() {
      _groupName = record['name'];
    });
  }

  void _loadChatMessages() async {
    final myUserId = supabase.auth.currentUser?.id ?? '';
    _messageStream = supabase.from('chat_messages')
      .stream(primaryKey: ['id'])
      .eq('room_id', widget.roomId)
      .order('created_at')
      .map((event) => event
        .map((map) => ChatMessage
          .fromMap(map: map, myUserId: myUserId)).toList());
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_groupName),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: _messageStream,
        builder: (context,snapshot) {

          if (snapshot.hasData) {

            final messages = snapshot.data ?? [];  

            return Column(
              children: [
                Expanded(
                  child: messages.isEmpty
                    ? const Center(
                      child: Text('Start your conversation..'),
                    )
                    : ListView.builder(
                        itemCount: messages.length,
                        reverse: true,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          return GroupChatBubble(message: message);
                        },
                      ),
                ),

                ChatBar(roomId: widget.roomId)

              ],
            ); 
                        
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          else {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

        },
      ),
    );
  }
}