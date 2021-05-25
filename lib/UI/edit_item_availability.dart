import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'data/login_data.dart' as login;
import 'package:http/http.dart' as http;
import 'package:vendor_dabbawala/UI/data/globals_data.dart' as globals;
import 'dart:convert';
import 'package:vendor_dabbawala/UI/data/login_data.dart' as login;

bool itemStatus;
ProgressDialog prEditItemAvailability;

class EditItemAvailability extends StatefulWidget {
  final itemid;
  final status;
  EditItemAvailability(this.itemid, this.status) : super();
  @override
  _EditItemAvailabilityState createState() => _EditItemAvailabilityState();
}

class _EditItemAvailabilityState extends State<EditItemAvailability> {

  Future<String> editAvailability(context) async {

    String url = globals.apiUrl + "inactiveitems.php";

    http.post(url, body: {

      "itemID" : widget.itemid.toString(),
      "status" : itemStatus == true ? "1" : "0",

    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");

      }

      var responseArrayEditAvailability = jsonDecode(response.body);
      print(responseArrayEditAvailability);

      var responseArrayEditAvailabilityMsg = responseArrayEditAvailability['message'].toString();
      print(responseArrayEditAvailabilityMsg);

      if(statusCode == 200){
        if(responseArrayEditAvailabilityMsg == "Successfully"){

          prEditItemAvailability.hide();
          if(itemStatus == false){
            Fluttertoast.showToast(msg: 'Item Disabled', backgroundColor: Colors.black, textColor: Colors.white).whenComplete((){
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            });
          }else{
            Fluttertoast.showToast(msg: 'Item Enabled', backgroundColor: Colors.black, textColor: Colors.white).whenComplete((){
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            });
          }

        }else{

          prEditItemAvailability.hide();
          Fluttertoast.showToast(msg: 'Please check your network connection', backgroundColor: Colors.black, textColor: Colors.white);

        }
      }

    }

    );

  }

  void toggleSwitch(bool value) {

    if(itemStatus == false)
    {
      setState(() {
        itemStatus = true;
      });
      prEditItemAvailability.show();
      print(itemStatus);
      editAvailability(context);
    }
    else
    {
      setState(() {
        itemStatus = false;
      });
      prEditItemAvailability.show();
      print(itemStatus);
      editAvailability(context);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.status.toString() == "1"){
      itemStatus = true;
    }else{
      itemStatus = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    prEditItemAvailability = ProgressDialog(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: WillPopScope(
        onWillPop: (){
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Breakfast",//widget.status.toString() == "1" ? "Enabled" : "Disabled",
                    style: GoogleFonts.nunitoSans(
                      fontSize: 18,
                    ),
                  ),
                  Container(
                    child: Transform.scale(
                        scale: 1,
                        child: Switch(
                          onChanged: toggleSwitch,
                          value: itemStatus,
                          activeColor: Color(0xffb9ce82),
                          activeTrackColor: Colors.grey.shade300,//.shade300,
                          inactiveThumbColor: Colors.red[900],
                          inactiveTrackColor: Colors.grey.shade300,
                        )
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Lunch",//widget.status.toString() == "1" ? "Enabled" : "Disabled",
                    style: GoogleFonts.nunitoSans(
                      fontSize: 18,
                    ),
                  ),
                  Container(
                    child: Transform.scale(
                        scale: 1,
                        child: Switch(
                          onChanged: toggleSwitch,
                          value: itemStatus,
                          activeColor: Color(0xffb9ce82),
                          activeTrackColor: Colors.grey.shade300,//.shade300,
                          inactiveThumbColor: Colors.red[900],
                          inactiveTrackColor: Colors.grey.shade300,
                        )
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Snacks",//widget.status.toString() == "1" ? "Enabled" : "Disabled",
                    style: GoogleFonts.nunitoSans(
                      fontSize: 18,
                    ),
                  ),
                  Container(
                    child: Transform.scale(
                        scale: 1,
                        child: Switch(
                          onChanged: toggleSwitch,
                          value: itemStatus,
                          activeColor: Color(0xffb9ce82),
                          activeTrackColor: Colors.grey.shade300,//.shade300,
                          inactiveThumbColor: Colors.red[900],
                          inactiveTrackColor: Colors.grey.shade300,
                        )
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Dinner",//widget.status.toString() == "1" ? "Enabled" : "Disabled",
                    style: GoogleFonts.nunitoSans(
                      fontSize: 18,
                    ),
                  ),
                  Container(
                    child: Transform.scale(
                        scale: 1,
                        child: Switch(
                          onChanged: toggleSwitch,
                          value: itemStatus,
                          activeColor: Color(0xffb9ce82),
                          activeTrackColor: Colors.grey.shade300,//.shade300,
                          inactiveThumbColor: Colors.red[900],
                          inactiveTrackColor: Colors.grey.shade300,
                        )
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
          ],
        ),
      )
    );
  }

  Widget buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: InkWell(
        onTap: (){
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        },
        child: Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
      ),
      title: Text(
        'Item Availability',textScaleFactor: 1,
        style: GoogleFonts.nunitoSans(
            color: Colors.blue[700], fontSize: 20, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
    );
  }

}
