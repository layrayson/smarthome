import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool loading = false;
  bool hasError = false;
  String? error = '';
  Future signIn() async {
    try {
      setState(() {
        loading = true;
      });
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());

      setState(() {
        loading = false;
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        error = e.message;
        hasError = true;
        loading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Center(
              child: SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            'SmartHome',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
          ),
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
              hasError
                  ? Text(
                      error ?? '',
                      style: TextStyle(color: Colors.red[500]),
                    )
                  : SizedBox(),
              SizedBox(
                height: 50,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey[600],
                  // border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: TextField(
                  controller: _emailController,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      border: InputBorder.none,
                      hintText: 'Email',
                      hintStyle: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey[600],
                  // border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: TextField(
                  obscureText: true,
                  controller: _passwordController,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      border: InputBorder.none,
                      hintText: 'Password',
                      hintStyle: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: GestureDetector(
              onTap: () {
                if (_emailController.text == '' ||
                    _passwordController.text == '') {
                  setState(() {
                    error = 'Invalid email or password';
                    hasError = true;
                  });
                  return;
                }
                signIn();
              },
              child: Container(
                height: 50,
                // padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.blue[900],
                    borderRadius: BorderRadius.circular(8)),
                child: Center(
                    child: loading
                        ? SpinKitCircle(
                            color: Colors.white,
                            size: 20,
                          )
                        : Text(
                            'Sign in',
                            style: TextStyle(color: Colors.white),
                          )),
              ),
            ),
          )
        ]),
      ))),
    );
  }
}
