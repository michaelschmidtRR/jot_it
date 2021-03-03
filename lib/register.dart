import 'package:flutter/services.dart';
import 'package:jot_it/login.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'authentication.dart';


class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}
class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _key = new GlobalKey();
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _validate = false;
  bool visible = true;
  String mobile, password;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //getting device dimensions to size components accordingly
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return new Scaffold(
      key: scaffoldKey,
      bottomNavigationBar: new Container(
          width: width, child: _linkSignIn(context)),
      body: new Form(key: _key, autovalidate: _validate, child: _body(context, width, height)),
    );
  }

  _body(BuildContext context, double width, double height) =>

      ListView(physics: BouncingScrollPhysics(), children: <Widget>[
        Container(
            padding: EdgeInsets.all(15),
            child: Column(
                children: <Widget>[_formUI(context, width, height), _socialSignIn(width, height)]))
      ]);

  @override
  void dispose() {
    if (this.mounted) super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  _formUI(BuildContext context, double width, double height) {
    return new Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: height * 0.08),
            child: Container(
              width: width * 0.44,
              height: height * 0.13,
              child: Image.asset(
                'assets/test.png',
                fit: BoxFit.fill,
              ),
            ),
          ),
          SizedBox(height: height * 0.08),
          _inputEmail(),
          SizedBox(height: height * 0.02),
          _inputPassword(),
          SizedBox(height: height * 0.02),
          SizedBox(
              width: double.infinity,
              child: RaisedButton(
                color: Colors.amberAccent,
                textColor: Colors.white,
                splashColor: Colors.amber,
                elevation: 0,
                highlightElevation: 0,
                padding: const EdgeInsets.all(15.0),
                child: Text("SIGN UP"),
                onPressed: () {
                  _sendToServer(context);
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
              )),
        ],
      ),
    );
  }

  _inputEmail() {
    return new TextFormField(
      controller: _emailController,
      decoration: new InputDecoration(
        contentPadding: const EdgeInsets.all(16.0),
        hintText: 'Email',
        prefixIcon: _prefixIcon(Icons.email),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none),
        filled: true,
        fillColor: Colors.grey.withOpacity(0.1),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: validateEmail,
      onSaved: (str) {
        mobile = str;
      },
    );
  }

  _inputPassword() {
    return TextFormField(
        controller: _passwordController,
        obscureText: visible,
        validator: validatePassword,
        readOnly: false,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(16.0),
          hintText: 'Password',
          prefixIcon: _prefixIcon(Icons.lock),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none),
          filled: true,
          fillColor: Colors.grey.withOpacity(0.1),
          suffix: InkWell(
            child: visible
                ? Icon(
              Icons.visibility_off,
              size: 16,
              color: Colors.amber,
            )
                : Icon(
              Icons.visibility,
              size: 16,
              color: Colors.amber,
            ),
            onTap: () {
              setState(() {
                visible = !visible;
              });
            },

          ),
        ),
        onSaved: (str) {
          password = str;
        });
  }

  _prefixIcon(IconData iconData) {
    return Container(
        padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
        margin: const EdgeInsets.only(right: 8.0),
        decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
                bottomRight: Radius.circular(10.0))),
        child: Icon(
          iconData,
          size: 20,
          color: Colors.grey,
        ));
  }

  /*_linkForgotPassword() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      new Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FlatButton(
                child: new Text('Forgot password?',
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold)),
                onPressed: () {

                }
            )
          ]
      )
    ]);
  }*/

  _sendToServer(BuildContext context) {
    if (_key.currentState.validate()) {
      context.read<AuthenticationProvider>().signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(), context: context);

    } else {
      setState(() {

        _validate = true;
      });
    }
  }

  _linkSignIn(BuildContext context) =>
      Padding(
        padding: EdgeInsets.all(4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text('Already have an account?',
                style: TextStyle(color: Colors.grey)),
            new FlatButton(
              child: new Text('Sign In',
                  style: TextStyle(
                      color: Colors.black87,
                      //decoration: TextDecoration.underline,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.pop(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginPage()));
              },
            ),
          ],
        ),
      );

  _socialSignIn(double width, double height) {
    return Container(
        child: Column(children: <Widget>[
          SizedBox(height: height * 0.03),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Container(
              decoration: BoxDecoration(
                gradient: new LinearGradient(
                    colors: [
                      Colors.grey,
                      Colors.black12,
                    ],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 1.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
              width: 100.0,
              height: 1.0,
            ),
            Padding(
                padding: EdgeInsets.only(left: 15.0, right: 15.0),
                child: Text(
                  "OR",
                  style: TextStyle(
                      color: Colors.amber,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                )),
            Container(
              decoration: BoxDecoration(
                gradient: new LinearGradient(
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 1.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
                color: Colors.grey,
              ),
              width: 100.0,
              height: 1.0,
            ),
          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: height * 0.11),
              Container(
                margin: EdgeInsets.all(0.0),
                child: new RaisedButton(
                    color: Colors.white,
                    padding: const EdgeInsets.all(12.0),
                    highlightElevation: 0.0,
                    onPressed: () {},
                    splashColor: Colors.grey.withOpacity(0.2),
                    highlightColor: Colors.white,
                    shape: CircleBorder(
                      side: BorderSide(color: Colors.white, width: 1),
                    ),
                    child: Icon(
                      FontAwesomeIcons.google,
                      size: 20,
                      color: Colors.red,
                    )),
              ),
            ],
          )
        ]));
  }

  String validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.isEmpty) {
      return 'Email is required';
    } else if (!regExp.hasMatch(value)) {
      return 'Invalid email';
    } else {
      return null;
    }
  }

  String validatePassword(String value) {
    if (value.isEmpty) {
      return 'Password is required';
    } else if (value.length < 4) {
      return 'Password must be at least 4 characters';
    }
    return null;
  }
}



/*
import 'package:flutter/gestures.dart';
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

  //handling form validation and keyboard actions
  final _formKey = GlobalKey<FormState>();
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    //Handling sig nup and sign in; means of toggling obscuring password text
    bool signUp = true;
    bool _obscure = true;

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
                      signUp ? 'Sign up' : 'Sign in',
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

                RichText(
                  text: TextSpan(
                    text: signUp
                        ? 'Have an account? '
                        : 'Don\'t have an account? ',
                    style: TextStyle(color: Colors.black, fontSize: 14),
                    children: [
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => print("i work"),
                        text: signUp ? 'Sign in' : 'Register',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ],
                  ),
                )

                */
/*TextButton(

signUp = !signUp
                  child: Text.rich(

                    TextSpan(
                      text: signUp
                          ? 'Have an account? '
                          : 'Don\'t have an account? ',
                      style: TextStyle(color: Colors.black, fontSize: 14),
                      children: [
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => signUp = !signUp,
                          text: signUp ? 'Sign in' : 'Register',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),*//*

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

                    RichText(
                      text: TextSpan(
                        text: signUp
                            ? 'Have an account? '
                            : 'Don\'t have an account? ',
                        style: TextStyle(color: Colors.black, fontSize: 14),
                        children: [
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => print("i work"),
                            text: signUp ? 'Sign in' : 'Register',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ],
                      ),
                    )


                    */
/*TextButton(
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
                    ),*//*

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
*/
