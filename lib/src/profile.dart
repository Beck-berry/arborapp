import 'package:flutter/material.dart';

import 'enums.dart';

class Profile extends StatelessWidget {
  const Profile({
    required this.loginState,
    required this.startLogin,
    required this.startRegister,
    required this.verifyEmail,
    required this.signIn,
    required this.megszakit,
    required this.register,
    required this.signOut,
    super.key
  });

  final LoginState loginState;
  final void Function() startLogin;
  final void Function() startRegister;
  final void Function(
      String email,
      void Function(Exception e) error,
      ) verifyEmail;
  final void Function(
      String email,
      String password,
      void Function(Exception e) error,
      ) signIn;
  final void Function() megszakit;
  final void Function(
      String email,
      String nickname,
      String password,
      void Function(Exception e) error,
      ) register;
  final void Function() signOut;

  Scaffold base(List<Widget> children) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Profil beállítások',
          ),
        ),
        body: Center(
          child: Column(
            children: children,
          )
        )
    );
  }

  void _showHibaUzenet(BuildContext context, String title, Exception e) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(fontSize: 20),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  '${(e as dynamic).message}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Oké',
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    switch(loginState) {
      case LoginState.loggedOut:
        return base([
          const Text("Miért jó, ha van fiókod?"),
          ElevatedButton.icon(
            label: const Text("Új vagyok!"),
            icon: const Icon(Icons.add, size: 20),
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(300, 30),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              startRegister();
            }
          ),
          ElevatedButton.icon(
            label: const Text("Már tag vagyok!"),
            icon: const Icon(Icons.login, size: 20),
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(300, 30),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              startLogin();
            }
          ),
        ]);
      case LoginState.login:
        String _email = "";
        String _pswd = "";

        return base([
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Regisztrált e-mail cím',
                        ),
                        onChanged: (value) => _email = value,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Jelszavad',
                      ),
                      obscureText: true,
                      onChanged: (value) => _pswd = value,
                    ),
                  ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 30),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_email != "") {
                        verifyEmail(_email, (e) => _showHibaUzenet(context,
                                    'Ehhez az e-mail címhez nem tartozik felhasználó.', e));
                      }
                      if (_email != "" && _pswd != "") {
                        signIn(_email, _pswd, (e) =>
                                _showHibaUzenet(context, 'Sikertelen bejelentkezés', e));
                      }
                    },
                    child: const Text('Belépek'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 30),
                  child: ElevatedButton(
                    onPressed: () {
                      megszakit();
                    },
                    child: const Text('Vissza'),
                  ),
                ),
              ],
            ),
        ]);
      case LoginState.register:
        String _email = "";
        String _nickname = "";
        String _pswd1 = "";
        String _pswd2 = "";

        return base([
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Felhasználónév',
                      ),
                      onChanged: (value) => _nickname = value,
                    )
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'E-mail cím',
                        ),
                        onChanged: (value) => _email = value,
                      )
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Jelszó',
                        ),
                        obscureText: true,
                        onChanged: (value) => _pswd1 = value,
                      )
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Jelszó újra',
                        ),
                        obscureText: true,
                        onChanged: (value) => _pswd2 = value,
                      )
                  ),
                ]
              )
            )
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 30),
                child: ElevatedButton(
                  onPressed: () {
                    if (_pswd1 == "" || _pswd2 == "" || _pswd1 != _pswd2) {
                      _showHibaUzenet(context, "Hibás jelszó", Exception("A beírt jelszavak nem egyeznek, próbáld újra!"));
                    } else if (_email == "") {
                      _showHibaUzenet(context, "Hibás e-mail", Exception("E-mail cím megadása kötelező!"));
                    } else if (_nickname == "") {
                      _showHibaUzenet(context, "Hibás felhasználónév", Exception("Felhasználónév megadása kötelező!"));
                    } else {
                      register(_email, _nickname, _pswd1,
                              (e) => _showHibaUzenet(context, "Sikertelen regisztráció", e));
                    }
                  },
                  child: const Text('Regisztrálok'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 30),
                child: ElevatedButton(
                  onPressed: () {
                    megszakit();
                  },
                  child: const Text('Vissza'),
                ),
              ),
            ],
          ),
        ]);
      case LoginState.loggedIn:
        return base([
          const Text("Be vagyok lépve!"),
          ElevatedButton.icon(
              onPressed: signOut,
              icon: const Icon(Icons.logout, size: 20),
              label: const Text("Kijelentkezés")
          )
        ]);
      default:
        return base([const Text("Valami elromlott :(")]);
    }
  }
}
