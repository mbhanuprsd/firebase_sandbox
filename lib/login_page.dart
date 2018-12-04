import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = new GlobalKey<FormState>();

  String _email;
  String _password;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Login'),
      ),
      body: new Container(
        padding: EdgeInsets.all(20.0),
        child: new Form(
          key: formKey,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              new TextFormField(
                decoration: new InputDecoration(labelText: 'Email'),
                validator: (value) =>
                    value.isEmpty ? 'Please enter email' : null,
                onSaved: (value) => _email = value,
              ),
              new TextFormField(
                decoration: new InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) =>
                    value.isEmpty ? 'Please enter password' : null,
                onSaved: (value) => _password = value,
              ),
              new RaisedButton(
                child: new Text(
                  'Login',
                  style: TextStyle(fontSize: 20.0),
                ),
                onPressed: validateAndSave,
              ),
              new RaisedButton(
                  child: const Text('Sign In with Google'),
                  onPressed: () => signInWithGoogle()
                      .then((user) => print(user))
                      .catchError((e) => print(e)),
                  color: Colors.green,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void validateAndSave() {
    final loginForm = formKey.currentState;
    loginForm.save();
    if (loginForm.validate()) {
      print('Valid Form. Email: $_email, Password: $_password');
      _auth.signInWithEmailAndPassword(email: _email, password: _password);
    } else {
      print('Invalid Form');
    }
  }

  Future<FirebaseUser> signInWithGoogle() async {
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication gSA = await googleSignInAccount.authentication;

    FirebaseUser user = await _auth.signInWithGoogle(idToken: gSA.idToken,
        accessToken: gSA.accessToken);
    print("Login succesful : " + user.email);
    return user;
  }
}
