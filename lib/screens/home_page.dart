// ignore_for_file: use_build_context_synchronously

import 'package:chat_app/models/chat_room_model.dart';
import 'package:chat_app/models/firebase_helper_model.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/screens/auth/login_page.dart';
import 'package:chat_app/screens/chat_room_page.dart';
import 'package:chat_app/screens/search_page.dart';
import 'package:chat_app/utility/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const HomePage(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: blue,
          title: const Text("Chat App"),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.popUntil(context, (route) => route.isFirst);
                  Navigator.pushReplacement(context,
                      CupertinoPageRoute(builder: (context) {
                    return const LoginPage();
                  }));
                },
                icon: const Icon(Icons.logout_outlined))
          ],
        ),
        body: SafeArea(
          child: SizedBox(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("chatrooms")
                  .where("users", arrayContains: widget.userModel.uid)
                  .orderBy("createdOn")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    QuerySnapshot chatRoomSnapshot =
                        snapshot.data as QuerySnapshot;
      
                    return ListView.builder(
                      itemCount: chatRoomSnapshot.docs.length,
                      itemBuilder: (context, index) {
                        ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(
                            chatRoomSnapshot.docs[index].data()
                                as Map<String, dynamic>);
      
                        Map<String, dynamic> participant =
                            chatRoomModel.participant!;
      
                        List<String> participantKeys = participant.keys.toList();
      
                        participantKeys.remove(widget.userModel.uid);
      
                        return FutureBuilder(
                          future:
                              FirebaseHelperModel.getUserById(participantKeys[0]),
                          builder: (context, userData) {
                            if (userData.connectionState ==
                                ConnectionState.done) {
                              if (userData.data != null) {
                                UserModel targetUser = userData.data as UserModel;
      
                                return ListTile(
                                  onTap: () {
                                    Navigator.push(context, CupertinoPageRoute(
                                      builder: (context) {
                                        return ChatRoomPage(
                                          targetUser: targetUser,
                                          chatroom: chatRoomModel,
                                          userModel: widget.userModel,
                                          firebaseUser: widget.firebaseUser,
                                        );
                                      },
                                    ));
                                  },
                                  leading: CircleAvatar(
                                    backgroundColor: blue,
                                    backgroundImage:
                                        NetworkImage(targetUser.profilepic!),
                                  ),
                                  title: Text(targetUser.fullname.toString()),
                                  subtitle: chatRoomModel.lastMessage == ""
                                      ? const Text(
                                          "Say hi to your friend!",
                                          style: TextStyle(color: blue),
                                        )
                                      : Text(
                                          chatRoomModel.lastMessage.toString(),
                                          style:
                                              const TextStyle(color: gray939393),
                                        ),
                                );
                              } else {
                                return Container();
                              }
                            } else {
                              return Container();
                            }
                          },
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else {
                    return const Text("No Chat!");
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(context, CupertinoPageRoute(
                builder: (context) {
                  return SearchPage(
                    firebaseUser: widget.firebaseUser,
                    userModel: widget.userModel,
                  );
                },
              ));
            },
            child: const Icon(Icons.search)),
      ),
    );
  }
}
