import 'package:chat_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseHelperModel{
  static Future<UserModel?> getUserById(String uid)async{
    UserModel? userModel;

    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection("user").doc(uid).get();

    if(documentSnapshot.data() != null){
      
    userModel = UserModel.fromMap(documentSnapshot.data() as Map<String,dynamic>);
    }
    
  return userModel;
  } 
}