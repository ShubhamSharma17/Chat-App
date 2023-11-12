class MessageModel {
  String? sender;
  String? text;
  bool? seen;
  DateTime? createdon;
  String? messageid;

  MessageModel({
    this.createdon,
    this.seen,
    this.sender,
    this.text,
    this.messageid,
  });

  MessageModel.fromMap(Map<String, dynamic> map) {
    sender = map["sender"];
    text = map["text"];
    seen = map["seen"];
    createdon = map["createdon"].toDate();
    messageid = map["messageid"];
  }
  Map<String, dynamic> toMap() {
    return {
      "sender": sender,
      "text": text,
      "seen": seen,
      "createdon": createdon,
      "messageid": messageid,
    };
  }
}
