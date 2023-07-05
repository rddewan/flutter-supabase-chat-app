
import 'package:flutter/material.dart';
import 'package:flutter_supabase_app/pages/chat/widget/group_widget.dart';
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

  late TextEditingController _groupController;

  final RealtimeChannel _channel = supabase.channel(
    'chat_app',
    opts: RealtimeChannelConfig(
      key: supabase.auth.currentUser?.id ?? ''
    )
  );

  
  @override
  void initState() {    
    super.initState();
    _groupController = TextEditingController();
    _subscribeToChannel();
  }

  @override
  void dispose() {
    _updateOnlineStatus(false, supabase.auth.currentUser?.id ?? '');
    supabase.removeChannel(_channel);
    _groupController.dispose();
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

  Future<String> _createGroup(String name) async {

    final String data = await supabase.rpc(
      'create_group_room',
      params: {'name': name}
    );

    return data;
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
              child: Text('Groups'),
            ),
          ),

          SliverToBoxAdapter(
            child: GroupWidget(),
          ),

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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showGreateGroupDialog();
        }, 
        label: const Text('Create Group'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  void _showGreateGroupDialog() {
    showGeneralDialog(
      context: context, 
      pageBuilder:(context, animation, secondaryAnimation) => const SizedBox.shrink(),
      transitionDuration: const Duration(milliseconds: 500),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curve = Curves.easeInOut.transform(animation.value);
        return Transform.scale(
          scale: curve,
          child: AlertDialog(
            title: const Center(child: Text('Create Group')),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.send,
                  maxLines: 1,
                  autofocus: true,
                  controller: _groupController,
                  decoration: InputDecoration(
                    hintText: 'Group name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColorDark,
                        width: 1,
                      )
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 1,
                      ),
                    ),                
                    contentPadding: const EdgeInsets.all(8),
                  ),
                  
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [

                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      }, 
                      child: const Text('Cancel'),
                    ),

                    TextButton(
                      onPressed: () async {
                        await _createGroup(_groupController.text); 
                        _groupController.clear();
                        if (!mounted) return;
                        Navigator.pop(context);                       
                      }, 
                      child: const Text('Create'),
                    ),

                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}