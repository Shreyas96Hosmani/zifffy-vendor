import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendor_dabbawala/UI/data/globals_data.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:vendor_dabbawala/UI/data/login_data.dart' as login;
import 'package:vendor_dabbawala/UI/options_page.dart';
import 'package:vendor_dabbawala/main.dart';

class LoginApiProvider {

  Future<String> signIn(context) async {

    print(login.emailController.text.toString());
    print(login.passwordController.text.toString());

    String url = globals.apiUrl + "login.php";

    http.post(url, body: {

      "email": login.emailController.text.toString(),
      "password" : login.passwordController.text.toString(),
      "fcmtoken" : userToken.toString(),

    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");

      }
      login.responseArrayLogin = jsonDecode(response.body);
      print(login.responseArrayLogin);
      login.loginResponse = login.responseArrayLogin['status'].toString();
      login.loginMessage = login.responseArrayLogin['message'].toString();
      if(statusCode == 200){
        if(login.loginMessage == "Login Successfull"){
          login.prlogin.hide().whenComplete(() async {
            Fluttertoast.showToast(msg: login.loginSuccess, backgroundColor: Colors.black, textColor: Colors.white);
            clearFields(context);

            login.storedUserId = login.responseArrayLogin['data']['vendorID'].toString();
            print(login.storedUserId);

            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('userId',login.storedUserId);


            Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (c, a1, a2) =>OptionsPage(),
                  transitionsBuilder: (c, anim, a2, child) =>
                      FadeTransition(opacity: anim, child: child),
                  transitionDuration: Duration(milliseconds: 300),
                )
            );
            login.userIDResponse = login.responseArrayLogin['data']['vendorID'];
            print(login.userIDResponse);
          });
        }else{

          login.prlogin.hide().whenComplete((){
            Fluttertoast.showToast(msg: login.loginMessage, backgroundColor: Colors.black, textColor: Colors.white);
          });

        }
      }

    });
    SharedPreferences prefs = await SharedPreferences.getInstance();

  }

  Future<String> forgotPassword(context) async {

    String url = globals.apiUrl + "forgotpassword.php";

    http.post(url, body: {

      "vendorresetemail": login.emailControllerTwo.text,

    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");

      }
      login.responseArrayForgotPassword = jsonDecode(response.body);
      print(login.responseArrayForgotPassword);
      login.forgotPasswordResponse = login.responseArrayForgotPassword['status'].toString();
      login.forgotPasswordMessage = login.responseArrayForgotPassword['message'].toString();
      if(statusCode == 200){
        if(login.forgotPasswordMessage == "Successfully"){
          login.prForgotPassword.hide().whenComplete((){
            Fluttertoast.showToast(msg: login.emailSent
            );
            clearEmail(context);
            Navigator.of(context).pop();


          });
        }else{
          if(login.forgotPasswordMessage == "User does not exist with this email"){
            login.prlogin.hide().whenComplete((){
              print('Hello');
              Fluttertoast.showToast(msg: login.invalidUser,);
            });
          }
          else if(login.forgotPasswordMessage == 'Unable to add reset data'){
            login.prlogin.hide().whenComplete((){
              print('Hello');
              Fluttertoast.showToast(msg: login.invalidPassword,);
            });
          }
        }
      }

    });
    SharedPreferences prefs = await SharedPreferences.getInstance();

  }





  void clearFields(BuildContext context){
    login.emailController.clear();
    login.passwordController.clear();

  }

  void clearEmail(BuildContext context){
    login.emailControllerTwo.clear();
  }

}