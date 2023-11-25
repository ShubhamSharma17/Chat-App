import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/screens/auth/login_page.dart';
import 'package:chat_app/screens/search_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final UserModel userModel; 
  final User firebaseUser ;
  const HomePage({super.key, required this.userModel, required this.firebaseUser}); 
  

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text("Chat App"),
        centerTitle: true,
        actions: [IconButton(onPressed: (){
          FirebaseAuth.instance.signOut();
          Navigator.push(context, CupertinoPageRoute(builder: (context){
            return const LoginPage();
          }));
        }, icon: const Icon(Icons.logout_outlined))],
      ),
      
      body: SafeArea(
        child: Container(),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){Navigator.push(context, CupertinoPageRoute(builder: (context) {
        return  SearchPage(firebaseUser: widget.firebaseUser,userModel: widget.userModel,);
      },));},child: const Icon(Icons.search)),
    );
  }
}
