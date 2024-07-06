import 'package:chatflutter/models/userprofile.dart';
import 'package:flutter/material.dart';

class Chattitle extends StatelessWidget {
  final Userprofile userprofile;
  final Function ontap;
  const Chattitle({super.key, required this.userprofile, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: false,
      onTap: () {
        ontap();
      },
      leading: CircleAvatar(
        backgroundImage: NetworkImage(userprofile.pfpurl!),
      ),
      title: Text(userprofile.name!),
    );
  }
}
