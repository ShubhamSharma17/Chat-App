import 'dart:developer';

import 'package:chat_app/models/chat_room_model.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/screens/chat_room_page.dart';
import 'package:chat_app/utility/colors.dart';
import 'package:chat_app/utility/utility.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const SearchPage({super.key, required this.userModel,required this.firebaseUser});

  @override
  State<SearchPage> createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  TextEditingController phoneController = TextEditingController();
  Future<ChatRoomModel?> getChatroomModel(UserModel targetUser)async{
   QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("chatrooms").
    where("participants.${widget.userModel.uid}",isEqualTo: true).
    where("participants.${targetUser.uid}",isEqualTo: true).get();

    if(snapshot.docs.isNotEmpty){
      // chat room exist
      log("Chat room already exists");
    }
    else{
      // create chat room 
      log("Create chat room");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body:  SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          
          child: Column(
            children: [
                         TextField(
                          keyboardType: TextInputType.phone,
                          controller: phoneController,
                          maxLength: 10,                          
                          ),
                          verticalSpacesLarge,
                          CupertinoButton(onPressed: (){
                            setState(() {
                              
                            });
                          },color: blue,child: const Text("Search"),),
                          verticalSpacesLarge,
                          StreamBuilder(stream: FirebaseFirestore.instance.collection("user").where(
                            "phoneNumber",isEqualTo:phoneController.text ).where(
                              "phoneNumber",isNotEqualTo: widget.userModel.phoneNumber).snapshots(),
                           builder: (context, snapshot) {
                             if(snapshot.connectionState == ConnectionState.active){
                              if(snapshot.hasData){
                                
                                QuerySnapshot dataSnapshort = snapshot.data as QuerySnapshot;
                                if(dataSnapshort.docs.isNotEmpty){

                                Map<String,dynamic> mapUser = dataSnapshort.docs[0].data() as Map<String,dynamic>;
                                UserModel searchUser = UserModel.fromMap(mapUser);
                                return ListTile(
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.push(context, CupertinoPageRoute(builder: (context) {
                                      return  ChatRoomPage(firebaseUser: widget.firebaseUser,userModel: widget.userModel,targetUser: searchUser,);
                                    },));
                                  },
                                  title: Text(searchUser.fullname!.toString(),),
                                  subtitle: Text(searchUser.email!.toString()),
                                  leading: CircleAvatar(backgroundImage: NetworkImage(searchUser.profilepic!)),
                                  trailing: const Icon(Icons.keyboard_arrow_right_sharp),
                                );
                                }
                                else{
                                return const Text("No result found!");

                                }

                              }
                              else if(snapshot.hasError){
                                return const Text("An error occurred!");
                              }
                              else{
                                return const Text("No result found!");
                              }
                             }
                             else{
                              return const CircularProgressIndicator();
                             }
                           },
                           )
                      ],
                      ),
                    )
                ),
            );
  }
}