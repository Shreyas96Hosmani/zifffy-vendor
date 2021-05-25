import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:vendor_dabbawala/UI/addons_page.dart';
import 'data/login_data.dart' as login;
import 'package:http/http.dart' as http;
import 'package:vendor_dabbawala/UI/data/globals_data.dart' as globals;
import 'dart:convert';
import 'package:vendor_dabbawala/UI/data/login_data.dart' as login;

final formKey = GlobalKey<FormState>();

var selectedQnty;
TextEditingController subItemNameController = TextEditingController();
TextEditingController subItemDescriptionController = TextEditingController();
TextEditingController subItemPriceController = TextEditingController();

var subItemIdsList;
var subItemNamesList;
var subItemDescriptionList;
var subItemAmountsList;
var subItemPricesList;

ProgressDialog prSubItem;

var selectedSubItemIdForDelete;

class ManageSubItems extends StatefulWidget {
  final id;
  ManageSubItems(this.id) : super();
  @override
  _ManageSubItemsState createState() => _ManageSubItemsState();
}

class _ManageSubItemsState extends State<ManageSubItems> {

  Future<String> getSubItemList(context) async {

    String url = "https://admin.dabbawala.ml/mobileapi/user/getsubitembyitemid.php";

    http.post(url, body: {

      "itemID" : widget.id.toString(),

    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");

      }
      var responseArrayGetSubItems = jsonDecode(response.body);
      print(responseArrayGetSubItems);

      var responseArrayGetSubItemsMsg = responseArrayGetSubItems['message'].toString();
      print(responseArrayGetSubItemsMsg);

      if(statusCode == 200){
        if(responseArrayGetSubItemsMsg == "Item Found"){
          //prGetItems.hide();
          setState(() {
            subItemIdsList = List.generate(responseArrayGetSubItems['data'].length, (index) => responseArrayGetSubItems['data'][index]['subitemID'].toString());
            subItemNamesList = List.generate(responseArrayGetSubItems['data'].length, (index) => responseArrayGetSubItems['data'][index]['subitemName'].toString());
            subItemDescriptionList = List.generate(responseArrayGetSubItems['data'].length, (index) => responseArrayGetSubItems['data'][index]['subitemDescription'].toString());
            subItemAmountsList = List.generate(responseArrayGetSubItems['data'].length, (index) => responseArrayGetSubItems['data'][index]['subitemPrice'].toString());
          });
          print(subItemIdsList.toList());
          print(subItemNamesList.toList());
          print(subItemDescriptionList.toList());
          print(subItemAmountsList.toList());

        }else{
          //prGetItems.hide();
          setState(() {
            subItemNamesList = null;
          });

        }
      }
    });

  }

  Future<String> addSubItem(context) async {

    String url = "https://admin.dabbawala.ml/mobileapi/vendor/addsubitem.php";

    http.post(url, body: {

      "itemID" : widget.id.toString(),
      "name" : subItemNameController.text.toString(),
      "description" : subItemDescriptionController.text.toString(),
      "price" : subItemPriceController.text.toString()+" "+selectedQnty.toString(),
      "image" : "null",

    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");

      }
      var responseArrayGetAddSubItems = jsonDecode(response.body);
      print(responseArrayGetAddSubItems);

      var responseArrayGetAddSubItemsMsg = responseArrayGetAddSubItems['message'].toString();
      print(responseArrayGetAddSubItemsMsg);

      if(statusCode == 200){
        if(responseArrayGetAddSubItemsMsg == "Successfully"){

          prSubItem.hide().whenComplete((){
            Fluttertoast.showToast(msg: 'SubItem Added Successfully', backgroundColor: Colors.black, textColor: Colors.white);
            subItemNameController.clear();
            subItemDescriptionController.clear();
            subItemPriceController.clear();
            getSubItemList(context);
          });

        }else{

          prSubItem.hide().whenComplete((){
            Fluttertoast.showToast(msg: 'Please check your network connection!', backgroundColor: Colors.black, textColor: Colors.white);
          });

        }
      }
    });

  }

  Future<String> removeSubItem(context) async {

    String url = "https://admin.dabbawala.ml/mobileapi/vendor/deletesubitems.php";

    http.post(url, body: {

      "subitemID" : selectedSubItemIdForDelete.toString(),

    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");

      }
      var responseArrayDelet = jsonDecode(response.body);
      print(responseArrayDelet);

      var responseArrayDeletMsg = responseArrayDelet['message'].toString();
      print(responseArrayDeletMsg);

      if(statusCode == 200){
        if(responseArrayDeletMsg == "Successfully"){

          prSubItem.hide().whenComplete((){
            Fluttertoast.showToast(msg: 'SubItem Deleted', backgroundColor: Colors.black, textColor: Colors.white);
            getSubItemList(context);
          });

        }else{

          prSubItem.hide().whenComplete((){
            Fluttertoast.showToast(msg: 'Please check your network connection!', backgroundColor: Colors.black, textColor: Colors.white);
          });

        }
      }
    });

  }

  void _openEndDrawer() {
    login.scaffoldKei.currentState.openEndDrawer();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedSubItemIdForDelete = null;
    getSubItemList(context);
  }

  @override
  Widget build(BuildContext context) {
    prSubItem = ProgressDialog(context);
    return Scaffold(
      key: login.scaffoldKei,
      endDrawer: buildAppDrawer(context),
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: buildSaveCancelButton(context),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
              children: [
                buildSubItemsListViewBuilder(context),
                SizedBox(height: 20,),
                buildNameField(context),
                SizedBox(height: 10,),
                buildDescriptionField(context),
                buildAmountField(context),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Center(
                    child: Text("Note : Sub Items include items in the dish (ex.- rice/daal/etc). You can skip this section and edit this later on!",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunitoSans(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
              ],
            ),
          ),
        ),
      ),

    );
  }

  buildAppBar(BuildContext context){
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      centerTitle: true,
      leading: InkWell(
          onTap: (){
            Navigator.of(context).pop();
          },
          child: Icon(Icons.arrow_back,color: Colors.black,)),
      title: Text('Manage Sub Items',style: GoogleFonts.nunitoSans(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Colors.blue[700],
      ),),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: InkWell(
            onTap: ()=> _openEndDrawer(),
              child: Icon(Icons.menu,color: Colors.black,)),
        )
      ],
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
            'Sub Item Name : ',
            style: GoogleFonts.nunitoSans(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 10,),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 45,
            child: TextFormField(
              enabled: true,
              controller: subItemNameController,
              decoration: InputDecoration(
                hintText: 'Enter sub item name here (Ex. rice/chapati/daal, etc)',
                labelStyle: TextStyle(color: Colors.black),
              ),
              validator: (val){
                if(val.isEmpty){
                  return 'Field cannot be empty!';
                }
                return null;
              },
            ),
          )
        ],
      ),
    );
  }

  Widget buildDescriptionField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sub Item Description : ',
            style: GoogleFonts.nunitoSans(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 10,),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 45,
            child: TextFormField(
              controller: subItemDescriptionController,
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.black),
                hintText: 'Enter sub item description here'
              ),
              validator: (val){
                if(val.isEmpty){
                  return 'Field cannot be empty!';
                }
                return null;
              },
            ),
          )
        ],
      ),
    );
  }

  Widget buildAmountField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            'Add SubItem Amount : ',
            style: GoogleFonts.nunitoSans(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.height / 15,
                child: TextFormField(
                  controller: subItemPriceController,
                  decoration: InputDecoration(
                    hintText: '',
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
                  validator: (val){
                    if(val.isEmpty){
                      return 'Field cannot be empty!';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 3.5,
                height: MediaQuery.of(context).size.height / 15,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                        elevation: 0,
                        value: selectedQnty,
                        items: [
                          DropdownMenuItem(
                            child: Text("gms"),
                            value: 'gms',
                          ),
                          DropdownMenuItem(
                            child: Text("ml"),
                            value: 'ml',
                          ),
                          DropdownMenuItem(
                            child: Text("pcs"),
                            value: 'pcs',
                          ),

                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedQnty = value.toString();
                          });
                          print(value);
                        }),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget buildAppDrawer(BuildContext context){
    return Drawer(
      elevation: 20.0,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(100),topRight: Radius.circular(20))
        ),
        child: Drawer(
          elevation: 10,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(100),topRight: Radius.circular(20))
            ),
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                SizedBox(height: 42,),
                Row(
                  children: [
                    SizedBox(width: 62,),
                    Text('Home',
                      style: GoogleFonts.nunitoSans(
                          textStyle: TextStyle(
                            color: Colors.blue[700],
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          )
                      ),
                    ),
                    SizedBox(height: 20,),
                  ],
                ),
                SizedBox(height: 20,),
                Divider(height: 10,thickness: 1,color: Colors.black,),
                SizedBox(height: 42,),
                Row(
                  children: [
                    SizedBox(width: 60,),
                    Text('Add New Item And \nManage Menu',
                      style: GoogleFonts.nunitoSans(
                          textStyle: TextStyle(
                            color: Colors.blue[700],
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          )
                      ),
                    ),
                    SizedBox(height: 20,),
                  ],
                ),
                SizedBox(height: 20,),
                Divider(height: 10,thickness: 1,color: Colors.black,),
                SizedBox(height: 42,),
                Row(
                  children: [
                    SizedBox(width: 62,),
                    Text('Order And \nOrder Summary',
                      style: GoogleFonts.nunitoSans(
                          textStyle: TextStyle(
                            color: Colors.blue[700],
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          )
                      ),
                    ),
                    SizedBox(height: 20,),
                  ],
                ),
                SizedBox(height: 20,),
                Divider(height: 10,thickness: 1,color: Colors.black,),
                SizedBox(height: 42,),
                Row(
                  children: [
                    SizedBox(width: 62,),
                    Text('Report And Details',
                      style: GoogleFonts.nunitoSans(
                          textStyle: TextStyle(
                            color: Colors.blue[700],
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          )
                      ),
                    ),
                    SizedBox(height: 20,),
                  ],
                ),
                SizedBox(height: 20,),
                Divider(height: 10,thickness: 1,color: Colors.black,),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSubItemsListViewBuilder(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 0),
      child: Column(children: [
        ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(0.0),
            scrollDirection: Axis.vertical,
            itemCount: subItemNamesList == null ? 0 : subItemNamesList.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Container(
                              padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                              width: MediaQuery.of(context).size.width/1.5,
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    //width: MediaQuery.of(context).size.width/1.5,
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 0, top: 5),
                                      child: Text(
                                        subItemNamesList[index],
                                        style: GoogleFonts.nunitoSans(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Text(
                                      subItemAmountsList[index],
                                      style: GoogleFonts.nunitoSans(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Text(
                                      subItemDescriptionList[index],
                                      style: GoogleFonts.nunitoSans(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  //SizedBox(width: 5,),
                                ],
                              )),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: GestureDetector(
                              onTap: (){
                                setState(() {
                                  selectedSubItemIdForDelete = subItemIdsList[index].toString();
                                });
                                print(selectedSubItemIdForDelete);
                                prSubItem.show();
                                removeSubItem(context);
                              },
                              child: Icon(Icons.remove_circle_outline, size: 30, color: Colors.red,)),
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                ],
              ),
            ))
      ]),
    );
  }

  Widget buildSaveCancelButton(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 0,right: 0),
      child: Row(
        children: [
          Flexible(
            child: GestureDetector(
              onTap: (){
                print(subItemPriceController.text.toString()+selectedQnty.toString());
                if(formKey.currentState.validate()){
                  prSubItem.show();
                  addSubItem(context);
                }
              },
              child: Container(
                height: MediaQuery.of(context).size.height/15,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.blue[700],
                ),
                child: Center(
                  child: Text('Save Sub Item',style: GoogleFonts.nunitoSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white
                  ),),
                ),
              ),
            ),
          ),
          SizedBox(width: 20,),
          Flexible(
            child: GestureDetector(
              onTap: (){
                Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (c, a1, a2) =>AddAdonsPage(widget.id.toString()),
                      transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                      transitionDuration: Duration(milliseconds: 300),
                    )
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width/2.2,
                height: MediaQuery.of(context).size.height/15,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.blue[700],
                ),
                child: Center(
                  child: Text('Next ->\nAdd Add Ons',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunitoSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white
                  ),),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
