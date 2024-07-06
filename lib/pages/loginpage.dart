import 'package:chatflutter/pages/signuppage.dart';
// import 'package:chatflutter/services/alertservice.dart';
// import 'package:chatflutter/services/authservice.dart';
import 'package:chatflutter/services/navigatorservice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
//here we are not using the services we are directly signin with the login funtion which we have made above

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GetIt _getIt = GetIt.instance;
  // late Authservice _authservice;
  late NavigationService _navigationService;
  // late Alertservice _alertservice;//to show the Toast msg but we have used some different method scaffoldMessage SnackBar
  String email = "", password = "";

  TextEditingController logpasscontroller = new TextEditingController();
  TextEditingController logemailcontroller = new TextEditingController();
  final _formkey = GlobalKey<FormState>();

  userlogin() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "LoggedIn Successfully",
            style: TextStyle(fontSize: 20),
          )));
      _navigationService.pushReplacementNamed("/home");

      // Navigator.pushReplacement(context,
      //     MaterialPageRoute(builder: (context) => HomePage())); //home page
      //apla class ahe
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-email") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              "No user found for that email",
              style: TextStyle(fontSize: 18, color: Colors.black),
            )));
      } else if (e.code == "invalid-credential") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              "Wrong password provided by User",
              style: TextStyle(fontSize: 18, color: Colors.black),
            )));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              "${e.code}",
              style: TextStyle(fontSize: 18, color: Colors.black),
            )));
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _authservice = _getIt.get<Authservice>();//here we are not using the services we are directly signin with the login funtion which we have made above
    _navigationService = _getIt.get<NavigationService>();
    // _alertservice = _getIt.get<Alertservice>();//to show the Toast msg but we have used some different method scaffoldMessage SnackBar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: true,
      body: Container(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 3,
                decoration: const BoxDecoration(
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
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: Text(""),
              ),
              Container(
                margin: const EdgeInsets.only(top: 60, left: 20, right: 20),
                child: Column(
                  children: [
                    Center(
                      child: Image.asset(
                        "assets/images/banner.png",
                        width: MediaQuery.of(context).size.width / 1.5,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_formkey.currentState!.validate()) {
                          setState(() {
                            email = logemailcontroller.text;
                            password = logpasscontroller.text;
                          });
                          userlogin();
                        }
                      },
                      child: Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 1.8,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white),
                          child: Form(
                            key: _formkey,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  "Login",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                TextFormField(
                                  controller: logemailcontroller,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please Enter Email";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      hintText: "Email",
                                      hintStyle: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                      suffixIcon: const Icon(Icons.email)),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                TextFormField(
                                  controller: logpasscontroller,
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
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                      suffixIcon:
                                          const Icon(Icons.remove_red_eye)),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // Navigator.push(context,
                                    //     MaterialPageRoute(builder: (context) {
                                    //   return
                                    //   ForgotPassword();
                                    // }));
                                  },
                                  child: Container(
                                      alignment: Alignment.topRight,
                                      child: Text(
                                        "Forget Password?",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      )),
                                ),
                                const SizedBox(
                                  height: 80,
                                ),
                                Material(
                                  elevation: 5,
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    width: 200,
                                    decoration: BoxDecoration(
                                      color: Colors.deepPurple,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "LOGIN",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 70,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignupPage()));
                      },
                      child: Text(
                        "Don't Have an Account? Sign Up",
                        style: TextStyle(
                            fontSize: 18,
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
}
