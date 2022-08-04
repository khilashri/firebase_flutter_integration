import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:userform/api.dart';
import 'package:userform/editprofile.dart';
import 'package:userform/forgetPassword.dart';
import 'package:userform/sharedprefences.dart';
import 'package:userform/signup.dart';

class loginPage extends StatefulWidget {
  const loginPage({Key? key, required String title}) : super(key: key);

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  final TextEditingController _controller = TextEditingController();
  String password = "";
  bool _isObsecure = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print(size.width);

    return Scaffold(
        appBar: AppBar(title: const Text('Login page')),
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: kIsWeb
                  ? size.width < 600
                      ? size.width * 0.04
                      : size.width * 0.2
                  : 0.02,
              vertical: kIsWeb ? size.height * 0.2 : size.height * 0.02),
          child: Column(
            children: [
              TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    labelText: 'User name',
                    hintText: 'Email',
                  )),
              TextField(
                obscureText: _isObsecure,
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObsecure ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObsecure = !_isObsecure;
                        });
                      },
                    ),
                    labelText: 'Password',
                    hintText: 'Password'),
                onChanged: (val) {
                  setState(() {
                    password = val;
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ForgotPassword()));
                      FirebaseAuth.instance
                          .sendPasswordResetEmail(email: _controller.text);
                    },
                    child: const Text('Forget password'),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const signup()));
                    },
                    child: const Text('Dont have an account'),
                  )
                ],
              ),
              ElevatedButton(
                onPressed: () async {
                  print(password);
                  print(_controller.text);
                  FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: _controller.text, password: password)
                      .then((value) {
                    // print(value.user.);

                    SharedPref.storageset(value.user!.uid);

                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EditProfile()));

                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('login Successful'.toString())));
                  }).catchError((e) {
                    if (e is FirebaseAuthException) {
                      print(e.message);
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.message.toString())));
                    }
                  });
                },
                child: const Text('Login'),
              ),
              TextButton(
                onPressed: () {
                  ApiService.signinwithgoogle();
                },
                child: (const Text('SignIn with google')),
              ),
            ],
          ),
        ));
  }
}
