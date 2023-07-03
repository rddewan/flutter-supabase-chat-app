
class Profile {
  final String id;
  final String userName;
  final String email;
  final String avatar;
  final bool isOnline;

  Profile({
    required this.id, 
    required this.userName, 
    required this.email, 
    required this.avatar, 
    required this.isOnline,
  });

  Profile.fromMap(Map<String,dynamic> map) 
    : id = map['id'],
    userName = map['username'],
    email = map['email'],
    avatar = map['avatar_url'],
    isOnline = map['is_online'];

  

}