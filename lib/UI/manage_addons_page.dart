import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
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

class ManageAddAdonsPage extends StatefulWidget {
  final adOnId;
  final name;
  final price;
  ManageAddAdonsPage(this.adOnId, this.name, this.price) : super();
  @override
  _ManageAddAdonsPageState createState() => _ManageAddAdonsPageState();
}

class _ManageAddAdonsPageState extends State<ManageAddAdonsPage> {
  int _value = 1;

  void _openEndDrawer() {
    login.scaffoldKeyy.currentState.openEndDrawer();
  }

  Future<String> addAdOns(context) async {

    String url = globals.apiUrl + "edititemadson.php";

    http.post(url, body: {

      "adsonID" : widget.adOnId.toString(),
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

          Fluttertoast.showToast(msg: 'Saved', backgroundColor: Colors.black, textColor: Colors.white).whenComplete((){
            Navigator.of(context).pop();
          });

        }else{

          Fluttertoast.showToast(msg: 'Some error occured', backgroundColor: Colors.black, textColor: Colors.white);

        }
      }

    }

    );

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController = TextEditingController(text: widget.name);
    priceController = TextEditingController(text: widget.price);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: buildAppDrawer(context),
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: Column(
        children: [
          buildNameField(context),
          SizedBox(height: 10,),
          buildPriceField(context),
          SizedBox(height: 10,),
          buildSaveAndCancelButton(context)
        ],
      ),
    );
  }

  Widget buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: Text(
        'Add-ons',
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
                      padding: EdgeInsets.only(left: 10, right: 10),
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
                                adonName[index],
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
                              "Rs. "+adonPrice[index],
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
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 0, top: 5),
                              child: Icon(Icons.edit, color: Colors.blue, size: 15,),
                            ),
                          ),
                          //SizedBox(width: 5,),
                        ],
                      )),
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
                      'Home',
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
                      'Add New Item And \nManage Menu',
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
                      'Order And \nOrder Summary',
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
                      'Report And Details',
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Name ',
            style: GoogleFonts.nunitoSans(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            width: 23,
          ),
          Container(
            width: MediaQuery.of(context).size.width / 1.56,
            height: MediaQuery.of(context).size.height / 15,
            child: TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 20),
                labelStyle: TextStyle(color: Colors.black),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.black),
                  gapPadding: 10,
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black),
                    gapPadding: 10),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Price ',
            style: GoogleFonts.nunitoSans(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Container(
            width: MediaQuery.of(context).size.width / 2.6,
            height: MediaQuery.of(context).size.height / 15,
            child: TextFormField(
              controller: priceController,
              decoration: InputDecoration(
                hintText: 'Rs',
                hintStyle: GoogleFonts.nunitoSans(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.grey[400]),
                contentPadding: EdgeInsets.only(left: 20),
                labelStyle: TextStyle(color: Colors.black),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.black),
                  gapPadding: 10,
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black),
                    gapPadding: 10),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildSaveAndCancelButton(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(nameController.text.isNotEmpty || priceController.text.isNotEmpty){
          addAdOns(context);
        }else{
          Fluttertoast.showToast(msg: 'Some fields are empty', backgroundColor: Colors.black, textColor: Colors.white);
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 45,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.blue[700],
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.5), blurRadius: 10)
              ]),
          child: Center(
            child: Text(
              'Save',
              style: GoogleFonts.nunitoSans(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
