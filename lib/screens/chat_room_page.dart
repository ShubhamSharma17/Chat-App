import 'dart:developer';
import 'package:chat_app/main.dart';
import 'package:chat_app/models/chat_room_model.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/utility/colors.dart';
import 'package:chat_app/utility/utility.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatRoomPage extends StatefulWidget {
  final UserModel targetUser;
  final ChatRoomModel chatroom;
  final UserModel userModel;
  final User firebaseUser;

  const ChatRoomPage({
    super.key,
    required this.targetUser,
    required this.chatroom,
    required this.userModel,
    required this.firebaseUser,
  });

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  TextEditingController messageController = TextEditingController();
  // method for send message..
  void sendMessage() {
    String msg = messageController.text;
    messageController.clear();
    if (msg != "") {
      MessageModel msgModel = MessageModel(
        createdon: DateTime.now(),
        messageid: uuid.v1(),
        seen: false,
        sender: widget.userModel.uid,
        text: msg,
      );
      // upload message on firebase
      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatroom.chatroomid)
          .collection("messages")
          .doc(msgModel.messageid)
          .set(msgModel.toMap());
      // update last message date
      // widget.chatroom.updatedOn = DateTime.now();
      // update last message
      widget.chatroom.lastMessage = msg;
      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatroom.chatroomid)
          .set(widget.chatroom.toMap());
      log("message sent!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: blue,
            title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.targetUser.profilepic!),
            ),
            horizontalSpaceSmall,
            Text(widget.targetUser.fullname!),
          ],
        )),
        body: SafeArea(
          child: SizedBox(
            child: Column(
              children: [
                // this is where the chat will go
                Expanded(
                    child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("chatrooms")
                        .doc(widget.chatroom.chatroomid)
                        .collection("messages")
                        .orderBy("createdon", descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        if (snapshot.hasData) {
                          QuerySnapshot querySnapshot =
                              snapshot.data as QuerySnapshot;
                          return ListView.builder(
                            reverse: true,
                            itemCount: querySnapshot.docs.length,
                            itemBuilder: (context, index) {
                              MessageModel currentMessage = MessageModel.fromMap(
                                  querySnapshot.docs[index].data()
                                      as Map<String, dynamic>);
                              return Row(
                                mainAxisAlignment: widget.userModel.uid ==
                                        currentMessage.sender.toString()
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                                children: [
                                  Container(
                                      margin:
                                          const EdgeInsets.symmetric(vertical: 5),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      decoration: BoxDecoration(
                                        color: widget.userModel.uid ==
                                                currentMessage.sender.toString()
                                            ? gray939393
                                            : blue,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child:
                                          Text(currentMessage.text.toString())),
                                ],
                              );
                            },
                          );
                        } else if (snapshot.hasError) {
                          return const Center(
                            child: Text(
                                "An error occurred! Please check your internet"),
                          );
                        } else {
                          return const Center(
                              child: Text("Say hi to your new friend!"));
                        }
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                )),
                Container(
                  color: grayD9D9D9,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      Flexible(
                        child: TextField(
                          controller: messageController,
                          maxLines: null,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter Message",
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          sendMessage();
                        },
                        icon: const Icon(
                          Icons.send,
                          color: blue,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
