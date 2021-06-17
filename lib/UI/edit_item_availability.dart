import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'data/login_data.dart' as login;
import 'package:http/http.dart' as http;
import 'package:vendor_dabbawala/UI/data/globals_data.dart' as globals;
import 'dart:convert';
import 'package:vendor_dabbawala/UI/data/login_data.dart' as login;

var itemStatus;
bool itemStatus1;
bool itemStatus2;
bool itemStatus3;
bool itemStatus4;
ProgressDialog prEditItemAvailability;

var itemStForSending;
var itemIdForSending;
var itemTyepFr;

var itemIdssss;
var itemTypesss;

var itmQnty;

class EditItemAvailability extends StatefulWidget {
  final itemid;
  final status;
  EditItemAvailability(this.itemid, this.status) : super();
  @override
  _EditItemAvailabilityState createState() => _EditItemAvailabilityState();
}

class _EditItemAvailabilityState extends State<EditItemAvailability> {

  Future<String> addItemQnty(context) async {


    print("calling add qntyyyy");
    print("itemIdForSending"+itemIdForSending);
    print("qntyController.text.toString()"+qntyController.text.toString());

    String url = globals.apiUrl + "edititemsqnty.php";

    http.post(url, body: {

      "itemID" : itemIdForSending.toString(),
      "itemamount" : qntyController.text.toString(),

    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");

      }

      var responseArrayAddQnty = jsonDecode(response.body);
      print(responseArrayAddQnty);

      var responseArrayAddQntyMsg = responseArrayAddQnty['message'].toString();
      print(responseArrayAddQntyMsg);

      if(statusCode == 200){
        if(responseArrayAddQntyMsg == "Successfully"){

          prEditItemAvailability.hide();
          qntyController.clear();
          getItemIdsByMasterId(context);

          //Fluttertoast.showToast(msg: 'Item Disabled for $itemTyepFr', backgroundColor: Colors.black, textColor: Colors.white);

        }else{

          prEditItemAvailability.hide();getItemIdsByMasterId(context);
          //Fluttertoast.showToast(msg: 'Please check your network connection', backgroundColor: Colors.black, textColor: Colors.white);

        }
      }

    }

    );

  }

  Future<String> editAvailability(context) async {

    String url = globals.apiUrl + "inactiveitems.php";

    http.post(url, body: {

      "itemID" : itemIdForSending.toString(),
      "status" : itemStForSending.toString(),

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

          if(itemStForSending == "2"){
            prEditItemAvailability.hide();
            Fluttertoast.showToast(msg: 'Item Disabled', backgroundColor: Colors.black, textColor: Colors.white).whenComplete((){
              getItemIdsByMasterId(context);
            });
          }else{
            Fluttertoast.showToast(msg: 'Item Enabled', backgroundColor: Colors.black, textColor: Colors.white).whenComplete((){
              addItemQnty(context);
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

  Future<String> getItemIdsByMasterId(context) async {

    String url = globals.apiUrl + "getitemsbymasterid.php";

    http.post(url, body: {

      "masterID" : widget.itemid.toString(),

    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");

      }
      var responseArrayGetItemsByMasterId = jsonDecode(response.body);
      print(responseArrayGetItemsByMasterId);

      var responseArrayGetItemsMsgByMasterId = responseArrayGetItemsByMasterId['message'].toString();
      print(responseArrayGetItemsMsgByMasterId);

      if(statusCode == 200){
        if(responseArrayGetItemsMsgByMasterId == "Item Found"){
          //prGetItems.hide();
          setState(() {
            itemIdssss = List.generate(responseArrayGetItemsByMasterId['data'].length, (index) => responseArrayGetItemsByMasterId['data'][index]['itemID']);
            itemTypesss = List.generate(responseArrayGetItemsByMasterId['data'].length, (index) => responseArrayGetItemsByMasterId['data'][index]['itemType']+" - "+responseArrayGetItemsByMasterId['data'][index]['itemQnty']);
            itemStatus = List.generate(responseArrayGetItemsByMasterId['data'].length, (index) => responseArrayGetItemsByMasterId['data'][index]['itemStatus']);
            itmQnty = List.generate(responseArrayGetItemsByMasterId['data'].length, (index) => responseArrayGetItemsByMasterId['data'][index]['itemQnty']);

          });
          print(itemIdssss);
          print(itemTypesss);
          print(itemStatus);
          print(itmQnty);

        }else{
          //prGetItems.hide();
          setState(() {
            itemIdssss = null;
          });

        }
      }
    });

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
    itemStForSending = null; itemIdForSending = null; itemTyepFr = null;
    getItemIdsByMasterId(context);
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
        },
        child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: itemTypesss == null ? 0 : itemTypesss.length,
            itemBuilder: (context, index) =>
                itemStatus[index].toString() == "0" ? Container() :
                Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(itemTypesss[index],//widget.status.toString() == "1" ? "Enabled" : "Disabled",
                        style: GoogleFonts.nunitoSans(
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(width: 10,),
                      itemStatus[index].toString() == "2" ? Container() : IconButton(
                        icon: Icon(Icons.edit, size: 25, color: Colors.blue[700],),
                        onPressed: (){
                          setState(() {
                            qntyController = TextEditingController(text: itmQnty[index].toString());
                            itemIdForSending = itemIdssss[index].toString();
                          });
                          showAlertDialog2(context);
                        },
                      ),
                      Spacer(),
                      Container(
                        child: Transform.scale(
                            scale: 1,
                            child: Switch(
                              onChanged: (bool value){
                                if(itemStatus[index].toString() == "2")
                                {
                                  setState(() {
                                    itemStatus[index] = "1";

                                    itemStForSending = "1";
                                    itemIdForSending = itemIdssss[index].toString();
                                    itemTyepFr = itemTypesss[index].toString();

                                  });
                                  print(itemStatus);
                                  showAlertDialog(context);
                                }
                                else
                                {
                                  setState(() {
                                    itemStatus[index] = "2";

                                    itemStForSending = "2";
                                    itemIdForSending = itemIdssss[index].toString();
                                    itemTyepFr = itemTypesss[index].toString();
                                  });
                                  prEditItemAvailability.show();
                                  print(itemStatus);
                                  editAvailability(context);
                                }
                              },
                              value: itemStatus[index].toString() == "1" ? true : false,
                              activeColor: Color(0xffb9ce82),
                              activeTrackColor: Colors.grey.shade300,//.shade300,
                              inactiveThumbColor: Colors.red[900],
                              inactiveTrackColor: Colors.grey.shade300,
                            ),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(),
              ],
            ),
        ),
      ),
      /*
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

       */
    );
  }

  Widget buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: InkWell(
        onTap: (){
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

  showAlertDialog(BuildContext context) {

    getItemIdsByMasterId(context);

    Widget textField = Theme(
        data: ThemeData(
          primaryColor: Colors.blue[700],
        ),
        child: TextFormField(
          controller: qntyController,
          decoration: InputDecoration(
              hintText: 'Add quantity'
          ),
        ));

    GestureDetector buildSaveButton = GestureDetector(
      onTap: (){
        if(qntyController.text.toString() == "" || qntyController.text.toString() == " " || qntyController.text.toString() == null){
          Fluttertoast.showToast(msg: 'Please input quantity!', backgroundColor: Colors.black, textColor: Colors.white);
        }else{
          prEditItemAvailability.show();
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          editAvailability(context);
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 10,
        child: Container(
          height: 50,
          width: MediaQuery
              .of(context)
              .size
              .width / 2.4,
          decoration: BoxDecoration(
              color: Colors.blue[700],
              borderRadius: BorderRadius.all(Radius.circular(12))
          ),
          child: Center(
            child: Text("Done",
                style: GoogleFonts.nunitoSans(textStyle: TextStyle(fontSize: 16, letterSpacing: 1,color: Colors.white),)
            ),
          ),
        ),
      ),
    );

    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))
      ),
      title: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Align(
              alignment: Alignment.centerRight,
              child: IconButton(icon: Icon(Icons.close,color: Colors.grey,),onPressed: (){Navigator.of(context).pop();},)),
          SizedBox(height: 10,),
          Text("Add Item Quantity", style: GoogleFonts.nunitoSans(textStyle: TextStyle(fontSize: 16, letterSpacing: 1),)),
          Text("for "+itemTyepFr.toString(),style: GoogleFonts.nunitoSans(textStyle: TextStyle(fontSize: 16, letterSpacing: 1),)),
          SizedBox(height: 10,)
        ],
      ),
      content: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                textField,
                SizedBox(height: 25,),
                buildSaveButton,
                SizedBox(height: 25,),
              ],
            ),
          ),
        ),
      ),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialog2(BuildContext context) {

    getItemIdsByMasterId(context);

    Widget textField = Theme(
        data: ThemeData(
          primaryColor: Colors.blue[700],
        ),
        child: TextFormField(
          controller: qntyController,
          decoration: InputDecoration(
              hintText: 'Add quantity'
          ),
        ));

    GestureDetector buildSaveButton = GestureDetector(
      onTap: (){
        if(qntyController.text.toString() == "" || qntyController.text.toString() == " " || qntyController.text.toString() == null){
          Fluttertoast.showToast(msg: 'Please input quantity!', backgroundColor: Colors.black, textColor: Colors.white);
        }else{
          prEditItemAvailability.show();
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          addItemQnty(context);
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 10,
        child: Container(
          height: 50,
          width: MediaQuery
              .of(context)
              .size
              .width / 2.4,
          decoration: BoxDecoration(
              color: Colors.blue[700],
              borderRadius: BorderRadius.all(Radius.circular(12))
          ),
          child: Center(
            child: Text("Done",
                style: GoogleFonts.nunitoSans(textStyle: TextStyle(fontSize: 16, letterSpacing: 1,color: Colors.white),)
            ),
          ),
        ),
      ),
    );

    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))
      ),
      title: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Align(
              alignment: Alignment.centerRight,
              child: IconButton(icon: Icon(Icons.close,color: Colors.grey,),onPressed: (){Navigator.of(context).pop();},)),
          SizedBox(height: 10,),
          Text("Add Item Quantity", style: GoogleFonts.nunitoSans(textStyle: TextStyle(fontSize: 16, letterSpacing: 1),)),
          Text("for "+itemTyepFr.toString(),style: GoogleFonts.nunitoSans(textStyle: TextStyle(fontSize: 16, letterSpacing: 1),)),
          SizedBox(height: 10,)
        ],
      ),
      content: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                textField,
                SizedBox(height: 25,),
                buildSaveButton,
                SizedBox(height: 25,),
              ],
            ),
          ),
        ),
      ),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}

TextEditingController qntyController = TextEditingController();
