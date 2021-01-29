import 'authentication.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  //Controllers for e-mail and password textfields.
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  //Handling signup and signin
  bool signUp = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
              padding: const EdgeInsets.all(0.0),
              child: Container(child: Image.asset('assets/jotit-logo-transparent.png', width: 230, height: 70))
          ),
          //e-mail textfield
          SizedBox(
            height: 20.0,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "Email",
              ),
            ),
          ),

          //password textfield
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: "Password",
              ),
            ),
          ),

          SizedBox(
            height: 30.0,
          ),
          //Sign in / Sign up button
          RaisedButton(
            onPressed: () {
              if (signUp) {
                //Provider sign up method
                context.read<AuthenticationProvider>().signUp(
                  email: emailController.text.trim(),
                  password: passwordController.text.trim(),
                );
              } else {
                //Provider sign in method
                context.read<AuthenticationProvider>().signIn(
                  email: emailController.text.trim(),
                  password: passwordController.text.trim(),
                );
              }
            },
            child: signUp ? Text("Sign Up") : Text("Sign In"),
          ),

          //Sign up / Sign In toggler
          OutlineButton(
            onPressed: () {
              setState(() {
                signUp = !signUp;
              });
            },
            child: signUp ? Text("Have an account? Sign In") : Text("Create an account"),
          )

        ],

      ),
    );

  }

}