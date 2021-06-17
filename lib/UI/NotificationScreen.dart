import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'data/login_data.dart' as login;
import 'package:vendor_dabbawala/UI/data/globals_data.dart' as globals;

var notificationTitles;
var notificationDescriptions;
var notificationDateTimes;
var notificationLinks;

var totalNotificationCount;

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  Future<String> getNotifications(context) async {

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

            totalNotificationCount = notificationTitles.toList().length;

            prefs.setString('totalNotifications',totalNotificationCount.toString());

          });
          print(notificationTitles.toList());
          print(notificationDescriptions.toList());
          print(notificationDateTimes.toList());
          print(notificationLinks.toList());

          print("totallllll");
          print(totalNotificationCount.toString());
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      notificationTitles = null;
    });
    getNotifications(context);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: notificationTitles == null ? Center(
        child: Text("No notifications to show",
          style: GoogleFonts.nunitoSans(
            fontSize: 18,
            color: Colors.blue[700],
          ),
        ),
      ): SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              height: screenHeight,
              child: buildOffersList(context),
            ),
          ],
        )
      ),
    );
  }

  Widget buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: false,
      backgroundColor: Colors.white,
      elevation: 1,
      leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back_outlined,
            color: Colors.black,
            size: 20,
          )),
      title: Text(
        'Notifications',
        style: GoogleFonts.nunitoSans(
          color: Colors.black,
          fontSize: 20,
        ),
      ),
    );
  }

  Widget buildOffersList(BuildContext context) {

    return ListView.builder(
        shrinkWrap: true,
        physics: AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: notificationTitles == null ? 0 : notificationTitles.toList().length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(top: 5),
          child: InkWell(
            onTap: () {

            },
            child: Column(
              children: [
                Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Text(
                                notificationTitles[index].toString(),
                                textScaleFactor: 1,
                                style: GoogleFonts.nunitoSans(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Spacer(),
                            Flexible(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(notificationDateTimes[index].toString().substring(8,10) + " ",
                                    style: GoogleFonts.nunitoSans(
                                      fontSize: 14,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  Text(notificationDateTimes[index].toString().substring(5,7) == "01" ? "Jan" :
                                  notificationDateTimes[index].toString().substring(5,7) == "02" ? "Feb" :
                                  notificationDateTimes[index].toString().substring(5,7) == "03" ? "Mar" :
                                  notificationDateTimes[index].toString().substring(5,7) == "04" ? "Apr" :
                                  notificationDateTimes[index].toString().substring(5,7) == "05" ? "May" :
                                  notificationDateTimes[index].toString().substring(5,7) == "06" ? "Jun" :
                                  notificationDateTimes[index].toString().substring(5,7) == "07" ? "Jul" :
                                  notificationDateTimes[index].toString().substring(5,7) == "08" ? "Aug" :
                                  notificationDateTimes[index].toString().substring(5,7) == "09" ? "Sep" :
                                  notificationDateTimes[index].toString().substring(5,7) == "10" ? "Oct" :
                                  notificationDateTimes[index].toString().substring(5,7) == "11" ? "Nov"
                                      : "Dec",
                                    style: GoogleFonts.nunitoSans(
                                      fontSize: 14,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  Text(" "+notificationDateTimes[index].toString().substring(0,4),
                                    style: GoogleFonts.nunitoSans(
                                      fontSize: 14,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  Text(", "+notificationDateTimes[index].toString().substring(11,16),
                                    style: GoogleFonts.nunitoSans(
                                      fontSize: 14,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          notificationDescriptions[index].toString(),
                          textScaleFactor: 1,
                          style: GoogleFonts.nunitoSans(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                        notificationLinks[index].toString() == "" || notificationLinks[index].toString() == "null" ? Container() : Text(
                          notificationLinks[index].toString(),
                          textScaleFactor: 1,
                          style: GoogleFonts.nunitoSans(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    )),
                Divider(),
              ],
            ),
          ),
        ));
  }
}
