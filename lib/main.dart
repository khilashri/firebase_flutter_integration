

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:userform/editprofile.dart';
import 'package:userform/login.dart';
import 'package:userform/sharedprefences.dart';
import 'package:userform/signup.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyDXl0PKk9z4rwEHvSoEgHffyDHAbAKBi5w",
            authDomain: "userform-c8cd5.firebaseapp.com",
            projectId: "userform-c8cd5",
            storageBucket: "userform-c8cd5.appspot.com",
            messagingSenderId: "991655315703",
            appId: "1:991655315703:web:770ec6c071418c95192bf2",
            measurementId: "G-H0ZL5N0V71"));
  } else {
    Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // fontFamily: GoogleFonts.montserrat().fontFamily,
        fontFamily: "Roboto",
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<String?>(
        builder: (context, snapshot) {
          print(snapshot);
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data != null) {
              return const EditProfile();
            } else {
              return const loginPage(title: '');
            }
          } else {
            return const CircularProgressIndicator();
          }
        },
        future: SharedPref.uidGetter(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _incrementCounter() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const loginPage(
                              title: "",
                            )));
              },
              child: (const Text('login')),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const signup()));
              },
              child: (const Text('SignUp')),
            ),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
