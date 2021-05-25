import 'dart:io';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendor_dabbawala/api/login.dart';
import 'data/login_data.dart' as login;
import 'forgot_password_page.dart';
import 'options_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginApiProvider loginApiProvider = LoginApiProvider();
  Future<void> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      login.storedUserId = prefs.getString('userId');
    });
    print(login.storedUserId);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    login.storedUserId = ".";
    Future.delayed(Duration(seconds: 2), () async {
      isLoggedIn();
    });
  }
  @override
  Widget build(BuildContext context) {
    login.prlogin = ProgressDialog(context);
    return login.storedUserId == "." ? Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: CircularProgressIndicator(),),
    ) : login.storedUserId == null || login.storedUserId == "null" ? WillPopScope(
      onWillPop: ()=>
          showDialog(
              context: context,
              builder: (context) =>
              new AlertDialog(
                title: new Text('Are you sure?'),
                content: new Text('Do you want to exit the App'),
                actions: <Widget>[
                  new GestureDetector(
                    onTap: () => exit(0),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text('Yes'),
                    ),
                  ),
                  SizedBox(height: 16,),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(false),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text('No'),
                    ),
                  ),
                ],
              ),
          ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Center(
            child: Form(
              key: login.formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    buildLoginBox(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ) : OptionsPage();
  }

  Widget buildLoginBox(BuildContext context){
    return Center(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20,),
            buildDabbawalaText(context),
            SizedBox(height: 20,),
            buildEmailText(context),
            buildEmailField(context),
            SizedBox(height: 20,),
            buildPasswordText(context),
            buildPasswordField(context),
            SizedBox(height: 40,),
            buildContinueButton(context),
            SizedBox(height:20,),
            buildForgetPassword(context),
          ],
        ),
      ),
    );
  }

  Widget buildDabbawalaText(BuildContext context){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height/23,
      color: Colors.white,
      child: Center(
        child: Text('Zifffy - Vendor Login',
          textScaleFactor: 1,
          style: GoogleFonts.nunitoSans(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: Colors.black,
        ),),
      ),
    );
  }

  Widget buildEmailText(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height/23,
        color: Colors.white,
        child: Text('Email',
          textScaleFactor: 1,
          style: GoogleFonts.nunitoSans(
            fontSize: 16,
            color: Colors.blue[900]
        ),),
      ),
    );
  }

  Widget buildEmailField(BuildContext context){
    return  Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: TextFormField(
          controller: login.emailController,
          style: TextStyle(color: Colors.black),
          cursorColor: Colors.black,
          autofocus: false,
          decoration: InputDecoration(
              hintText: 'Enter Email',
              prefixIcon: Icon(Icons.email,color: Colors.grey,),),
          validator: (val) =>
          !EmailValidator.validate(val, true)
              ? 'Please Enter Email'
              : null,

        ));
  }

  Widget buildPasswordText(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height/23,
        color: Colors.white,
        child: Text('Password',
          textScaleFactor: 1,
          style: GoogleFonts.nunitoSans(
            fontSize: 16,
            color: Colors.blue[900]
        ),),
      ),
    );
  }

  Widget buildPasswordField(BuildContext context){
    return Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: TextFormField(
          controller: login.passwordController,
          style: TextStyle(color: Colors.black),
          obscureText: login.obscureText,
          cursorColor: Colors.black,
          autofocus: false,
          decoration: InputDecoration(
              hintText: 'Enter Password',
              prefixIcon: Icon(Icons.lock_outline, color: Colors.grey,),
              suffixIcon: login.obscureText == true ? GestureDetector(
                  onTap: (){
                    setState(() {
                      login.obscureText=false;
                    });
                  },
                  child: Icon(Icons.visibility,color: Colors.grey,)) : GestureDetector(
                  onTap: (){
                    setState(() {
                      login.obscureText=true;
                    });
                  },
                  child: Icon(Icons.visibility,color: Colors.grey,)),),
          validator: (value) {
            if (value.length == 0) {
              return 'Please Enter Password';
            } else if (value.length < 6) {
            }
            return null;
          },
        ));
  }

  Widget buildContinueButton(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 20,right: 20),
      child: GestureDetector(
        onTap: () {
          if (login.formKey.currentState.validate()) {
           login.prlogin.show();
           loginApiProvider.signIn(context);
          }
        },
        child: Container(
            height: 40,
            width: MediaQuery.of(context).size.width/2,
            decoration: BoxDecoration(
              color: Colors.blue[700],
              borderRadius: BorderRadius.all(Radius.circular(5)),
              boxShadow: [BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 10
              )]
            ),
            padding: EdgeInsets.only(left: 20,right: 20),
            child: Center(
              child: Text("Login",
                  textScaleFactor: 1,
                  style: GoogleFonts.nunitoSans(
                    textStyle: TextStyle(color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                    ),
                  )),
            ),),
      ),
    );
  }

  Widget buildForgetPassword(BuildContext context){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height/23,
      color: Colors.white,
      child: GestureDetector(
        onTap: (){
          Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (c, a1, a2) => ForgotPasswordPage(),
                transitionsBuilder: (c, anim, a2, child) =>
                    FadeTransition(opacity: anim, child: child),
                transitionDuration: Duration(milliseconds: 300),
              )
          );
        },
        child: Center(
          child: Text('Forgot Password',
            textScaleFactor: 1,
            style: GoogleFonts.nunitoSans(
              fontSize: 14,
              color: Colors.blue,
          ),),
        ),
      ),
    );
  }
  // Widget buildPD(BuildContext context){
  //   login.prlogin = new ProgressDialog(context);
  //   login.prlogin.style(
  //
  //   );
  // }
}