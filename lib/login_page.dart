import 'package:firebase_sandbox/home_page.dart';
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

  void signOut() {
    googleSignIn.signOut();
    googleSignIn.disconnect();
    Navigator.pop(context);
    print("User Signed Out");
  }

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
                onPressed: () => validateAndSave()
                    .then((user) => navigateToHome())
                    .catchError((e) => print(e)),
                color: Colors.blue,
              ),
              new RaisedButton(
                child: new Text(
                  'Sign In with Google',
                  style: TextStyle(fontSize: 20.0),
                ),
                onPressed: () => signInWithGoogle()
                    .then((user) => navigateToHome())
                    .catchError((e) => print(e)),
                color: Colors.green,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<FirebaseUser> validateAndSave() async {
    final loginForm = formKey.currentState;
    loginForm.save();
    if (loginForm.validate()) {
      print('Valid Form. Email: $_email, Password: $_password');
      FirebaseUser user = await _auth.signInWithEmailAndPassword(
          email: _email, password: _password);
      return user;
    } else {
      throw new Exception("Inavlid form");
    }
  }

  Future<FirebaseUser> signInWithGoogle() async {
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication gSA = await googleSignInAccount.authentication;

    FirebaseUser user = await _auth.signInWithGoogle(
        idToken: gSA.idToken, accessToken: gSA.accessToken);
    print("Login succesful : " + user.email);
    return user;
  }

  void navigateToHome() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage(signOut)),
    );
  }
}
