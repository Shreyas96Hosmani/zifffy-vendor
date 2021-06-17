import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info/package_info.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vendor_dabbawala/UI/NotificationScreen.dart';
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
import 'data/login_data.dart' as login;

ProgressDialog prLogOut;

var ordNos;
var ordTot;

var storedTotalNotifications;
var totalNotificationCount2;
var displayNotificationCount;

class OptionsPage extends StatefulWidget {
  @override
  _OptionsPageState createState() => _OptionsPageState();
}

class _OptionsPageState extends State<OptionsPage> {

 bool _isloaded = false;
 String support_email, app_store_url, play_store_url;

  AddNewItemApiProvider addNewItemApiProvider = AddNewItemApiProvider();



  //GET app data
  Future CheckForUpdate() async {


    final PackageInfo info = await PackageInfo.fromPlatform();
    var response;

    try {
      response = await http.post(globals.apiUrl+"getappmasterdata.php", body: {});
      print("response" + response.body.toString());
      if (response.statusCode == 200) {

        var responseArray = jsonDecode(response.body);
        var responseArrayMsg =
        responseArray['message'].toString();
        if (responseArrayMsg == "Master Data Found") {

          double currentVersion =
          double.parse(info.version.trim().replaceAll(".", ""));
          print('currentVersion' + currentVersion.toString());

          String tempversion = Platform.isAndroid
              ? responseArray['data']['android_min_version']
              : responseArray['data']['ios_min_version'];

          double newVersion = double.parse(tempversion.trim().replaceAll(".", ""));

          print('newVersion' + newVersion.toString());
          if (newVersion > currentVersion) {


            setState(() {
              _isloaded = false;
            });

            _showVersionDialog(context, tempversion, responseArray['data']['support_email'], responseArray['data']['app_store_url'],
                responseArray['data']['play_store_url']);
          } else {

            setState(() {
              _isloaded = true;
            });
            storedTotalNotifications = null;
            totalNotificationCount2 = null;
            displayNotificationCount = null;
            getNotifications2();
            getOrderNumbers();


          }
        }

      } else {
        throw Exception("Unable to perform request!");
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }


  }


  Future<String> getNotifications2() async {

    String url = globals.apiUrl + "getcustomnotify.php";

    http.post(url, body: {

      "types" : login.userIDResponse.toString(),

    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");

      }
      var responseArrayGetCusines = jsonDecode(response.body);
      print(responseArrayGetCusines);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var responseArrayGetCusinesMsg = responseArrayGetCusines['message'].toString();
      print(responseArrayGetCusinesMsg);

      if(statusCode == 200){
        if(responseArrayGetCusinesMsg == "Found"){
          //prGetItems.hide();
          setState(() {
            notificationTitles = List.generate(responseArrayGetCusines['data'].length, (index) => responseArrayGetCusines['data'][index]['customnotificationTitle'].toString());
            notificationDescriptions = List.generate(responseArrayGetCusines['data'].length, (index) => responseArrayGetCusines['data'][index]['customnotificationMessage'].toString());
            notificationDateTimes = List.generate(responseArrayGetCusines['data'].length, (index) => responseArrayGetCusines['data'][index]['customnotificationDatetime'].toString());
            notificationLinks = List.generate(responseArrayGetCusines['data'].length, (index) => responseArrayGetCusines['data'][index]['customnotificationUrl'].toString());

            totalNotificationCount2 = notificationTitles.toList().length;

            storedTotalNotifications = prefs.getString('totalNotifications')??"0";

            print("nowwwwwwwww");
            print(totalNotificationCount2.toString());
            print(storedTotalNotifications.toString());

            if(int.parse(totalNotificationCount2.toString()) > int.parse(storedTotalNotifications.toString())){
              setState(() {
                displayNotificationCount = int.parse(totalNotificationCount2.toString()) - int.parse(storedTotalNotifications.toString());
              });
            }else{
              setState(() {
                displayNotificationCount = "0";
              });
            }

          });
          print(notificationTitles.toList());
          print(notificationDescriptions.toList());
          print(notificationDateTimes.toList());
          print(notificationLinks.toList());

          print("totallllll");
          print("stored :::::"+storedTotalNotifications.toString());
          print("displayNotificationCount ::::"+displayNotificationCount.toString());
          print("totallllll");

        }else{
          //prGetItems.hide();
          setState(() {
            notificationTitles = null;
          });

        }
      }
    });

  }

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

  Future<String> getOrderNumbers() async {

    String url = globals.apiUrl + "getordernumbersbyvendorid.php";

    http.post(url, body: {

      "vendorID": login.storedUserId.toString(),

    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");

      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var responseArrayGetOrderNumbers = jsonDecode(response.body);
      print(responseArrayGetOrderNumbers);

      var responseArrayGetOrderNumbersMsg = responseArrayGetOrderNumbers['message'].toString();
      print(responseArrayGetOrderNumbersMsg);

      if(statusCode == 200){
        if(responseArrayGetOrderNumbersMsg == "Item Found"){

          setState(() {
            ordNos = List.generate(responseArrayGetOrderNumbers['data'].length, (index) => responseArrayGetOrderNumbers['data'][index]['orderNumber'].toString());

            ordTot = ordNos.length;
            var tmpTot = prefs.getString('totalOrders');

            print("NEWWW : ordTot"+ordTot.toString());
            print("tmpTot"+tmpTot.toString());

            if(int.parse(ordTot.toString()) > int.parse(tmpTot.toString())){
              Fluttertoast.showToast(msg: 'You have received a new order!', backgroundColor: Colors.black, textColor: Colors.white,
                gravity: ToastGravity.TOP,
              );
              Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (c, a1, a2) =>ViewMyOrderNumbers(),
                    transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                    transitionDuration: Duration(milliseconds: 300),
                  )
              );
            }else{

            }

          });

          print("*******");
          print(ordNos);
          print("*******");

          print("deliveryFees"+deliveryFees.toString());

        }else{

          setState(() {
            myOrderNumbers = null;
          });

        }
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    CheckForUpdate();
  }

  @override
  Widget build(BuildContext context) {
    //getOrderNumbers(context);

//    final appcastURL =
//        'https://raw.githubusercontent.com/larryaasen/upgrader/master/test/testappcast.xml';
//    final cfg = AppcastConfiguration(url: appcastURL, supportedOS: ['android']);

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
      child: _isloaded==true? Scaffold(
        //key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            IconButton(icon: Icon(Icons.exit_to_app, color: Colors.blue[700],), onPressed: (){
              showAlertDialogLogout(context);
            }),
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: IconButton(icon: Icon(Icons.notifications, color: Colors.blue[700], size: 30,), onPressed: (){
                    Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (c, a1, a2) => NotificationScreen(),
                          transitionsBuilder: (c, anim, a2, child) =>
                              FadeTransition(opacity: anim, child: child),
                          transitionDuration: Duration(milliseconds: 300),
                        )
                    ).whenComplete((){
                      getNotifications2();
                    });
                  }),
                ),
                displayNotificationCount.toString() == "0" || displayNotificationCount.toString() == "null" ? Container() : Padding(
                  padding: displayNotificationCount.toString() == "0" || displayNotificationCount.toString() == "null" ? EdgeInsets.only(top: 0,) : EdgeInsets.only(left: 20, top: 5),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      color: Colors.red,
                    ),
                    child: Padding(
                      padding: displayNotificationCount.toString() == "0" || displayNotificationCount.toString() == "null" ? EdgeInsets.only(left: 0,) :  EdgeInsets.only(left: 5, right: 5, top: 2, bottom: 2),
                      child: Text(displayNotificationCount.toString()),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: Center(child: buildOptionsContainer(context)),
      ):Container(
      height: 200,
      color: Colors.white,
      child: Center(
        child: new CircularProgressIndicator(
          strokeWidth: 1,
          backgroundColor: Colors.white,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
      ),
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
        ).whenComplete((){
          getOrderNumbers();
        });
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
        ).whenComplete((){
          getOrderNumbers();
        });

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
        ).whenComplete((){
          getOrderNumbers();
        });
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

 _showVersionDialog(context, String version, String support_email,
     String app_store_url, String play_store_url) async {
   print(play_store_url);
   print(play_store_url);
   print(play_store_url);

   await showDialog<String>(
     context: context,
     barrierDismissible: false,
     builder: (BuildContext context) {
       String title = 'New Update Available';
       String message = "Version " +
           version +
           " is required\n(Clear play/App store applications cache, if you see older version)";
       String btnLabel = 'Update Now';
       return Platform.isIOS
           ? new CupertinoAlertDialog(
         title: Text(title),
         content: Text(message),
         actions: <Widget>[
           FlatButton(
             child: Text(btnLabel),
             onPressed: () => _launchURL(app_store_url),
           ),
         ],
       )
           : new AlertDialog(
         title: Text(title),
         content: Text(message),
         actions: <Widget>[
           FlatButton(
             child: Text(btnLabel),
             onPressed: () => _launchURL(play_store_url),
           ),
         ],
       );
     },
   );
 }

 _launchURL(String url) async {
   if (await canLaunch(url)) {
     await launch(url);
   } else {
     throw 'Could not launch $url';
   }
 }

}
