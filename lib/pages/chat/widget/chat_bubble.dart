
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:flutter_supabase_app/models/chat_message.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

const ChatBubble({ Key? key, required this.message }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    List<Widget> chatContents = [

      Flexible(
        flex: 2,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 16,
          ),
          decoration: BoxDecoration(
            color: message.isMine
                ? Theme.of(context).primaryColorLight
                : Colors.grey[300],
            borderRadius: message.isMine 
              ? const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                )
              : const BorderRadius.only(
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                )
          ),
          child: Text(message.message),
        ),
      ),

      const SizedBox(width: 8),

      Flexible(
        flex: 1,
        child: Text(
          timeago.format(message.createdAt, locale: 'en_short'),
        ),
      ),

      const SizedBox(width: 8),

    ];

    if (message.isMine) {
      chatContents = chatContents.reversed.toList();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: message.isMine 
          ? MainAxisAlignment.end 
          : MainAxisAlignment.start,
        children: chatContents,
      ),
    );
  }
}