library main_app.loginglobals;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';


String invalidPhoneNumber = 'Invalid Phone Number';
String phoneNumberCompulsory = 'Phone Number is Compulsory';
var invalidPassword = 'Incorrect Password';

bool obscureText = true;

final formKey = GlobalKey<FormState>();
final formKeys = GlobalKey<FormState>();

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
final GlobalKey<ScaffoldState> scaffoldKey1 = GlobalKey<ScaffoldState>();
final GlobalKey<ScaffoldState> scaffoldKeys = GlobalKey<ScaffoldState>();
final GlobalKey<ScaffoldState> scaffoldKeyy = GlobalKey<ScaffoldState>();
final GlobalKey<ScaffoldState> scaffoldKei = GlobalKey<ScaffoldState>();




var emailController = new TextEditingController();
var passwordController = new TextEditingController();

var responseArrayLogin;
var loginResponse;
var loginMessage;
var loginSuccess = 'Login Successfull';
var invalidUser = 'Invalid Email';
String userIDResponse;

var storedUserId;


var responseArrayForgotPassword;
var forgotPasswordResponse;
var forgotPasswordMessage;
var userIdResponse;
var emailControllerTwo = new TextEditingController();


ProgressDialog prForgotPassword;

ProgressDialog prlogin;
var emailSent = "Email Sent";

