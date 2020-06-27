import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/reusable_buttons.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Model.dart';
import 'chat_screen.dart';
import 'package:flash_chat/constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'loginScreen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String email;
  String password;
  String passHint = 'Enter your password';
  String emailHint = 'Enter your email';
  TextEditingController emailControl = TextEditingController();
  TextEditingController passControl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.04),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height:  MediaQuery.of(context).size.width*0.4,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height*0.06,
              ),
              TextField(
                controller: emailControl,
                  onTap: () => setState(() {
                        passHint = 'Enter your password';
                        emailHint = '';
                      }),
                  keyboardType: TextInputType.emailAddress,
                  style: new TextStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration:
                      kTextFieldDecoration.copyWith(hintText: emailHint,contentPadding:
                      EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height*0.01,),)),
              SizedBox(
                height: MediaQuery.of(context).size.height*0.03,
              ),
              TextField(
                controller: passControl,
                  onTap: () => setState(() {
                        passHint = '';
                        emailHint = 'Enter your email';
                      }),
                  obscureText: true,
                  textAlign: TextAlign.center,
                  style: new TextStyle(color: Colors.black),
                  onChanged: (value) {
                    password = value;
                  },
                  decoration:
                  kTextFieldDecoration.copyWith(hintText: passHint,contentPadding:
                  EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height*0.01,),)),
              SizedBox(
                height: MediaQuery.of(context).size.height*0.03,
              ),
              reusableButtons(
                colour: Colors.lightBlueAccent,
                txt: 'Log In',
                onPressed: () async {
                  if (email == null || password == null || emailControl.text.isEmpty || passControl.text.isEmpty) {
                    Alert(
                      context: context,
                      type: AlertType.error,
                      title: "Error",
                      desc: "Email or Password cannot be empty",
                      buttons: [
                        DialogButton(
                          child: Text(
                            "Try Again",
                            style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.width*0.04),
                          ),
                          onPressed: (){
                            emailControl.text = '';
                            passControl.text = '';
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ).show();
                    return;
                  }

                  setState(() {
                    showSpinner = true;
                  });

                  try {
                    final user = await _auth.signInWithEmailAndPassword(
                        email: email, password: password);
                    if (user != null) {
                      emailControl.clear();
                      passControl.clear();
                    }
                    SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                    prefs.setString('email', email);
                    Email.email = email;
                    setState(() {
                      showSpinner = false;
                    });
                    Navigator.pushNamed(context, ChatScreen.id);
                  } catch (e) {
                    print(e);
                    String err = e.toString();
                    List<String> errList = err.split(',');
                    print(errList);
                    Alert(
                      context: context,
                      type: AlertType.error,
                      title: "ERROR",
                      desc: errList[1],
                      buttons: [
                        DialogButton(
                          child: Text(
                            "Try Again",
                            style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.width*0.04),
                          ),
                          onPressed: () {
                            emailControl.text = '';
                            passControl.text = '';
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ).show();
                    setState(() {
                      showSpinner = false;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
