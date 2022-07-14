import 'package:flutter/material.dart';

enum LoginState {
  loggedOut,
  emailAddress,
  register,
  password,
  loggedIn,
}

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profil beállítások',
        ),
      ),
      body: const Text(
       "TODO"
      )
    );
  }
}