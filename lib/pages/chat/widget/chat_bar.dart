
import 'package:flutter/material.dart';
import 'package:flutter_supabase_app/utils/constants.dart';
import 'package:flutter_supabase_app/utils/snackbar_extension.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatBar extends StatefulWidget {
  final String roomId;
  const ChatBar({ Key? key, required this.roomId }) : super(key: key);

  @override
  ChatBarState createState() => ChatBarState();
}

class ChatBarState extends State<ChatBar> {

  late TextEditingController _textController;

  @override
  void initState() {    
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _submitMessage() async {
    final message = _textController.text;
    final userId = supabase.auth.currentUser?.id ?? '';

    if (message.isEmpty) return;

    _textController.clear();

    try {

      await supabase.from('chat_messages')
        .insert({
          'user_id': userId,
          'room_id': widget.roomId,
          'message': message,
        });
      
    } on PostgrestException catch (e) {
      context.showSnackbar(message: e.message, backgroundColor: Colors.red);      
    } catch (e) {
      context.showSnackbar(message: e.toString(), backgroundColor: Colors.red);  
    }

  }

  @override
  Widget build(BuildContext context) {
    
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [

            Flexible(            
              child: TextFormField(
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.send,
                maxLines: null,
                autofocus: true,
                controller: _textController,
                decoration: InputDecoration(
                  hintText: 'Type a message',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColorDark,
                      width: 1,
                    )
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 1,
                    ),
                  ),                
                  contentPadding: const EdgeInsets.all(8),
                ),
                onFieldSubmitted: (newValue) => _submitMessage(),
              ),
            ),
    
            const SizedBox(width: 8.0,),
    
            IconButton.filledTonal(
              onPressed: () => _submitMessage(),
              icon: Icon(
                Icons.send,
                color: Theme.of(context).primaryColorDark,
              ),
            ),

          ],
        ),
      ),
      
    );
  }
}