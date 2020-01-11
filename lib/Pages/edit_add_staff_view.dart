import 'package:flutter/material.dart';
import 'package:food_dev/Models/staffs.dart';
import 'package:provider/provider.dart';

class EditStaffView extends StatefulWidget {
  const EditStaffView({Key key}) : super(key: key);

  @override
  _EditStaffViewState createState() => _EditStaffViewState();
}

class _EditStaffViewState extends State<EditStaffView> {
  FocusNode _firstNameNode = FocusNode();
  FocusNode _lastNameNode = FocusNode();
  FocusNode _emailNode = FocusNode();
  FocusNode _passwordNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  bool _isInit = true;
  bool _isAdmin = false;
  bool _isStaff = false;
  bool _isLoading = false;
  String _email;
  String _password;
  String _firstName;
  String _lastName;
  bool _showPassword = true;
  var _initValues = {
    'firstName': '',
    'lastName': '',
    'admin': '',
    'email': '',
    'uid': ''
  };

  void _onSubmit() {
    if (formKey.currentState.validate()) {
      setState(() {
       _isLoading = true; 
      });
      formKey.currentState.save();
      Provider.of<Staffs>(context, listen: false).createUser(_firstName, _lastName, _email, _password).then((_) {
        Provider.of<Staffs>(context, listen: false).addAccess(_email, _isAdmin, _isStaff).then((_) {
          setState(() {
       _isLoading = false; 
      });
          Navigator.of(context).pop();
        });
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

  @override
  void dispose() {
    _firstNameNode.dispose();
    _lastNameNode.dispose();
    _passwordNode.dispose();
    _emailNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final uid = ModalRoute.of(context).settings.arguments as String;
      if (uid != null) {
        // _foodItem =
        //     Provider.of<FoodItems>(context, listen: false).findById(itemId);
        _initValues = {
          'firstName': '',
          'lastName': '',
          'admin': '',
          'email': '',
          'uid': ''
        };
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Staff'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {_onSubmit();},
          )
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              icon: Icon(Icons.person),
                              hintText: 'First Name',
                              labelText: 'First Name',
                            ),
                            focusNode: _firstNameNode,
                            validator: (input) => input.isEmpty
                                ? 'Please enter a First Name'
                                : null,
                            onSaved: (input) => _firstName = input,
                            textInputAction: TextInputAction.next,
                            textCapitalization: TextCapitalization.words,
                            onFieldSubmitted: (term) {},
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              icon: Icon(Icons.person),
                              hintText: 'Last Name',
                              labelText: 'Last Name',
                            ),
                            focusNode: _lastNameNode,
                            validator: (input) => input.isEmpty
                                ? 'Please enter a Last Name'
                                : null,
                            onSaved: (input) => _lastName = input,
                            textInputAction: TextInputAction.next,
                            textCapitalization: TextCapitalization.words,
                            onFieldSubmitted: (term) {},
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      icon: Icon(Icons.email),
                      hintText: 'email@email.com',
                      labelText: 'Email',
                    ),
                    focusNode: _emailNode,
                    validator: (input) => _validateEmail(input),
                    onSaved: (input) => _email = input,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (term) {},
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
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (term) {},
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'Access Level',
                    style: Theme.of(context).textTheme.title,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: CheckboxListTile(
                          title: Text('Admin'),
                          value: _isAdmin,
                          onChanged: (value) {
                            setState(() {
                              _isAdmin = value;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: CheckboxListTile(
                          title: Text('Staff'),
                          value: _isStaff,
                          onChanged: (value) {
                            setState(() {
                              _isStaff = value;
                            });
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
