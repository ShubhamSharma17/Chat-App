import 'package:chat_app/utility/colors.dart';
import 'package:chat_app/utility/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class CompleteProfilePage extends StatefulWidget {
  const CompleteProfilePage({super.key});

  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormBuilderState> key = GlobalKey<FormBuilderState>();
    TextEditingController fullnameController = TextEditingController();
    TextEditingController phoneNumberController = TextEditingController();
    bool isDisable = true;
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
            // CupertinoButton(
            //   onPressed: () {
            //     showPhotoOption();
            //   },
            //   padding: const EdgeInsets.all(0),
            //   child: CircleAvatar(
            //     radius: 60,
            //     backgroundImage:
            //         imageFile != null ? FileImage(imageFile!) : null,
            //     child: imageFile == null
            //         ? const Icon(Icons.person, size: 60)
            //         : null,
            //   ),
            // ),
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
                      validator: FormBuilderValidators.required(
                        errorText: "Full Name can't be empty",
                      ),
                      onChanged: (value) {
                        if (key.currentState!.validate()) {
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
                      validator: FormBuilderValidators.required(
                        errorText: "Phone can't be empty",
                      ),
                      onChanged: (value) {
                        if (key.currentState!.validate()) {
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
                      // checkValues();
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
