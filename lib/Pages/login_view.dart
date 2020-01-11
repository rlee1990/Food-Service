import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;
  String _email;
  String _password;
  FocusNode _emailNode = FocusNode();
  FocusNode _passwordNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  bool _showPassword = true;

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
    super.dispose();
  }

  _changeFocusNode(
      BuildContext context, FocusNode currentNode, FocusNode nextNode) {
    currentNode.unfocus();
    FocusScope.of(context).requestFocus(nextNode);
  }

  startAnimation() {
    _animation.addListener(() => this.setState(() {}));
  }

  void _onSubmit() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _password)
          .then((user) => {})
          .catchError((error) => {print(error.message)});
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 50.0,
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
                          _changeFocusNode(context, _emailNode, _passwordNode);
                        },
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        focusNode: _passwordNode,
                        keyboardType: TextInputType.text,
                        obscureText: _showPassword,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
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
                        textInputAction: TextInputAction.go,
                        onEditingComplete: () {
                          _passwordNode.unfocus();
                          _onSubmit();
                        },
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          InkWell(
                              onTap: () => {}, child: Text('Forgot Password')),
                        ],
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
                          child: Text('LOGIN',
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
                          Navigator.of(context).pushNamed('/signup');
                        },
                        child: RichText(
                          text: TextSpan(
                              text: 'Don\'t have an account?',
                              style: TextStyle(color: Colors.grey),
                              children: <TextSpan>[
                                TextSpan(
                                    text: ' SIGNUP',
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor))
                              ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
