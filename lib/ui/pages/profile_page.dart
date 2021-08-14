import 'package:flutter/material.dart';
import 'package:money_tracker/data/models/user.dart';

class ProfilePage extends StatelessWidget {
  final MyAppUser user;
  const ProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text('Welcome ${user.name!}'),
      ),
    );
  }
}
