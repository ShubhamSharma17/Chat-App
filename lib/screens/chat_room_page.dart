import 'package:chat_app/models/chat_room_model.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/utility/colors.dart';
import 'package:chat_app/utility/utility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatRoomPage extends StatefulWidget {
  final UserModel targetUser;
  // final ChatRoomModel chatroom;
  final UserModel userModel;
  final User firebaseUser;

  const ChatRoomPage({super.key, required this.targetUser,
  //  required this.chatroom, 
   required this.userModel, required this.firebaseUser});

  
  

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Row(
          children: [
            CircleAvatar(backgroundImage: NetworkImage(widget.userModel.profilepic!),),
            horizontalSpaceSmall,
            Text(widget.userModel.fullname!),

        ],)
      ),
      body: SafeArea(
        child: SizedBox(
          child: Column(
            children: [
              // this is where the chat will go
              Expanded(
                child: Container()
                ),
                Container(
                  color: grayD9D9D9,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      const Flexible(
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter Message",
                          ),
                        ),
                        ),
                        IconButton(onPressed: () {
                          
                        }, icon: const Icon(Icons.send,
                        color: blue,
                        ),
                        )
                    ],
                  ),
                )
            ],
          ),
        ),
        ),
    );
  }
}