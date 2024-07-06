import 'package:chatflutter/models/userprofile.dart';
import 'package:chatflutter/pages/chatpage.dart';
import 'package:chatflutter/pages/chattitle.dart';
import 'package:chatflutter/services/alertservice.dart';
import 'package:chatflutter/services/authservice.dart';
import 'package:chatflutter/services/databaseservice.dart';
import 'package:chatflutter/services/navigatorservice.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart';

//for logout button i have used authservices class trying to use multiple type of implementation
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GetIt _getIt = GetIt.instance;
  late NavigationService _navigationService;
  late Authservice _authservice;
  late Alertservice _alertservice;
  late Databaseservice _databaseservice;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _authservice = _getIt.get<Authservice>();
    _navigationService = _getIt.get<NavigationService>();
    _alertservice = _getIt.get<Alertservice>();
    _databaseservice = _getIt.get<Databaseservice>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          // padding: const EdgeInsets.only(top: 20),
          child: const Text(
            "Message",
            style: TextStyle(color: Colors.white),
          ),
        ),
        actions: [
          Container(
            padding: const EdgeInsets.only(top: 10.0),
            child: IconButton(
                onPressed: () async {
                  bool result = await _authservice.logout();
                  if (result) {
                    _alertservice.showToast(
                        text: "Successfully logged out!!", icon: Icons.check);
                    _navigationService.pushReplacementNamed("/login");
                  }
                },
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                )),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: _chatlist(),
        ),
      ),
    );
  }

  Widget _chatlist() {
    return StreamBuilder(
      stream: _databaseservice.getUserprofile(),
      builder: (Context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text("Unabale to laod data"),
          );
        }
        print(snapshot.data);
        if (snapshot.hasData && snapshot.data != null) {
          final users = snapshot.data!.docs;
          return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                Userprofile user = users[index].data();
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Chattitle(
                      userprofile: user,
                      ontap: () async {
                        final chatExists = await _databaseservice
                            .checkChatExists(_authservice.user!.uid, user.uid!);
                        if (!chatExists) {
                          await _databaseservice.createNewChat(
                              _authservice.user!.uid, user.uid!);
                        }
                        _navigationService
                            .push(MaterialPageRoute(builder: (Context) {
                          return Chatpage(
                            chatuser: user,
                          );
                        }));
                      }),
                );
              });
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
