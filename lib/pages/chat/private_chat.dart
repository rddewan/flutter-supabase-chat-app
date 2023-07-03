
import 'package:flutter/material.dart';
import 'package:flutter_supabase_app/models/chat_message.dart';
import 'package:flutter_supabase_app/pages/chat/widget/chat_bar.dart';
import 'package:flutter_supabase_app/pages/chat/widget/chat_bubble.dart';
import 'package:flutter_supabase_app/utils/constants.dart';

class PrivateChat extends StatefulWidget {
  final String roomId;
  const PrivateChat({ Key? key, required this.roomId }) : super(key: key);

  @override
  PrivateChatState createState() => PrivateChatState();
}

class PrivateChatState extends State<PrivateChat> {
  Stream<List<ChatMessage>> _messageStream = Stream.value([]);

  @override
  void initState() {    
    super.initState();
    _loadChatMessages();
  }

  @override
  void dispose() {   
    super.dispose();
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
        title: const Text('Private Chat'),
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
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          return ChatBubble(message: message);
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