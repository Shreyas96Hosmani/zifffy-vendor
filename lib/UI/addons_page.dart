import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:vendor_dabbawala/UI/Shreyas/my_items.dart';
import 'package:vendor_dabbawala/UI/manage_addons_page.dart';
import 'data/login_data.dart' as login;
import 'package:http/http.dart' as http;
import 'package:vendor_dabbawala/UI/data/globals_data.dart' as globals;
import 'dart:convert';
import 'package:vendor_dabbawala/UI/data/login_data.dart' as login;

var adonIds;
var adonName;
var adonPrice;

TextEditingController nameController = TextEditingController();
TextEditingController priceController = TextEditingController();

var selectedAdOnIdForDeleting;
ProgressDialog prRemove;

class AddAdonsPage extends StatefulWidget {
  final itemId;
  AddAdonsPage(this.itemId) : super();
  @override
  _AddAdonsPageState createState() => _AddAdonsPageState();
}

class _AddAdonsPageState extends State<AddAdonsPage> {
  int _value = 1;

  void _openEndDrawer() {
    login.scaffoldKeyy.currentState.openEndDrawer();
  }

  Future<String> getItemAdons(context) async {

    String url = globals.apiUrl + "getitemadsonlist.php";

    http.post(url, body: {

      "itemID": widget.itemId.toString(),

    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");

      }
      var responseArrayGetAdons = jsonDecode(response.body);
      print(responseArrayGetAdons);
      
      var getAdonsMessage = responseArrayGetAdons['message'].toString();
      print(getAdonsMessage);
      
      if(statusCode == 200){
        if(getAdonsMessage == "Item Found"){
          
          setState(() {
            adonIds = List.generate(responseArrayGetAdons['data'].length, (index) => responseArrayGetAdons['data'][index]['itemadsonID'].toString());
            adonName = List.generate(responseArrayGetAdons['data'].length, (index) => responseArrayGetAdons['data'][index]['itemadsonName'].toString());
            adonPrice = List.generate(responseArrayGetAdons['data'].length, (index) => responseArrayGetAdons['data'][index]['itemadsonPrice'].toString());
          });
          print(adonIds);
          print(adonName);
          print(adonPrice);
          
        }else{
          
          setState(() {
            adonName = null;
          });
          
        }
      }
    });
  }

  Future<String> addAdOns(context) async {

    String url = globals.apiUrl + "additemadson.php";

    http.post(url, body: {

      "itemID" : widget.itemId.toString(),
      "adsonname" : nameController.text.toString(),
      "adsonprice" : priceController.text.toString(),

    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");

      }

      var responseArrayAddAdsOn = jsonDecode(response.body);
      print(responseArrayAddAdsOn);

      var responseArrayAddAdsOnMsg = responseArrayAddAdsOn['message'].toString();
      print(responseArrayAddAdsOnMsg);

      if(statusCode == 200){
        if(responseArrayAddAdsOnMsg == "Successfully"){

          prRemove.hide();
          Fluttertoast.showToast(msg: 'Added', backgroundColor: Colors.black, textColor: Colors.white).whenComplete((){
            nameController.clear();
            priceController.clear();
          });
          getItemAdons(context);

        }else{

          prRemove.hide();
          Fluttertoast.showToast(msg: 'Some error occured', backgroundColor: Colors.black, textColor: Colors.white);

        }
      }

    }

    );

  }

  Future<String> removeAdOns(context) async {

    String url = globals.apiUrl + "removeadsonbyadsonid.php";

    http.post(url, body: {

      "adsoniD" : selectedAdOnIdForDeleting,

    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");

      }

      var responseArrayRemoveAdsOn = jsonDecode(response.body);
      print(responseArrayRemoveAdsOn);

      var responseArrayRemoveAdsOnMsg = responseArrayRemoveAdsOn['message'].toString();
      print(responseArrayRemoveAdsOnMsg);

      if(statusCode == 200){
        if(responseArrayRemoveAdsOnMsg == "Successfully"){

          Fluttertoast.showToast(msg: 'Removed', backgroundColor: Colors.black, textColor: Colors.white).whenComplete((){
            prRemove.hide();
            getItemAdons(context);
          });

        }else{

          Fluttertoast.showToast(msg: 'Some error occured', backgroundColor: Colors.black, textColor: Colors.white).whenComplete((){
            prRemove.hide();
          });

        }
      }

    }

    );

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getItemAdons(context);
    adonName = null;
    selectedAdOnIdForDeleting = null;
  }
  
  @override
  Widget build(BuildContext context) {
    prRemove = ProgressDialog(context);
    return Scaffold(
      endDrawer: buildAppDrawer(context),
      key: login.scaffoldKeyy,
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: buildSaveCancelButton(context),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          children: [
            buildAdOnsListViewBuilder(context),
            SizedBox(height: 20,),
            buildNameField(context),
            SizedBox(height: 10,),
            buildPriceField(context),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: GestureDetector(
                onTap: (){
                  if(nameController.text.toString() == "" || nameController.text.toString() == " " || priceController.text.toString() == "" ||priceController.text.toString() == " " ){
                    Fluttertoast.showToast(msg: 'Some fields are empty', backgroundColor: Colors.black, textColor: Colors.white);
                  }else{
                    prRemove.show();
                    addAdOns(context);
                  }
                },
                child: Container(
                  height: MediaQuery.of(context).size.height/15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.blue[700],
                  ),
                  child: Center(
                    child: Text('Save AddOn',style: GoogleFonts.nunitoSans(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white
                    ),),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }

  Widget buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: Text(
        'Add-ons',textScaleFactor: 1,
        style: GoogleFonts.nunitoSans(
            color: Colors.blue[700], fontSize: 20, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      elevation: 0,
      leading: InkWell(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget buildAdOnsListViewBuilder(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 0),
      child: Column(children: [
        ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(0.0),
            scrollDirection: Axis.vertical,
            itemCount: adonName == null ? 0 : adonName.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Column(
                children: [
                  Container(
                      padding: EdgeInsets.only(left: 0, right: 0),
                      width: MediaQuery.of(context).size.width,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: (){
                              setState(() {
                                selectedAdOnIdForDeleting = adonIds[index].toString();
                              });
                              print(selectedAdOnIdForDeleting);
                              prRemove.show();
                              removeAdOns(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 0, top: 5),
                              child: Icon(Icons.remove_circle, color: Colors.red[900], size: 20,),
                            ),
                          ),
                          SizedBox(width: 20,),
                          Container(
                            //width: MediaQuery.of(context).size.width/1.5,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 0, top: 5),
                              child: Text(
                                adonName[index],textScaleFactor: 1,
                                style: GoogleFonts.nunitoSans(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              "Rs. "+adonPrice[index],textScaleFactor: 1,
                              style: GoogleFonts.nunitoSans(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(width: 20,),
                          InkWell(
                            onTap: (){
                              print("edit...");
                              Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (c, a1, a2) =>ManageAddAdonsPage(adonIds[index], adonName[index], adonPrice[index]),
                                    transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                                    transitionDuration: Duration(milliseconds: 300),
                                  )
                              ).whenComplete((){
                                getItemAdons(context);
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 0, top: 5),
                              child: Icon(Icons.edit, color: Colors.blue, size: 15,),
                            ),
                          ),
                          //SizedBox(width: 5,),
                        ],
                      )),
                  SizedBox(height: 10,),
                  Divider(),
                ],
              ),
            ))
      ]),
    );
  }

  Widget buildAppDrawer(BuildContext context) {
    return Drawer(
      elevation: 20.0,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(100), topRight: Radius.circular(20))),
        child: Drawer(
          elevation: 10,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(100),
                    topRight: Radius.circular(20))),
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                SizedBox(
                  height: 70,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 62,
                    ),
                    Text(
                      'Home',textScaleFactor: 1,
                      style: GoogleFonts.nunitoSans(
                          textStyle: TextStyle(
                        color: Colors.blue[700],
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Divider(
                  height: 10,
                  thickness: 1,
                  color: Colors.black,
                ),
                SizedBox(
                  height: 42,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 60,
                    ),
                    Text(
                      'Add New Item And \nManage Menu',textScaleFactor: 1,
                      style: GoogleFonts.nunitoSans(
                          textStyle: TextStyle(
                        color: Colors.blue[700],
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Divider(
                  height: 10,
                  thickness: 1,
                  color: Colors.black,
                ),
                SizedBox(
                  height: 42,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 62,
                    ),
                    Text(
                      'Order And \nOrder Summary',textScaleFactor: 1,
                      style: GoogleFonts.nunitoSans(
                          textStyle: TextStyle(
                        color: Colors.blue[700],
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Divider(
                  height: 10,
                  thickness: 1,
                  color: Colors.black,
                ),
                SizedBox(
                  height: 42,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 62,
                    ),
                    Text(
                      'Report And Details',textScaleFactor: 1,
                      style: GoogleFonts.nunitoSans(
                          textStyle: TextStyle(
                        color: Colors.blue[700],
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Divider(
                  height: 10,
                  thickness: 1,
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildNameField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Name ',textScaleFactor: 1,
            style: GoogleFonts.nunitoSans(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: MediaQuery.of(context).size.height / 15,
            child: TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.black),
                hintText: 'Enter add on name here'
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildPriceField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Price ',textScaleFactor: 1,
            style: GoogleFonts.nunitoSans(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: MediaQuery.of(context).size.height / 15,
            child: TextFormField(
              controller: priceController,
              decoration: InputDecoration(
                hintText: 'Enter add on price in Rupees',
                labelStyle: TextStyle(color: Colors.black),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildSaveCancelButton(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 0,right: 0),
      child: GestureDetector(
        onTap: (){
          Navigator.of(context).popUntil((route) => route.isFirst);

          Fluttertoast.showToast(msg: 'Item Saved', backgroundColor: Colors.black, textColor: Colors.white);
        },
        child: Container(
          width: MediaQuery.of(context).size.width/1.2,
          height: MediaQuery.of(context).size.height/15,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.blue[700],
          ),
          child: Center(
            child: Text('Done',
              textAlign: TextAlign.center,
              style: GoogleFonts.nunitoSans(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white
              ),),
          ),
        ),
      ),
    );
  }

}
