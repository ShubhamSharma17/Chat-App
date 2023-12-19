// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/screens/auth/complete_profile_page.dart';
import 'package:chat_app/utility/ui_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../utility/colors.dart';
import '../../utility/utility.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormBuilderState> _key = GlobalKey<FormBuilderState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool isDisable = true;
  bool show = false;
  bool show1 = false;


  // method for check value
  void checkValue(){
    String email = emailController.text.toString();
    String password = passwordController.text.toString();
    String confirmPassword = confirmPasswordController.text.toString();

    if(email == ""){
      UIHelper.showAlertDialog(context,"error" ,"Email can't be empty" );
    }
    else if( password == "" || confirmPassword == ""){
      UIHelper.showAlertDialog(context,"error" ,"password can't be empty" );
    }
    else if(password != confirmPassword){
      UIHelper.showAlertDialog(context,"error" ,"password doesn't match" );
    }
    else{
      signUp(email, password);
    }
  }

  // method for sign up..
  void signUp(String email, String password) async {
    UIHelper.showLoadingDialog(context, "Creating New Account....");
    UserCredential? credential;
    try {
      credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseException catch (error) {
      Navigator.pop(context);
      UIHelper.showAlertDialog(
          context, "An Error Occurred", error.code.toString());
      log(error.code.toString());
    }
    if (credential != null) {
      String uid = credential.user!.uid;
      UserModel userModel = UserModel(
        email: email,
        uid: uid,
        fullname: "",
        phoneNumber: "",
        profilepic: "",
      );
      await FirebaseFirestore.instance
          .collection("user")
          .doc(uid)
          .set(userModel.toMap())
          .then((value) {
        emailController.clear();
        passwordController.clear();
        confirmPasswordController.clear();
        log("User Has been created!");
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
            builder: (context) {
              return CompleteProfilePage(
                  userModel: userModel, firebaseUser: credential!.user!);
            },
          ),
        );
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // heading..
                  const Text(
                    "We Chat",
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w500,
                      color: Colors.blueAccent,
                    ),
                  ),
                  SizedBox(height: screenHeight(context) * .05),
                  // form builder..
                  FormBuilder(
                    key: _key,
                    child: Column(
                      children: [
                        // email text field
                        FormBuilderTextField(
                          name: "email address",
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          textCapitalization: TextCapitalization.words,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: FormBuilderValidators.email(
                            errorText: "Please Enter Valid Email Address",
                          ),
                          onChanged: (value) {
                            if (_key.currentState!.validate() &&
                                passwordController.text != "" &&
                                confirmPasswordController.text != "") {
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
                            hintText: "Enter Email",
                            labelText: "Email",
                            fillColor: blueF4FDFFCC,
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
                        SizedBox(height: screenHeight(context) * .02),
                        // password text field...
                        FormBuilderTextField(
                          obscureText: show ? false : true,
                          name: "Password",
                          controller: passwordController,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          // autovalidateMode: AutovalidateMode.onUserInteraction,
                          // validator: FormBuilderValidators.compose(
                          //   [
                          //     FormBuilderValidators.match(
                          //         confirmPasswordController.text,
                          //         errorText: "Password must be same"),
                          //   ],
                          // ),
                          // onChanged: (value) {
                          //   if (_key.currentState!.validate() &&
                          //       passwordController.text != "" &&
                          //       confirmPasswordController.text != "") {
                          //     setState(() {
                          //       isDisable = false;
                          //     });
                          //   } else {
                          //     setState(() {
                          //       isDisable = true;
                          //     });
                          //   }
                          // },
                          decoration: InputDecoration(
                            labelText: "Password",
                            hintText: "Enter Password",
                            prefixIcon: IconButton(
                                onPressed: () {
                                  if (show) {
                                    setState(() {
                                      show = false;
                                    });
                                  } else {
                                    setState(() {
                                      show = true;
                                    });
                                  }
                                },
                                icon: show
                                    ? const Icon(
                                        CupertinoIcons.eye_slash_fill,
                                        color: blue04C2F1,
                                        size: 23,
                                      )
                                    : const Icon(
                                        color: blue04C2F1,
                                        Icons.remove_red_eye,
                                        size: 23,
                                      )),
                            fillColor: blueF4FDFFCC,
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
                        SizedBox(height: screenHeight(context) * .02),

                        // confirm password text field..
                        FormBuilderTextField(
                          name: "Confirm Password",
                          controller: confirmPasswordController,
                          // autovalidateMode: AutovalidateMode.onUserInteraction,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          obscureText: show1 ? false : true,
                          // validator: FormBuilderValidators.compose(
                          //   [
                          //     FormBuilderValidators.match(
                          //         passwordController.text,
                          //         errorText: "Confirm Password must be same"),
                          //   ],
                          // ),
                          // onChanged: (value) {
                          //   if (_key.currentState!.validate() &&
                          //       passwordController.text != "" &&
                          //       confirmPasswordController.text != "") {
                          //     setState(() {
                          //       isDisable = false;
                          //     });
                          //   } else {
                          //     setState(() {
                          //       isDisable = true;
                          //     });
                          //   }
                          // },
                          decoration: InputDecoration(
                            labelText: "Confirm Password",
                            hintText: "Enter Confirm Password",
                            prefixIcon: IconButton(
                                onPressed: () {
                                  if (show1) {
                                    setState(() {
                                      show1 = false;
                                    });
                                  } else {
                                    setState(() {
                                      show1 = true;
                                    });
                                  }
                                },
                                icon: show1
                                    ? const Icon(
                                        CupertinoIcons.eye_slash_fill,
                                        color: blue04C2F1,
                                        size: 23,
                                      )
                                    : const Icon(
                                        color: blue04C2F1,
                                        Icons.remove_red_eye,
                                        size: 23,
                                      )),
                            fillColor: blueF4FDFFCC,
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
                        )
                      ],
                    ),
                  ),
                  verticalSpaceMedium,
                  // sign up button..
                  // isDisable
                  //     ? CupertinoButton(
                  //         onPressed: () {},
                  //         color: gray8F959E,
                  //         child: const Text(
                  //           "Sign Up",
                  //           style: TextStyle(
                  //             color: Colors.white,
                  //             fontWeight: FontWeight.w500,
                  //             letterSpacing: 0.5,
                  //           ),
                  //         ),
                  //       )
                  //     : 
                      CupertinoButton(
                          onPressed: () {
                            // signUp(emailController.text.trim(),
                            //     passwordController.text.trim());
                            checkValue();
                          },
                          color: Theme.of(context).colorScheme.secondary,
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Already have an account?",
                style: TextStyle(fontSize: 16),
              ),
              CupertinoButton(
                child: const Text(
                  "Log In",
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
