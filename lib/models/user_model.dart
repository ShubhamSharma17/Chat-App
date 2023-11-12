class UserModel {
  String? uid;
  String? fullname;
  String? email;
  String? profilepic;
  String? phoneNumber;

  UserModel({
    this.uid,
    this.fullname,
    this.email,
    this.profilepic,
    this.phoneNumber,
  });
  UserModel.fromMap(Map<String, dynamic> map) {
    uid = map["uid"];
    fullname = map["fullname"];
    email = map["email"];
    profilepic = map["profilepic"];
    phoneNumber = map["phoneNumber"];
  }
  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "fullname": fullname,
      "email": email,
      "profilepic": profilepic,
      "phoneNumber": phoneNumber
    };
  }
}
