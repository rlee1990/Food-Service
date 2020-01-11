import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SignUp extends StatefulWidget {
  SignUp({Key key}) : super(key: key);

  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with SingleTickerProviderStateMixin {
  String _email;
  String _password;
  String _password2;
  String _firstName;
  String _lastName;
  FocusNode _emailNode = FocusNode();
  FocusNode _passwordNode = FocusNode();
  FocusNode _password2Node = FocusNode();
  File _image;
  final formKey = GlobalKey<FormState>();
  bool _showProgress = false;
  bool _showPassword = true;
  bool _showPassword2 = true;
  TextEditingController _passwordController = new TextEditingController();
  AnimationController _animationController;
  Animation<double> _animation;

  _changeFocusNode(
      BuildContext context, FocusNode currentNode, FocusNode nextNode) {
    currentNode.unfocus();
    FocusScope.of(context).requestFocus(nextNode);
  }

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut);
    startAnimation();
    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailNode.dispose();
    _passwordNode.dispose();
    _password2Node.dispose();
    super.dispose();
  }

  void _onSubmit() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      setState(() {
        _showProgress = true;
      });
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: _email, password: _password)
          .then((user) => {Navigator.of(context).pop()})
          .catchError((error, stackTrack) => {
                setState(() {
                  _showProgress = false;
                }),
                print(error.message)
              });
    }
  }

  String _validateEmail(String value) {
    if (value.isEmpty) {
      // The form is empty
      return "Enter email address";
    }
    // This is just a regular expression for email addresses
    String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
        "\\@" +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
        "(" +
        "\\." +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
        ")+";
    RegExp regExp = new RegExp(p);

    if (regExp.hasMatch(value)) {
      // So, the email is valid
      return null;
    }

    // The pattern of the email didn't match the regex above.
    return 'Email is not valid';
  }

  startAnimation() {
    _animation.addListener(() => this.setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: !_showProgress
            ? SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                  height: 30.0,
                ),
                Container(
                  height: _animationController.value * 250,
                  width: _animationController.value * 250,
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        'assets/images/jelly.png',
                      ),
                      Text("R&R Catering",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Color(0xffff2020),
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                    )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                      Form(
                        key: formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 20.0),
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                icon: Icon(Icons.email),
                                hintText: 'email@email.com',
                                labelText: 'Email',
                              ),
                              focusNode: _emailNode,
                              validator: (input) => _validateEmail(input),
                              onSaved: (input) => _email = input,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (term) {
                                _changeFocusNode(
                                    context, _emailNode, _passwordNode);
                              },
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Padding(
                                  padding: const EdgeInsets.only(right: 4.0),
                                  child: TextFormField(
                                    focusNode: _passwordNode,
                                    keyboardType: TextInputType.text,
                                    obscureText: _showPassword,
                                    controller: _passwordController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      icon: Icon(Icons.lock),
                                      hintText: '••••••',
                                      labelText: 'Password',
                                      suffixIcon: IconButton(
                                        icon: _showPassword
                                            ? Icon(Icons.visibility)
                                            : Icon(Icons.visibility_off),
                                        onPressed: () => setState(() {
                                          _showPassword = !_showPassword;
                                        }),
                                      ),
                                    ),
                                    validator: (input) => input.length < 6
                                        ? 'Password must be atleast 6 characters'
                                        : null,
                                    onSaved: (input) => _password = input,
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (term) {
                                      _changeFocusNode(context, _passwordNode,
                                          _password2Node);
                                    },
                                  ),
                                ),
                                SizedBox(
                              height: 20.0,
                            ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 4.0),
                                  child: TextFormField(
                                    focusNode: _password2Node,
                                    keyboardType: TextInputType.text,
                                    obscureText: _showPassword2,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      icon: Icon(Icons.lock),
                                      hintText: '••••••',
                                      labelText: 'Confirm Password',
                                      suffixIcon: IconButton(
                                        icon: _showPassword
                                            ? Icon(Icons.visibility)
                                            : Icon(Icons.visibility_off),
                                        onPressed: () => setState(() {
                                          _showPassword2 = !_showPassword2;
                                        }),
                                      ),
                                    ),
                                    validator: (input) => input.trim() !=
                                            _passwordController.text
                                        ? 'Password does not match'
                                        : null,
                                    onSaved: (input) => _password2 = input,
                                    textInputAction: TextInputAction.done,
                                    onFieldSubmitted: (term) {
                                      _passwordNode.unfocus();
                                    },
                                  ),
                                ),
                            SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              height: 40.0,
                            ),
                            Container(
                              height: 60.0,
                              width: 250.0,
                              child: RaisedButton(
                                color: Theme.of(context).primaryColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                onPressed: _onSubmit,
                                child: Text('Sign Up',
                                    style: TextStyle(
                                      fontSize: 25.0,
                                      color: Colors.white,
                                    )),
                              ),
                            ),
                            SizedBox(
                              height: 30.0,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: RichText(
                                text: TextSpan(
                                    text: 'Already have an account?',
                                    style: TextStyle(color: Colors.grey),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: ' Login',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor))
                                    ]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Center(
                child: Container(
                  height: 250,
                  width: 250,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    elevation: 20,
                    margin: EdgeInsets.all(16),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text('Loading...'),
                          SizedBox(
                            height: 10.0,
                          ),
                          CircularProgressIndicator()
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
