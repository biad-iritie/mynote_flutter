import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: 'Please enter email'),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration:
                const InputDecoration(hintText: 'Please enter password'),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;

              try {
                final UserCredential = await FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                        email: email, password: password);
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/notes/', (route) => false);
                devtools.log(UserCredential.toString());
              } on FirebaseAuthException catch (e) {
                switch (e.code) {
                  case 'user-not-found':
                    devtools.log("User not found");
                    break;
                  case 'wrong-password':
                    devtools.log("Wrong password");
                    break;
                  default:
                    devtools.log("Something bad happen");
                    devtools.log(e.code);
                }
              }
              /* catch (e) {
                          devtools.log(e.runtimeType);
                          devtools.log("Something bad happen");
                        } */
            },
            child: const Text('Login'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/register/', (route) => false);
            },
            child: const Text('Not register yet ? Register here!'),
          )
        ],
      ),
    );
  }
}
