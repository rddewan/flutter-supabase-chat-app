

class RoomMember {
  final String roomId;
  final String userId;

  RoomMember({required this.roomId, required this.userId});

  RoomMember.fromMap({
    required Map<String,dynamic> map
  }) : roomId = map['room_id'],
    userId = map['user_id'];
  
}