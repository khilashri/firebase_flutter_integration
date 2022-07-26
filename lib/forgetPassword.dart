import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
   final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Email',
              hintText: 'Email',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              print(_controller.text);
              FirebaseAuth.instance
                  .sendPasswordResetEmail(email: _controller.text)
                  .then((value) => print('send on mail'));
            },
            child: const Text('Forgot Password'),
          )
        ]),
      ),
    );

  }
}
