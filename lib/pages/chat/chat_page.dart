
import 'package:flutter/material.dart';
import 'package:flutter_supabase_app/pages/chat/widget/profile_list_widget.dart';
import 'package:flutter_supabase_app/utils/constants.dart';
import 'package:flutter_supabase_app/utils/snackbar_extension.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({ Key? key }) : super(key: key);

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {

  final RealtimeChannel _channel = supabase.channel(
    'chat_app',
    opts: RealtimeChannelConfig(
      key: supabase.auth.currentUser?.id ?? ''
    )
  );

  
  @override
  void initState() {    
    super.initState();
    _subscribeToChannel();
  }

  @override
  void dispose() {
    _updateOnlineStatus(false, supabase.auth.currentUser?.id ?? '');
    supabase.removeChannel(_channel);
    super.dispose();
  }

  void _subscribeToChannel() {
    _channel.on(RealtimeListenTypes.presence, ChannelFilter(event: 'sync'), (payload, [ref]) { 

    }).on(RealtimeListenTypes.presence, ChannelFilter(event: 'join'), (payload, [ref]) { 
      _updateOnlineStatus(true,payload['key']);
    }).on(RealtimeListenTypes.presence, ChannelFilter(event: 'leave'), (payload, [ref]) { 
      _updateOnlineStatus(false,payload['key']);
    }).subscribe((status,[_]) async {
      
      if (status == 'SUBSCRIBED') {
        await _channel.track(
          {
            'user': supabase.auth.currentUser?.id,
            'online_at':  DateTime.now().toIso8601String(),
          }
        );
      }
    });    
  }

  void _updateOnlineStatus(bool status, String id) async {
    try {

      if (id.isEmpty) return;

      await supabase.from('profiles')
      .update({'is_online': status})
      .eq('id', id);      
      
    } on PostgrestException catch (e) {
      context.showSnackbar(message: e.message,backgroundColor: Colors.red);
    }
  }

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