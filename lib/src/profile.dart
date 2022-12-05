import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'enums.dart';
import 'notes.dart';

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
    required this.deleteAcc,
    required this.resetPassword,
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
  final void Function(void Function(Exception e) error) deleteAcc;
  final void Function(
      String email,
      void Function(Exception e) error,
      ) resetPassword;

  Scaffold base(Widget child) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Profil beállítások',
          ),
        ),
        body: Center(
          child: Container(
            margin: const EdgeInsets.all(10.0),
            child: child,
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
        return base(
          Column(
            children: [
            const Text('Miért jó, ha van fiókod?'),
            ElevatedButton.icon(
                label: const Text('Új vagyok!'),
                icon: const Icon(Icons.add, size: 20),
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(300, 30),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  startRegister();
                }),
              ElevatedButton.icon(
                  label: const Text('Már tag vagyok!'),
                icon: const Icon(Icons.login, size: 20),
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(300, 30),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  startLogin();
                }),
          ],
        ));
      case LoginState.login:
        String email = '';
        String pswd = '';

        return base(Column(
          children: [
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
                        onChanged: (value) => email = value,
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
                        onChanged: (value) => pswd = value,
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
                        if (email != '') {
                        verifyEmail(
                            email,
                            (e) => _showHibaUzenet(
                                context,
                                'Ehhez az e-mail címhez nem tartozik felhasználó.',
                                e));
                      }
                      if (email != '' && pswd != '') {
                        signIn(
                            email,
                            pswd,
                            (e) => _showHibaUzenet(
                                context, 'Sikertelen bejelentkezés', e));
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
          ],
        ));
      case LoginState.register:
        String email = '';
        String nickname = '';
        String pswd1 = '';
        String pswd2 = '';

        return base(Column(
          children: [
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
                            onChanged: (value) => nickname = value,
                          )
                            ),
                            Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 24),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                              hintText: 'E-mail cím',
                            ),
                            onChanged: (value) => email = value,
                          )
                            ),
                            Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 24),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                              hintText: 'Jelszó',
                            ),
                            obscureText: true,
                            onChanged: (value) => pswd1 = value,
                          )
                            ),
                            Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 24),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                              hintText: 'Jelszó újra',
                            ),
                            obscureText: true,
                            onChanged: (value) => pswd2 = value,
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
                      megszakit();
                    },
                    child: const Text('Vissza'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 30),
                  child: ElevatedButton(
                    onPressed: () {
                      if (pswd1 == '' || pswd2 == '' || pswd1 != pswd2) {
                        _showHibaUzenet(
                            context,
                            'Hibás jelszó',
                            Exception(
                                'A beírt jelszavak nem egyeznek, próbáld újra!'));
                      } else if (email == '') {
                        _showHibaUzenet(context, 'Hibás e-mail',
                            Exception('E-mail cím megadása kötelező!'));
                      } else if (nickname == '') {
                        _showHibaUzenet(context, 'Hibás felhasználónév',
                            Exception('Felhasználónév megadása kötelező!'));
                      } else {
                        register(
                            email,
                            nickname,
                            pswd1,
                            (e) => _showHibaUzenet(
                                context, 'Sikertelen regisztráció', e));
                      }
                    },
                      child: const Text('Regisztrálok'),
                    ),
                  ),
                ],
              ),
            ],
          )
        );
      case LoginState.loggedIn:
        User? user = FirebaseAuth.instance.currentUser;

        return base(
          Column(children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20.0),
              padding: const EdgeInsets.all(15.0),
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.green,
                    width: 5
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [BoxShadow(
                    blurRadius: 10.0,
                    color: Colors.grey
                  )]
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(45.0),
                      child: Icon(
                        Icons.person,
                        size: 80,
                        color: Colors.green,
                      ),
                    ),
                    Text(
                      user!.displayName.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      letterSpacing: 2.5,
                    ),
                  ),
                    Text(user.email.toString())
                ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Notes()));
                },
                icon: const Icon(Icons.notes, size: 20),
                label: const Text('Jegyzeteim'),
                style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    minimumSize: const Size.fromHeight(50),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)))),
              ),
              ),
              /*Container(
                margin: const EdgeInsets.symmetric(vertical: 5.0),
                child: ElevatedButton.icon(
                  onPressed: () {}, // TODO form, ha kellenek még extra adatok
                  icon: const Icon(Icons.edit, size: 20),
                  label: const Text("Adatok módosítása"),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      minimumSize: const Size.fromHeight(50),
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12.0)))
                  ),
                )
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5.0),
                child: ElevatedButton.icon(
                  onPressed: () {}, // TODO jelszómódosító form
                  icon: const Icon(Icons.edit, size: 20),
                  label: const Text('Jelszó megváltoztatása'),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      minimumSize: const Size.fromHeight(50),
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12.0)))
                  ),
                )
              ),*/
            Container(
                margin: const EdgeInsets.symmetric(vertical: 5.0),
                child: ElevatedButton.icon(
                  onPressed: signOut,
                  icon: const Icon(Icons.logout, size: 20),
                  label: const Text('Kijelentkezés'),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      minimumSize: const Size.fromHeight(50),
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(12.0)))),
                )
              ),
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 35.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      showDialog<void>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text(
                              'Regisztráció törlése',
                            style: TextStyle(fontSize: 18),
                          ),
                            content: const Text(
                              'Biztosan törölni szeretnéd a fiókodat az alkalmazásból? A hozzátartozó adatok el fognak veszni.',
                            style: TextStyle(fontSize: 13),
                          ),
                            actions: <Widget>[
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Mégsem'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  deleteAcc((e) => _showHibaUzenet(context,
                                    'Hiba történt a felhasználó törlése közben.',
                                    e));
                              },
                              child: const Text('Igen'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.delete, size: 20),
                  label: const Text('Regisztráció törlése'),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.redAccent,
                      minimumSize: const Size.fromHeight(50),
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(12.0)))),
                )
              )
            ]
          ),
        );
      default:
        return base(const Text('Valami elromlott'));
    }
  }
}
