import 'package:chat_app/models/firebase_helper_model.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/screens/auth/login_page.dart';
import 'package:chat_app/screens/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  User? currentUser = FirebaseAuth.instance.currentUser;
  // logged in
  if(currentUser != null){
    UserModel? thisUserModel;
    thisUserModel =await FirebaseHelperModel.getUserById(currentUser.uid);

    if(thisUserModel != null){

    runApp( LoggedInMyApp(firebaseUser: currentUser,userModel: thisUserModel,));

    }
    else{
      runApp(const MyApp());
    }
  }
  // not logged in
  else{
  runApp(const MyApp());
  }

}

// not logged in
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SafeArea(child: LoginPage( )),
    );
  }
}

// already logged in
class LoggedInMyApp extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;

  const LoggedInMyApp({super.key, required this.userModel, required this.firebaseUser});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  SafeArea(child: HomePage(firebaseUser: firebaseUser,userModel: userModel, )),
    );
  }
}
