
import 'package:flutter/material.dart';
import 'package:flutter_supabase_app/models/profiles.dart';
import 'package:flutter_supabase_app/utils/constants.dart';
import 'package:flutter_supabase_app/utils/snackbar_extension.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:flutter_supabase_app/models/chat_message.dart';

class GroupChatBubble extends StatefulWidget {
  final ChatMessage message;

const GroupChatBubble({ Key? key, required this.message }) : super(key: key);

  @override
  State<GroupChatBubble> createState() => _GroupChatBubbleState();
}

class _GroupChatBubbleState extends State<GroupChatBubble> {
  Profile? _profile;

  @override
  void initState() {    
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getUserProfile();
    });
  }

  void _getUserProfile() async {
    try {

      final result = await supabase.from('profiles')
        .select('*')
        .eq('id', widget.message.userId)
        .maybeSingle();

      final profile = Profile.fromMap(result);

      setState(() {
        _profile = profile;        
      });
      
    } on PostgrestException catch (e) {
      context.showSnackbar(message: e.message, backgroundColor: Colors.red);      
    }

  } 

  @override
  Widget build(BuildContext context) {

    List<Widget> chatContents = [

      if (!widget.message.isMine)... [
        CircleAvatar(
          child: _profile == null 
          ? const Center(child: CircularProgressIndicator.adaptive(),)
          : Text(_profile?.userName.substring(0,2) ?? '_'),
        )
      ],

      const SizedBox(width: 4,),

      Flexible(
        flex: 2,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 16,
          ),
          decoration: BoxDecoration(
            color: widget.message.isMine
                ? Theme.of(context).primaryColorLight
                : Colors.grey[300],
            borderRadius: widget.message.isMine 
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
          child: Text(widget.message.message),
        ),
      ),

      const SizedBox(width: 8),

      Flexible(
        flex: 1,
        child: Text(
          timeago.format(widget.message.createdAt, locale: 'en_short'),
        ),
      ),

      const SizedBox(width: 8),

    ];

    if (widget.message.isMine) {
      chatContents = chatContents.reversed.toList();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: widget.message.isMine 
          ? MainAxisAlignment.end 
          : MainAxisAlignment.start,
        children: chatContents,
      ),
    );
  }
}