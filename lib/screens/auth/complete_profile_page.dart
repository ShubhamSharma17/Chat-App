// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/screens/home_page.dart';
import 'package:chat_app/utility/colors.dart';
import 'package:chat_app/utility/utility.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class CompleteProfilePage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const CompleteProfilePage({super.key, required this.userModel, required this.firebaseUser});
  

  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {

   final GlobalKey<FormBuilderState> key = GlobalKey<FormBuilderState>();
    TextEditingController fullnameController = TextEditingController();
    TextEditingController phoneNumberController = TextEditingController();
    bool isDisable = true;

    File? imageFile;
    
    // method for crop image
    void croppedImage(XFile file) async {
      CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: file.path,
        compressQuality: 70,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        );

      if(croppedImage != null){
        setState(() {
          imageFile = File(croppedImage.path);
        });
      }
    }


    // method for select image
    void selectImage(ImageSource source)async{
     XFile? pickedImage = await ImagePicker().pickImage(source: source);

     if(pickedImage != null){
      croppedImage(pickedImage);
     }
    }


    // method for showing photo option
    void showPhotoOption(){
      showDialog(context: context, builder: (context) {
        return  AlertDialog(
          title: const Text("Upload Profile Picture"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
            ListTile(
              onTap: () {
                Navigator.pop(context);
                selectImage(ImageSource.gallery);
              },
              title: const Text("Select from gallery"),
              leading: const Icon(Icons.photo),
            ),
             ListTile(
              onTap: () {
                Navigator.pop(context);
                selectImage(ImageSource.camera);
              },
              title: const Text("Select from Camera"),
              leading: const Icon(Icons.camera),

            ),
          ]),
        );
      },);
    }

    // method for upload data..
    void uploadData()async{

      // create upload data for image in firebase storage
      UploadTask task = FirebaseStorage.instance.ref("Profile Image").child(widget.userModel.uid.toString()).putFile(imageFile!);
      
      // uploading image
      TaskSnapshot snapshot =  await task;
      log("Uploading Data...");

      // get imageUrl from that snapshot
      String imageUrl = await snapshot.ref.getDownloadURL();
      String name = fullnameController.text;
      String phoneNumber = phoneNumberController.text;

      // assign data in user model which we get from complete profile screen 
      widget.userModel.fullname = name;
      widget.userModel.profilepic = imageUrl;
      widget.userModel.phoneNumber = phoneNumber;

      // upload user data on firebase
      await FirebaseFirestore.instance.collection("user").doc(widget.userModel.uid!).set(widget.userModel.toMap());
      log("Data Uploaded:)");
      Navigator.push(context, CupertinoPageRoute(builder: (context) {
        return HomePage(firebaseUser: widget.firebaseUser,userModel: widget.userModel,);
      },));


    }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Complete Profile",
          style: TextStyle(
            color: white,
          ),
        ),
      ),
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: ListView(
          children: [
            verticalSpaceMedium,
            // profile picture
            CupertinoButton(
              onPressed: () {
                showPhotoOption();
              },
              padding: const EdgeInsets.all(0),
              child:  CircleAvatar(
                radius: 60,
                backgroundImage:
                    imageFile != null ? FileImage(imageFile!) : null,
                child: imageFile == null
                    ? const Icon(Icons.person, size: 60)
                    : null,
              ),
            ),
            verticalSpaceMedium,
            // Full Name text field..
            FormBuilder(
                key: key,
                child: Column(
                  children: [
                    // full name text field
                    FormBuilderTextField(
                      name: "full name",
                      controller: fullnameController,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.words,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onChanged: (value) {
                        if (key.currentState!.validate() && fullnameController.text != ""
                              && phoneNumberController.text.length == 10 && imageFile != null) {
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
                          icon: const Icon(Icons.person),
                        ),
                        fillColor: blueF4FDFFCC,
                        hintText: "Enter Full Name",
                        labelText: "Full Name",
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
                    // Phone Number text field
                    FormBuilderTextField(
                      name: "Phone Number",
                      controller: phoneNumberController,
                      keyboardType: TextInputType.phone,
                      textCapitalization: TextCapitalization.words,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      maxLength: 10,
                      onChanged: (value) {
                        if (key.currentState!.validate()&& fullnameController.text != ""
                              && phoneNumberController.text.length == 10 && imageFile != null) {
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
                          icon: const Icon(Icons.phone),
                        ),
                        fillColor: blueF4FDFFCC,
                        hintText: "Enter Phone Number",
                        labelText: "Phone Number",
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
                )),
            verticalSpaceMedium,
            // submit button..
            isDisable
                ? CupertinoButton(
                    onPressed: () {},
                    color: gray8F959E,
                    child: const Text(
                      "Submit",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
                  )
                : CupertinoButton(
                    onPressed: () {
                      uploadData();
                    },
                    color: Theme.of(context).colorScheme.secondary,
                    child: const Text(
                      "Submit",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
                  )
          ],
        ),
      )),
    ));
  }
}
