
class Group {
  final String id;
  final String name;

  Group({required this.id, required this.name});

  Group.fromMap({
    required Map<String,dynamic> map
  }) : id = map['id'],
    name = map['name'];
    
}