import 'package:flutter/services.dart';

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

  //Handling signup and signin; means of toggling obscuring password text
  bool signUp, _obscure = true;

  //handling form validation and keyboard actions
  final _formKey = GlobalKey<FormState>();
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    //getting device dimensions to size components accordingly
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Form(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: height,
            width: width,
            child: Padding(
              padding: EdgeInsets.only(right: width * 0.06, left: width * 0.06),
              child: Column(children: [
                Padding(
                  padding: EdgeInsets.only(top: height * 0.08),
                  child: Container(
                    width: width * 0.44,
                    height: height * 0.13,
                    child: Image.asset(
                      'assets/jotit-logo-transparent.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                SizedBox(height: height * 0.10),
                Container(
                  child: TextFormField(
                    controller: emailController,
                    textInputAction: TextInputAction.next,
                    validator: (String email) {
                      if (email == '') {
                        return 'please enter a email';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Email@gmail.com',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                Container(
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    validator: (String password) {
                      if (password == '') {
                        return 'please enter a password';
                      } else {
                        return null;
                      }
                    },
                    textInputAction: TextInputAction.done,
                    controller: passwordController,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _obscure = !_obscure;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    obscureText: _obscure,
                  ),
                ),
                SizedBox(
                  height: height * 0.05,
                ),
                ButtonTheme(
                  minWidth: width * 0.25,
                  height: height * 0.08,
                  child: FlatButton(
                    color: Color.fromRGBO(225, 225, 225, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    onPressed: () => {
                      if (_formKey.currentState.validate())
                        {_formKey.currentState.save()},
                      if (signUp)
                        {
                          //Provider sign up method
                          context.read<AuthenticationProvider>().signUp(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim()),
                        }
                      else
                        {
                          //Provider sign in method
                          context.read<AuthenticationProvider>().signIn(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim()),
                        }
                    },
                    child: Text(
                      signUp ? 'Sign in' : 'Sign up',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.05),
                TextButton(
                  onPressed: null,
                  child: Text(
                    'Forgot password?',
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  ),
                ),
                SizedBox(
                  height: height * 0.15,
                ),
                TextButton(
                  onPressed: () {
                    signUp = !signUp;
                  },
                  child: Text.rich(
                    TextSpan(
                      text: signUp
                          ? 'Don\'t have an account? '
                          : 'Have an account? ',
                      style: TextStyle(color: Colors.black, fontSize: 14),
                      children: [
                        TextSpan(
                          text: signUp ? 'Register' : 'Sign in',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscure = true;
  bool signUp = false;

  final _formKey = GlobalKey<FormState>();
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Form(
        key: _formKey,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              height: height,
              width: width,
              child: Padding(
                padding:
                    EdgeInsets.only(right: width * 0.06, left: width * 0.06),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: height * 0.08),
                      child: Container(
                        width: width * 0.44,
                        height: height * 0.13,
                        child: Image.asset(
                          'assets/jotit-logo-transparent.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.05,
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Email',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 20),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Container(
                      child: TextFormField(
                        controller: _emailController,
                        focusNode: _emailFocusNode,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: (String email) {
                          if (email == '') {
                            return 'please enter a email';
                          } else {
                            return null;
                          }
                        },
                        //onSaved: (email) => _email = email,
                        decoration: InputDecoration(
                          hintText: 'Email@gmail.com',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        onFieldSubmitted: (_) {
                          fieldFocusChange(
                              context, _emailFocusNode, _passwordFocusNode);
                        },
                      ),
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Password',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 20),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Container(
                      child: TextFormField(
                        focusNode: _passwordFocusNode,
                        keyboardType: TextInputType.text,
                        validator: (String password) {
                          if (password == '') {
                            return 'please enter a password';
                          } else {
                            return null;
                          }
                        },
                        textInputAction: TextInputAction.done,
                        controller: _passwordController,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          suffixIcon: IconButton(
                            icon: Icon(Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _obscure = !_obscure;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        obscureText: _obscure,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.05,
                    ),
                    ButtonTheme(
                      minWidth: 220,
                      height: 50,
                      child: FlatButton(
                        color: Color.fromRGBO(225, 225, 225, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        onPressed: () => {
                          if (_formKey.currentState.validate())
                            {
                              _formKey.currentState.save(),
                              if (signUp)
                                {
                                  //Provider sign up method
                                  context.read<AuthenticationProvider>().signUp(
                                      email: _emailController.text.trim(),
                                      password:
                                          _passwordController.text.trim()),
                                }
                              else
                                {
                                  //Provider sign in method
                                  context.read<AuthenticationProvider>().signIn(
                                      email: _emailController.text.trim(),
                                      password:
                                          _passwordController.text.trim()),
                                }
                            }
                        },
                        child: signUp
                            ? Text(
                                'Sign in',
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              )
                            : Text(
                                'Sign up',
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    TextButton(
                        onPressed: null,
                        child: Text(
                          'Forgot password?',
                          style: TextStyle(color: Colors.black, fontSize: 12),
                        )),
                    SizedBox(
                      height: height * 0.15,
                    ),
                    TextButton(
                      onPressed: () {
                        signUp = !signUp;
                      },
                      child: signUp
                          ? Text.rich(
                              TextSpan(
                                  text: 'Don\'t have an account? ',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14),
                                  children: [
                                    TextSpan(
                                      text: 'Register',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                  ]),
                            )
                          : Text.rich(
                              TextSpan(
                                  text: 'Have an account? ',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14),
                                  children: [
                                    TextSpan(
                                      text: 'Sign in',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                  ]),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
