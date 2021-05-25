import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:vendor_dabbawala/api/login.dart';
// import 'package:vendor_app/api/login.dart';
import 'data/login_data.dart' as login;


class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {

  LoginApiProvider loginApiProvider = LoginApiProvider();

  @override
  Widget build(BuildContext context) {
    login.prForgotPassword = ProgressDialog(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Form(
          key: login.formKeys,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
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
    );
  }

  Widget buildLoginBox(BuildContext context){
    return Center(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 20,),
            buildDabbawalaText(context),
            SizedBox(height: 20,),
            buildEmailText(context),
            buildEmailField(context),
            SizedBox(height: 40,),
            buildLoginButton(context),
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
        child: Text('Zifffy',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
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
        child: Text('Email',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
            fontSize: 16,
            color: Colors.blue[900]
        ),),
      ),
    );
  }

  Widget buildEmailField(BuildContext context){
    return  Container(
        height: MediaQuery.of(context).size.height/10,
        padding: EdgeInsets.only(left: 20, right: 20),
        child: TextFormField(
          controller: login.emailControllerTwo,
          style: TextStyle(color: Colors.black),
          cursorColor: Colors.black,
          autofocus: false,
          decoration: InputDecoration(
              hintText: 'Enter Email',
              prefixIcon: Icon(Icons.email,color: Colors.grey,),),
          validator: (val) =>
          !EmailValidator.validate(val, true)
              ? 'Please Enter email'
              : null,

        ));
  }

  Widget buildLoginButton(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 20,right: 20),
      child: GestureDetector(
        onTap: () {
          if (login.formKeys.currentState.validate()) {
            login.prlogin.show();
            loginApiProvider.forgotPassword(context);
          }
        },
        child: Container(
          height: 40,
          width: MediaQuery.of(context).size.width/2,
          decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.all(Radius.circular(5)),
              boxShadow: [BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 3,
              )]
          ),
          padding: EdgeInsets.only(left: 20,right: 20),
          child: Center(
            child: Text("Continue",textScaleFactor: 1,
                style: GoogleFonts.nunitoSans(
                  textStyle: TextStyle(color: Colors.white,
                      fontSize: 18,
                  ),
                )),
          ),),
      ),
    );
  }
}
