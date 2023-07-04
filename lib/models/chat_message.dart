
class ChatMessage {

  final int id;
  final String userId;
  final String message;
  final DateTime createdAt;
  final bool isMine;

  ChatMessage({
    required this.id, 
    required this.userId, 
    required this.message, 
    required this.createdAt, 
    required this.isMine,
  });

  ChatMessage.fromMap({
    required Map<String,dynamic> map,
    required String myUserId,
  }) : id = map['id'],
  userId = map['user_id'],
  message = map['message'],
  createdAt = DateTime.parse(map['created_at']),
  isMine = myUserId == map['user_id'];
  
}