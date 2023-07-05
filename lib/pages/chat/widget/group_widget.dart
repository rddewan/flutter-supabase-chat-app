
import 'package:flutter/material.dart';
import 'package:flutter_supabase_app/pages/chat/group_page.dart';
import 'package:flutter_supabase_app/utils/constants.dart';

import '../../../models/group.dart';

class GroupWidget extends StatefulWidget {
  const GroupWidget({ Key? key }) : super(key: key);

  @override
  GroupWidgetState createState() => GroupWidgetState();
}

class GroupWidgetState extends State<GroupWidget> {

  Stream<List<Group>> _groups = Stream.value([]);

  @override
  void initState() {    
    super.initState();
    _getGroups();
  }

  void _getGroups() {
    _groups = supabase.from('chat_room')
      .stream(primaryKey: ['id'])
      .neq('name', null)
      .order('name',ascending: true)
      .map((event) => 
        event.map((map) => Group.fromMap(map: map)).toList());
  }
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _groups,
      builder: (context,snapshot) {

        if (snapshot.hasData) {

          final data = snapshot.data ?? [];

          if (data.isEmpty) return const Center(child: Text('No group found'),);

          return SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: data.length,
              itemBuilder: (context, index) {

                final group = data[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (_) => GroupPage(group: group)));
                  },
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColorLight,
                    radius: 32,
                    child: Text(
                      group.name.length > 5 ? group.name.substring(0,5) : group.name,
                      style:  Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                );
              },
            ),
          );

          }
        else {
          return const SizedBox.shrink();
      }
        
      },
    );
  }
}