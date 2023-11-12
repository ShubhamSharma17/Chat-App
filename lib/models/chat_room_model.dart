class ChatRoomModel {
  String? chatroomid;
  Map<String, dynamic>? participant;
  String? lastMessage;
  List<dynamic>? users;
  DateTime? createdOn;
  DateTime? updatedOn;

  ChatRoomModel({
    this.chatroomid,
    this.participant,
    this.lastMessage,
    this.users,
    this.createdOn,
    this.updatedOn,
  });

  ChatRoomModel.fromMap(Map<String, dynamic> map) {
    chatroomid = map["chatroomid"];
    participant = map["participant"];
    lastMessage = map["lastmessage"];
    users = map["users"];
    createdOn = map["createdOn"].toDate();
    updatedOn = map["updatedOn"].toDate();
  }
  Map<String, dynamic> toMap() {
    return {
      "chatroomid": chatroomid,
      "participant": participant,
      "lastmessage": lastMessage,
      "users": users,
      "createdOn": createdOn,
      "updatedOn": updatedOn,
    };
  }
}
