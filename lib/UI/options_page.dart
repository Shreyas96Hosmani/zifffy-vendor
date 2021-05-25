import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendor_dabbawala/UI/Shreyas/my_items.dart';
import 'package:vendor_dabbawala/UI/data/login_data.dart';
import 'package:vendor_dabbawala/UI/login_page.dart';
import 'package:vendor_dabbawala/UI/report_and_details_page.dart';
import 'package:vendor_dabbawala/UI/view_my_order_numbers.dart';
import 'package:vendor_dabbawala/api/addnewitem.dart';
import 'additem_manageitem_page.dart';
import 'order_summary_page.dart';
import 'package:vendor_dabbawala/UI/data/globals_data.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert';

ProgressDialog prLogOut;

class OptionsPage extends StatefulWidget {
  @override
  _OptionsPageState createState() => _OptionsPageState();
}

class _OptionsPageState extends State<OptionsPage> {

  AddNewItemApiProvider addNewItemApiProvider = AddNewItemApiProvider();

  Future<String> deleteFcmToken(context) async {

    String url = globals.apiUrl + "deletefcmtoken.php";

    http.post(url, body: {

      "vendorID" : storedUserId.toString(),

    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");

      }

      var responseArrayDeleteFcmToken = jsonDecode(response.body);
      print(responseArrayDeleteFcmToken);

      var responseArrayDeleteFcmTokenMsg = responseArrayDeleteFcmToken['message'].toString();
      print(responseArrayDeleteFcmTokenMsg);

      if(responseArrayDeleteFcmTokenMsg == "Successfully"){
        prLogOut.hide();
        Fluttertoast.showToast(msg: "Logged out", backgroundColor: Colors.black, textColor: Colors.white);
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (c, a1, a2) => LoginPage(),
              transitionsBuilder: (c, anim, a2, child) =>
                  FadeTransition(opacity: anim, child: child),
              transitionDuration: Duration(milliseconds: 300),
            )
        );
        clearUser();
      }else{
        prLogOut.hide();
        Fluttertoast.showToast(msg: 'Please check your network connection!',backgroundColor: Colors.black, textColor: Colors.white);
      }

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    prLogOut = ProgressDialog(context);
    return WillPopScope(
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
              )

          ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            IconButton(icon: Icon(Icons.exit_to_app, color: Colors.grey,), onPressed: (){
              showAlertDialogLogout(context);
            })
          ],
        ),
        backgroundColor: Colors.white,
        body: Center(child: buildOptionsContainer(context)),
      ),
    );
  }

  Widget buildOptionsContainer(BuildContext context){
    return Container(
      width: MediaQuery.of(context).size.width/1.1,
      height: MediaQuery.of(context).size.height/1.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        border: Border.all(color: Colors.blueAccent[100]),
        boxShadow: [BoxShadow(
          color: Colors.blue[200],
          blurRadius: 10
        )],
        color: Colors.white
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildDabbawalaText(context),
          buildAddNewItemAndManageMenu(context),
          buildOrdersAndOrderSummary(context),
          buildReportAndDetails(context)
        ],
      ),
    );
  }

  Widget buildDabbawalaText(BuildContext context){
    return Container(
      width: MediaQuery.of(context).size.width/1,
      height: MediaQuery.of(context).size.height/15,
      child: Center(
        child: Text('Vendor Home',textScaleFactor: 1,
          textAlign: TextAlign.center,
          style: GoogleFonts.nunito(
          fontWeight: FontWeight.w400,
          fontSize: 20,
          color: Colors.black
        ),),
      ),
    );
  }

  Widget buildAddNewItemAndManageMenu(BuildContext context){
    return GestureDetector(
      onTap: (){
        // addNewItemApiProvider.getCuisineId(context);
        Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (c, a1, a2) =>MyItems(),
              transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
              transitionDuration: Duration(milliseconds: 300),
            )
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width/1.2,
        height: MediaQuery.of(context).size.height/15,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: Colors.blue[700],
          boxShadow: [BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 10,
          )],
        ),
        child: Center(
          child: Text('Add New Item And Manage Menu',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),),
        ),
      ),
    );
  }

  Widget buildOrdersAndOrderSummary(BuildContext context){
    return GestureDetector(
      onTap: (){
        Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (c, a1, a2) =>ViewMyOrderNumbers(),
              transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
              transitionDuration: Duration(milliseconds: 300),
            )
        );

      },
      child: Container(
        width: MediaQuery.of(context).size.width/1.2,
        height: MediaQuery.of(context).size.height/15,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: Colors.blue[700],
            boxShadow: [BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 10,
            )]
        ),
        child: Center(
          child: Text('Orders And Order Summary',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w400,
          ),),
        ),
      ),
    );
  }

  Widget buildReportAndDetails(BuildContext context){
    return GestureDetector(
      onTap: (){
        Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (c, a1, a2) =>ReportAndDetailsPage(),
              transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
              transitionDuration: Duration(milliseconds: 300),
            )
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width/1.2,
        height: MediaQuery.of(context).size.height/15,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: Colors.blue[700],
            boxShadow: [BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 10,
            )]
        ),
        child: Center(
          child: Text('Report And Details',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w400,
          ),),
        ),
      ),
    );
  }

  clearUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  showAlertDialogLogout(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text('Yes'),
      onPressed: () {
        prLogOut.show();
        deleteFcmToken(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text('No'),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog ask = AlertDialog(
      title: Text('Sign Out'),
      content: Text('Are you sure?'),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ask;
      },
    );
  }

}
