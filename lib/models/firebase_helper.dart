import 'package:chat_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseHelper {
  static Future<UserModel?> getUserModelByID(String uid) async {
    UserModel? userModel;

    DocumentSnapshot docSnapshort =
        await FirebaseFirestore.instance.collection("User").doc(uid).get();

    if (docSnapshort.data() != null) {
      userModel =
          UserModel.fromMap(docSnapshort.data() as Map<String, dynamic>);
    }
    return userModel;
  }
}
