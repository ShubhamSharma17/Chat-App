import 'package:chat_app/utility/colors.dart';
import 'package:flutter/material.dart';

class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage({super.key});

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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