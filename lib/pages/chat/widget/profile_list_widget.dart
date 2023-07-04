
import 'package:flutter/material.dart';
import 'package:flutter_supabase_app/models/profiles.dart';
import 'package:flutter_supabase_app/pages/chat/private_chat.dart';
import 'package:flutter_supabase_app/utils/constants.dart';

class ProfileListWidget extends StatefulWidget {
  const ProfileListWidget({ Key? key }) : super(key: key);

  @override
  ProfileListWidgetState createState() => ProfileListWidgetState();
}

class ProfileListWidgetState extends State<ProfileListWidget> {
  Stream<List<Profile>> profiles = Stream.value([]);

  @override
  void initState() {    
    super.initState();
    _loadUserProfiles();
  }

  void _loadUserProfiles() {
    profiles = supabase.from('profiles')
      .stream(primaryKey: ['id'])
      .neq('id', supabase.auth.currentUser?.id)
      .map((event) => event.map((map) => Profile.fromMap(map)).toList());
  }

  @override
  Widget build(BuildContext context) {
    
    return StreamBuilder(
      stream: profiles,
      builder: (context,snpshot) {

        if (snpshot.hasData) {

          final data = snpshot.data ?? [];

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {

              final profile = data[index];
              
              return GestureDetector(
                onTap: () async {
                  final roomId = await _createPrivateRoom(profile.id);

                  _navigateToPrivateChat(roomId);
                                    
                },
                child: ListTile(
                  leading: CircleAvatar(
                    foregroundImage: NetworkImage(profile.avatar),
                  ),
                  title: Text(profile.userName),
                  subtitle: profile.isOnline 
                    ? Text(
                      'Online',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Colors.green
                      ),
                    ) 
                    : const Text('Offline'),
                ),
              );

            },
          );
        }
        else if (snpshot.hasError) {
          return Center(
            child: Text(snpshot.error.toString()),
          );
        }
        else {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }

      },
    );
  }

  Future<String> _createPrivateRoom(String anotherUserId) async {
    final String data = await supabase.rpc(
      'create_private_room',
      params: {'other_user_id': anotherUserId}
    );

    return data;
  }

  void _navigateToPrivateChat(String roomId) {
    Navigator.of(context)
      .push(MaterialPageRoute(builder: (_) => PrivateChat(roomId: roomId)));
  }
}