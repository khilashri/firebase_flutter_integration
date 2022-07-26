import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:userform/api.dart';
import 'package:userform/login.dart';
import 'package:userform/userData.dart';



class signup extends StatefulWidget {
  const signup({Key? key}) : super(key: key);

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  final TextEditingController _controller = TextEditingController();
  String password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:  const Text('SignUpPage')),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    labelText: 'User name',
                    hintText: 'Email',
                  )),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'password',
                  hintText: 'password',
                ),
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
                              builder: (context) => const loginPage(title: '',)));
                    },
                    child: const Text('Already have an account'),
                  )
                ],
              ),
              
               
              ElevatedButton(
                onPressed: () {
                    
                  print(password);
                  print(_controller.text);
                  FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: _controller.text, password: password)
                      .then((value) {
                    print(value.user!.uid);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>  UserData(
                                  id: value.user!.uid,
                                  email:value.user!.email!

                                                
                                  
                                )));

                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('create account'))); 
                  }).catchError((e) {
                    if (e is FirebaseAuthException) {
                      print(e.message);
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.message.toString())));
                    }
                  });
                },
                child: const Text('SignUp'),
              ),
              TextButton(
                onPressed: () {
                  ApiService.signinwithgoogle();
                },
                child: (const Text('SignIn with google')),
              ),
            ],
          )),
    );
  }
}
