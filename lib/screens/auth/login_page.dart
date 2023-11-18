// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/screens/auth/signup_page.dart';
import 'package:chat_app/screens/home_page.dart';
import 'package:chat_app/utility/colors.dart';
import 'package:chat_app/utility/utility.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormBuilderState> _key = GlobalKey<FormBuilderState>();
  
  // login method..
  void logIn(String email, String password)async{
    UserCredential? credential;
    try{
      credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email, password: password
        );
    } on FirebaseException catch(error){
      log(error.message.toString());
    }
    if(credential != null){
      String uid = credential.user!.uid;

      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection("user").doc(uid).get();
      UserModel userData = UserModel.fromMap(snapshot.data() as Map<String,dynamic>);

      // now you can to to other screen
      log("Login SuccessFully:)");
      Navigator.push(context, CupertinoPageRoute(builder: (context) {
        return HomePage(firebaseUser: credential!.user!,userModel: userData,);
      },));
    }
  }
  bool isDisable = true;
  bool show = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Center(
            child: SingleChildScrollView(
          child: Column(
            children: [
              // title..
              const Text(
                "Chat App",
                style: TextStyle(
                  fontSize: 40,
                  color: blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
              verticalSpaceMedium,
              // email address..
              FormBuilder(
                key: _key,
                child: Column(
                  children: [
                    // email text field
                    FormBuilderTextField(
                      name: "email address",
                      obscureText: false,
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      textCapitalization: TextCapitalization.words,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: FormBuilderValidators.email(errorText: "Please Enter Valid Email Address"),
                      onChanged: (value) {
                        if (_key.currentState!.validate() && passwordController.text != "") {
                          setState(() {
                            isDisable = false;
                          });
                        } else {
                          setState(() {
                            isDisable = true;
                          });
                        }
                      },
                      decoration: InputDecoration(
                        // icon
                        prefixIcon: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.mail,
                              color: blue04C2F1,
                              size: 23,
                            )),
                        fillColor: blueF4FDFFCC,
                        hintText: "Enter Email Address",
                        labelText: "Email",
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                          borderSide: const BorderSide(
                            color: blueD1F5FF,
                            width: 1.5,
                          ),
                        ),
                        hintStyle: const TextStyle(
                          fontFamily: 'PoppinsRegular',
                          fontSize: 14,
                          color: black0B2732,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                          borderSide: const BorderSide(
                            color: blueD1F5FF,
                            width: 1.5,
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(15),
                      ),
                    ),
                    verticalSpaceMedium,
                    // password text field
                    FormBuilderTextField(
                      name: "password",
                      obscureText: show ? false : true,
                      controller: passwordController,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.words,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      // validator: FormBuilderValidators.required(
                      //   errorText: "Password can't be empty",
                      // ),
                      onChanged: (value) {
                        if (_key.currentState!.validate() && passwordController.text != "") {
                          setState(() {
                            isDisable = false;
                          });
                        } else {
                          setState(() {
                            isDisable = true;
                          });
                        }
                      },
                      decoration: InputDecoration(
                        // icon
                        prefixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              if (show) {
                                show = false;
                              } else {
                                show = true;
                              }
                            });
                          },
                          icon: show
                              ? const Icon(
                                  FontAwesomeIcons.solidEyeSlash,
                                  color: blue04C2F1,
                                  size: 18,
                                )
                              : const Icon(
                                  Icons.remove_red_eye_rounded,
                                  color: blue04C2F1,
                                ),
                        ),
                        fillColor: blueF4FDFFCC,
                        hintText: "Enter Password",
                        labelText: "Password",
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                          borderSide: const BorderSide(
                            color: blueD1F5FF,
                            width: 1.5,
                          ),
                        ),
                        hintStyle: const TextStyle(
                          fontFamily: 'PoppinsRegular',
                          fontSize: 14,
                          color: black0B2732,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                          borderSide: const BorderSide(
                            color: blueD1F5FF,
                            width: 1.5,
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(15),
                      ),
                    ),
                  ],
                ),
              ),
              verticalSpacesLarge,
             isDisable? CupertinoButton(
                color: gray939393,
                child: const Text(
                  "Log In",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onPressed: () {},
              ):
              CupertinoButton(
                color: blue,
                child: const Text(
                  "Log In",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onPressed: () { logIn(
                  emailController.text.trim(), passwordController.text.trim()
                );},
              )
            ],
          ),
        )),
      ),
      bottomNavigationBar: SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Do have any account?",
              style: TextStyle(
                fontSize: 17,
              ),
            ),
            horizontalSpaceSmall,
            CupertinoButton(
                child: const Text(
                  "Sign Up",
                  style: TextStyle(fontSize: 15, color: blue),
                ),
                onPressed: () {
                  Navigator.push(context, CupertinoPageRoute(
                    builder: (context) {
                      return const SignUpPage();
                    },
                  ));
                })
          ],
        ),
      ),
    );
  }
}
