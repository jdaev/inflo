import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:inflo/landing.dart';
import 'package:inflo/login/intro_pages.dart';
import 'package:inflo/login/login_checker.dart';
import 'package:inflo/signup/signup_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

class LogIn extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _smsController = TextEditingController();

  String _message = '';
  String _verificationId;
  Widget bodyWidget;
  bool isLoggedIn;

  @override
  void initState() {
    isLoggedIn = false;
    bodyWidget = loadingScreen();

    SharedPreferences.getInstance().then((preferences) {
      if (preferences.getBool('introShown') == null ||
          preferences.getBool('introShown') == false) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => IntroPages()),
        );
      }
    });
    FirebaseAuth.instance.currentUser().then((user) {
      if (user != null) {
        print(' A user is logged in');
        LogInChecker().loginStatus(user.uid).then((onValue) {
          if (onValue != null) {
            print('User has registered');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => LandingPage(
                        userName: onValue.toString(),
                        uid: user.uid,
                      )),
            );
          } else {
            print('Sign up new user');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SignUpScreen()),
            );
          }
        });
      } else {
        setState(() {
          bodyWidget = loginBox();
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: bodyWidget,resizeToAvoidBottomInset: true,);
  }

  Widget loginBox() {
    return Builder(
        builder: (scaffoldContext) => Container(
            decoration: new BoxDecoration(//color: Color(0xFF2C6DFD)
                ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: SizedBox(
                      width: 256, child: Image.asset('assets/logo.png')),
                ),
                Stack(
                  children: <Widget>[
                    Card(
                      elevation: 8.0,
                      margin: EdgeInsets.fromLTRB(16, 16, 16, 16),
                      child: SizedBox(
                        //height: 200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: <Widget>[
                                  TextFormField(
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        icon: Icon(Icons.phone_android),
                                        labelText: 'Mobile Number'),
                                    keyboardType:
                                        TextInputType.numberWithOptions(),
                                    controller: _phoneNumberController,
                                    validator: (String value) {
                                      if (value.isEmpty) {
                                        return 'Phone number (+xx xxx-xxx-xxxx)';
                                      }
                                    },
                                  ),
                                  Divider(
                                    color: Colors.black,
                                    height: 2,
                                  )
                                ],
                              ),
                            ),
                            FlatButton(
                              child: Text('LOG IN',
                                  style: TextStyle(fontSize: 16)),
                              onPressed: () async {
                                // verifyPhone();
                                _verifyPhoneNumber(scaffoldContext);
                                smsCodeDialog(context);
                              },
                            ),
                            Divider(),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GoogleSignInButton(
                                      onPressed: () {
                                        _signInWithGoogle();
                                      },
                                      darkMode: false,
                                      text: 'Google',
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: FacebookSignInButton(
                                      onPressed: () {},
                                      text: 'Facebook',
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            )));
  }

  Widget loadingScreen() {
    return Container(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(width: 240, child: Image.asset('assets/logo.png')),
            SizedBox(
              height: 32,
            ),
            SizedBox(
                width: 240,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.white,
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
                )),
          ],
        ),
      ),
    );
  }

  void _verifyPhoneNumber(BuildContext scaffoldContext) async {
    setState(() {
      _message = '';
    });
    final PhoneVerificationCompleted verificationCompleted =
        (FirebaseUser user) {
      setState(() {
        _message = 'Automatically signed in with Google';
      });
      Scaffold.of(scaffoldContext).showSnackBar(SnackBar(
        content: Text(_message),
      ));
      setState(() {
        if (user != null) {
          _message = 'Successfully signed in, uid: ' + user.uid;
          LogInChecker().loginStatus(user.uid).then((onValue) {
            if (onValue != null) {
              print('true');
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => LandingPage(
                          userName: onValue.toString(),
                          uid: user.uid,
                        )),
              );
            } else {
              print('signup');
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SignUpScreen()),
              );
            }
          });
        } else {
          _message = 'Sign in failed';
        }
      });
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      setState(() {
        _message =
            'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}';
      });
      Scaffold.of(scaffoldContext).showSnackBar(SnackBar(
        content: Text(_message),
      ));
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      Scaffold.of(scaffoldContext).showSnackBar(SnackBar(
        content:
            const Text('Please check your phone for the verification code.'),
      ));
      _verificationId = verificationId;
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
    };

    await _auth.verifyPhoneNumber(
        phoneNumber: '+91' + _phoneNumberController.text,
        timeout: const Duration(seconds: 0),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  void _signInWithPhoneNumber() async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: _verificationId,
      smsCode: _smsController.text,
    );
    final FirebaseUser user = await _auth.signInWithCredential(credential);
    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    setState(() {
      if (user != null) {
        _message = 'Successfully signed in, uid: ' + user.uid;
        LogInChecker().loginStatus(user.uid).then((onValue) {
          if (onValue != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => LandingPage(
                        userName: onValue,
                        uid: user.uid,
                      )),
            );
          } else {
            print('signup');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SignUpScreen()),
            );
          }
        });
      } else {
        _message = 'Sign in failed';
      }
    });
  }

  Future<bool> smsCodeDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Enter Verification Code:'),
            content: TextFormField(
              controller: _smsController,
            ),
            contentPadding: EdgeInsets.all(10.0),
            actions: <Widget>[
              new FlatButton(
                child: Text('Done'),
                onPressed: () {
                  // Sign in
                  _signInWithPhoneNumber();
                },
              )
            ],
          );
        });
  }

  void _signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final FirebaseUser user = await _auth.signInWithCredential(credential);
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    setState(() {
      if (user != null) {
        _message = 'Successfully signed in, uid: ' + user.uid;
        LogInChecker().loginStatus(user.uid).then((onValue) {
          if (onValue != null) {
            print('true');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => LandingPage(
                        userName: onValue.toString(),
                        uid: user.uid,
                      )),
            );
          } else {
            print('signup');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SignUpScreen()),
            );
          }
        });
      } else {
        _message = 'Sign in failed';
      }
    });
  }

  void _signInWithFacebook() async {
    final AuthCredential credential = FacebookAuthProvider.getCredential(
        //accessToken: _tokenController.text,
        );
    final FirebaseUser user = await _auth.signInWithCredential(credential);
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    setState(() {
      if (user != null) {
        _message = 'Successfully signed in with Facebook. ' + user.uid;
      } else {
        _message = 'Failed to sign in with Facebook. ';
      }
    });
  }
}
