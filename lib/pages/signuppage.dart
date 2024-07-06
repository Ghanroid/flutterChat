import 'dart:io';

import 'package:chatflutter/models/userprofile.dart';
import 'package:chatflutter/pages/home.dart';
import 'package:chatflutter/pages/loginpage.dart';
import 'package:chatflutter/services/alertservice.dart';
import 'package:chatflutter/services/authservice.dart';
import 'package:chatflutter/services/databaseservice.dart';
import 'package:chatflutter/services/mediaservice.dart';
import 'package:chatflutter/services/storageservice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  File? selectedImage;
  late Storageservice _storageservice;
  String email = "", password = "", name = "";
  final GetIt _getIt = GetIt.instance;
  late Mediaservice _mediaservice;
  late Authservice _authservice;
  late Alertservice _alertservice;
  late Databaseservice _databaseservice;
  TextEditingController namecontroller = new TextEditingController();
  TextEditingController passcontroller = new TextEditingController();
  TextEditingController emailcontroller = new TextEditingController();
  final _formkey = GlobalKey<FormState>();
  registration() async {
    // if (password != null) {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      String? pfpurl = await _storageservice.uploadUserpfp(
          file: selectedImage!, uid: _authservice.user!.uid);
      if (pfpurl != null) {
        await _databaseservice.createUserprofile(
            userprofile: Userprofile(
                uid: _authservice.user!.uid, name: name, pfpurl: pfpurl));
      } else {
        throw Exception("Unable to uplaod profile picture");
      }
      _alertservice.showToast(
          text: "Registered Successfully", icon: Icons.check);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Registration Successfully",
            style: TextStyle(fontSize: 20),
          )));

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
      //apla class ahe
    } on FirebaseAuthException catch (e) {
      _alertservice.showToast(
          text: "Failed to register, Please try again!", icon: Icons.error);
      if (e.code == "Weak-password") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          "Too weak password Please provide a strong password",
          style: TextStyle(fontSize: 10),
        )));
      } else if (e.code == "email-already-in-use") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          "Account alredy exists",
          style: TextStyle(fontSize: 10),
        )));
      }
    }
    // }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _mediaservice = _getIt.get<Mediaservice>();
    _storageservice = _getIt.get<Storageservice>();
    _authservice = _getIt.get<Authservice>();
    _databaseservice = _getIt.get<Databaseservice>();
    _alertservice = _getIt.get<Alertservice>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 3,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.purple, Colors.deepPurple])),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 3.3),
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: Text(""),
              ),
              Container(
                margin: EdgeInsets.only(top: 60, left: 20, right: 20),
                child: Column(
                  children: [
                    Center(
                      child: Image.asset(
                        "assets/images/banner.png",
                        width: MediaQuery.of(context).size.width / 1.5,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 1.5,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white),
                        child: Form(
                          key: _formkey,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "SignUp",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              _pfp(),
                              SizedBox(
                                height: 30,
                              ),
                              TextFormField(
                                controller: namecontroller,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please Enter Username";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    hintText: "Username",
                                    hintStyle: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                    suffixIcon: Icon(Icons.person)),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              TextFormField(
                                controller: emailcontroller,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please Enter Email";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    hintText: "Email",
                                    hintStyle: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                    suffixIcon: Icon(Icons.email)),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              TextFormField(
                                controller: passcontroller,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please Enter Password";
                                  }
                                  return null;
                                },
                                obscureText: true,
                                decoration: InputDecoration(
                                    hintText: "Password",
                                    hintStyle: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                    suffixIcon: Icon(Icons.remove_red_eye)),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (_formkey.currentState!.validate()) {
                                    setState(() {
                                      email = emailcontroller.text;
                                      name = namecontroller.text;
                                      password = passcontroller.text;
                                    });
                                    registration();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomePage()));
                                  }
                                },
                                child: Material(
                                  elevation: 5,
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    width: 200,
                                    decoration: BoxDecoration(
                                      color: Colors.deepPurple,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "SIGNUP",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Poppins',
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
                      },
                      child: Text(
                        "Already have an account? Login",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
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

  Widget _pfp() {
    return GestureDetector(
      onTap: () async {
        File? file = await _mediaservice.getImagefromGallery();
        if (file != null) {
          setState(() {
            selectedImage = file;
          });
        }
      },
      child: CircleAvatar(
        radius: MediaQuery.of(context).size.width * 0.15,
        backgroundImage: selectedImage != null
            ? FileImage(selectedImage!)
            : NetworkImage(
                    "https://www.pngall.com/wp-content/uploads/5/Profile-Male-PNG.png")
                as ImageProvider,
      ),
    );
  }
}
