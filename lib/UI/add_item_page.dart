import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:vendor_dabbawala/UI/Shreyas/Widgets/AppDrawerWidget.dart';
import 'package:vendor_dabbawala/UI/Shreyas/my_items.dart';
import 'package:vendor_dabbawala/UI/add_item_images.dart';
import 'package:vendor_dabbawala/UI/subitems_page.dart';
import 'addons_page.dart';
import 'data/login_data.dart' as login;
import 'package:vendor_dabbawala/UI/data/add_new_item_data.dart' as add;
import 'package:http/http.dart' as http;
import 'package:vendor_dabbawala/UI/data/globals_data.dart' as globals;
import 'dart:convert';

var selectedCuisineId;
var selectedItemType;
ProgressDialog prAddItem;

var itemIdForpassing;

List<String> cuisineIds;
List<String> cuisineNames;

var skuNo;

List<int> selectedItems = [];
List<int> selectedItemsTypes = [];

class AddItemPage extends StatefulWidget {
  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {

  Future<String> addNewItem(context) async {

    String url = globals.apiUrl + "addnewitem.php";

    http.post(url, body: {

      "vendorID": login.storedUserId.toString(),
      "itemname" : add.addNewItemNameController.text.toString(),
      "cuisineID": selectedCuisineId.toString(),
      "itemtype": selectedItemType.toString(),//selectedItemsTypes.toList().toString(),//selectedItemType.toString(),
      "itemcategory":add.itemCategory.toString(),
      "itemamount": add.addNewItemAmountNumController.text.toString() + add.itemQuantity.toString(),
      "itemprice": add.addNewItemPriceController.text.toString(),
      "itemdescription": add.addNewItemDescriptionController.text.toString(),
      "productimages[0]" : "null",


    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");

      }
      add.responseArrayAddNewItem = jsonDecode(response.body);
      print(add.responseArrayAddNewItem);
      add.addNewItemResponse = add.responseArrayAddNewItem['status'].toString();
      add.addNewItemMessage = add.responseArrayAddNewItem['message'].toString();
      if(statusCode == 200){
        if(add.addNewItemMessage == "Successfully"){

          prAddItem.hide().whenComplete((){

            setState(() {
              add.addNewItemNameController.clear();
              selectedCuisineId = null;
              selectedItemType = null;
              add.itemCategory = null;
              add.addNewItemAmountNumController.clear();
              add.addNewItemPriceController.clear();
              add.addNewItemDescriptionController.clear();
            });

            Fluttertoast.showToast(msg: "Saved", backgroundColor: Colors.black, textColor: Colors.white).whenComplete((){
              print(add.addNewItemMessage);
              itemIdForpassing = add.responseArrayAddNewItem['data'].toString();
              print(itemIdForpassing);
              Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (c, a1, a2) =>AddItemImages(itemIdForpassing),
                    transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                    transitionDuration: Duration(milliseconds: 300),
                  )
              );
            });

          });
        }else{

          prAddItem.hide().whenComplete((){
            Fluttertoast.showToast(msg: "Some error occured!", backgroundColor: Colors.black, textColor: Colors.white);
          });

        }
      }

    });

  }

  Future<String> getCuisines(context) async {

    String url = "https://admin.dabbawala.ml/mobileapi/vendor/getallcuisine.php";

    http.post(url, body: {

    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");

      }
      var responseArrayGetCusines = jsonDecode(response.body);
      print(responseArrayGetCusines);

      var responseArrayGetCusinesMsg = responseArrayGetCusines['message'].toString();
      print(responseArrayGetCusinesMsg);

      if(statusCode == 200){
        if(responseArrayGetCusinesMsg == "Cuisine Found"){
          //prGetItems.hide();
          setState(() {
            cuisineIds = List.generate(responseArrayGetCusines['data'].length, (index) => responseArrayGetCusines['data'][index]['cuisineID'].toString());
            cuisineNames = List.generate(responseArrayGetCusines['data'].length, (index) => responseArrayGetCusines['data'][index]['cuisineName'].toString());
          });
          print(cuisineIds.toList());
          print(cuisineNames.toList());

        }else{
          //prGetItems.hide();
          setState(() {

          });

        }
      }
    });

  }


  void _openEndDrawer() {
    login.scaffoldKey.currentState.openEndDrawer();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      selectedItems = [];
      skuNo = DateTime.now().microsecondsSinceEpoch.toString();
      selectedCuisineId = null;
      selectedItemType = null;
      add.itemType = null;
      add.itemCategory = null;
      add.itemQuantity = null;
      imageOne = null;
      imageTwo = null;
      imageThree = null;
      itemIdForpassing = null;
      add.addNewItemNameController.clear();//text = null;
      add.addNewItemAmountNumController.clear();//.text = null;
      add.addNewItemPriceController.clear();//.text = null;
      add.addNewItemDescriptionController.clear();//.text = null;
    });
    getCuisines(context);
  }

  @override
  Widget build(BuildContext context) {
    prAddItem = ProgressDialog(context);
    return Scaffold(
      key:login.scaffoldKey,
      endDrawer: AppDrawerWidget(),
      appBar: buildAppBar(context),
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: (){FocusScope.of(context).requestFocus(new FocusNode());},
        child: SingleChildScrollView(
          child: Form(
            key: add.formKey,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 10,),
                  //buildSKUNo(context),
                  buildNameField2(context),
                  SizedBox(height: 20,),
                  buildCuisineField2(context),
                  SizedBox(height: 20,),
                  buildTypeField2(context),
                  SizedBox(height: 20,),
                  buildCategoryField2(context),
                  SizedBox(height: 20,),
                  buildAmountField2(context),
                  SizedBox(height: 20,),
                  buildPriceField2(context),
                  SizedBox(height: 20,),
                  buildDescriptionField(context),
                  SizedBox(height: 20,),
                  buildSaveAndCancelButton(context),
                  SizedBox(height: 20,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAppBar(BuildContext context) {
    return AppBar(actions: [
      Padding(
        padding: const EdgeInsets.only(right: 20),
        child: InkWell(
            onTap: () => _openEndDrawer(),

            child: Icon(Icons.menu,color: Colors.black,)),
      )
    ],
      backgroundColor: Colors.white,
      title: Text(
        'Add New Item',
        style: GoogleFonts.nunitoSans(
            color: Colors.blue[700], fontSize: 20, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      elevation: 0,
      leading: InkWell(
        onTap: (){
          Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (c, a1, a2) =>MyItems(),
                transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                transitionDuration: Duration(milliseconds: 300),
              )
          );
        },
        child: Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
      ),

    );
  }

  Widget buildSKUNo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Row(
        children: [
          Text(
            'SKU No - ',
            style: GoogleFonts.nunitoSans(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 50),
          Container(
//            width: MediaQuery.of(context).size.width / 5,
//            height: MediaQuery.of(context).size.height / 15,
            child: Center(
              child: Text(
                "ZV-"+skuNo,
                style: GoogleFonts.nunitoSans(
                    fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
          )
        ],
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
            height: MediaQuery.of(context).size.height / 15,
            child: TextFormField(
              controller: add.addNewItemNameController,
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

  Widget buildCuisineField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cuisine ',
            style: GoogleFonts.nunitoSans(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.all(Radius.circular(10))
            ),
            child: Align(
              alignment: Alignment.center,
              child: SearchableDropdown.single(
                  items: cuisineNames == null ? []: cuisineNames.map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(
                        value,
                        textScaleFactor: 1,
                      ),
                    );
                  }).toList(),
                  value: "Search cuisine...",
                  hint: "",
                  searchHint: "Search cuisine",
                  clearIcon: Icon(null),
//                  onClear: (){
//                    setState(() {
//                      selectedCategory = null;
//                    });
//                  },
                  onChanged: (value) {
                    setState(() {
                      int idx = cuisineNames.indexOf(value);
                      selectedCuisineId = cuisineIds[idx].toString();
                    });
                    print(selectedCuisineId);
                  },
                  isExpanded: true
              ),
              /*
              DropdownButtonHideUnderline(
                child: DropdownButton(
                  elevation: 0,
                  value: add.cuisineId,
                  items:[
                    DropdownMenuItem(
                      child: Text("North Indian"),
                      value: 'North Indian',
                    ),
                    DropdownMenuItem(
                      child: Text("South Indian"),
                      value: "South Indian",
                    ),
                    DropdownMenuItem(
                        child: Text("Gujarati"),
                        value: "Gujarati"
                    ),
                    DropdownMenuItem(
                        child: Text("Bengali"),
                        value: "Bengali"
                    ),
                    DropdownMenuItem(
                        child: Text("Italian"),
                        value: "Italian"
                    ),
                    DropdownMenuItem(
                        child: Text("Mexican"),
                        value: "Mexican"
                    ),
                    DropdownMenuItem(
                        child: Text("Desserts"),
                        value: "Desserts"
                    ),
                    DropdownMenuItem(
                        child: Text("Asian"),
                        value: "Asian"
                    ),
                    DropdownMenuItem(
                        child: Text("Continental"),
                        value: "Continental"
                    ),
                  ],
                    onChanged: (value) {
                      setState(() {
                        add.cuisineId = value;
                      });
                      if(value == "North Indian"){
                        setState(() {
                          selectedCuisineId = "1";
                        });
                        print(selectedCuisineId);
                      }else if(value == "South Indian"){
                        setState(() {
                          selectedCuisineId = "2";
                        });
                        print(selectedCuisineId);
                      }else if(value == "Gujarati"){
                        setState(() {
                          selectedCuisineId = "3";
                        });
                        print(selectedCuisineId);
                      }else if(value == "Bengali"){
                        setState(() {
                          selectedCuisineId = "4";
                        });
                        print(selectedCuisineId);
                      }else if(value == "Italian"){
                        setState(() {
                          selectedCuisineId = "5";
                        });
                        print(selectedCuisineId);
                      }else if(value == "Mexican"){
                        setState(() {
                          selectedCuisineId = "6";
                        });
                        print(selectedCuisineId);
                      }else if(value == "Desserts"){
                        setState(() {
                          selectedCuisineId = "7";
                        });
                        print(selectedCuisineId);
                      }else if(value == "Asian"){
                        setState(() {
                          selectedCuisineId = "8";
                        });
                        print(selectedCuisineId);
                      }else if(value == "Continental"){
                        setState(() {
                          selectedCuisineId = "9";
                        });
                        print(selectedCuisineId);
                      }
                    }),
              ),

               */
            ),
            ),
          
        ],
      ),
    );
  }

  Widget buildTypeField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Type ',
            style: GoogleFonts.nunitoSans(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 15,
            width: MediaQuery.of(context).size.width,
            child: Align(
              alignment: Alignment.center,
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                    elevation: 0,
                    value: add.itemType,
                    items: [
                      DropdownMenuItem(
                        child: Text("Breakfast"),
                        value: 'Breakfast',
                      ),
                      DropdownMenuItem(
                        child: Text("Lunch"),
                        value: "Lunch",
                      ),
                      DropdownMenuItem(
                          child: Text("Snacks"),
                          value: "Snacks"
                      ),
                      DropdownMenuItem(
                          child: Text("Dinner"),
                          value: "Dinner"
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        add.itemType = value;
                      });
                      if(value == "Breakfast"){
                        setState(() {
                          selectedItemType = "Breakfast";
                        });
                        print(selectedItemType);
                      }else if(value == "Lunch"){
                        setState(() {
                          selectedItemType = "Lunch";
                        });
                        print(selectedItemType);
                      }else if(value == "Snacks"){
                        setState(() {
                          selectedItemType = "Snacks";
                        });
                        print(selectedItemType);
                      }else if(value == "Dinner"){
                        setState(() {
                          selectedItemType = "Dinner";
                        });
                        print(selectedItemType);
                      }
                    }),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildCategoryField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Category ',
            style: GoogleFonts.nunitoSans(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Container(
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
                    value: add.itemCategory,
                    items: [
                      DropdownMenuItem(
                        child: Text("Veg"),
                        value: "Veg",
                      ),
                      DropdownMenuItem(
                        child: Text("Non-Veg"),
                        value: "Nonveg",
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        add.itemCategory = value;
                      });
                    }),
              ),
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
          Text(
            'Amount ',
            style: GoogleFonts.nunitoSans(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 2.2,
                height: MediaQuery.of(context).size.height / 17,
                child: TextFormField(
                  controller: add.addNewItemAmountNumController,
                  decoration: InputDecoration(
                    hintText: '',
                    hintStyle: GoogleFonts.nunitoSans(
                      fontSize: 15,fontWeight: FontWeight.w600,
                      color: Colors.grey[400]
                    ),
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
              ),
              Container(
                width: MediaQuery.of(context).size.width / 2.2,
                height: MediaQuery.of(context).size.height / 17,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                        elevation: 0,
                        value: add.itemQuantity,
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
                            add.itemQuantity = value;
                          });
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

  Widget buildPriceField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Price (in Rs.)',
            style: GoogleFonts.nunitoSans(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Container(
            height: MediaQuery.of(context).size.height / 15,
            child: TextFormField(
              controller: add.addNewItemPriceController,
              decoration: InputDecoration(
                hintText: 'Rs',
                hintStyle: GoogleFonts.nunitoSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.grey[400]
                ),
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

  Widget buildDescriptionField(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text('Description',style: GoogleFonts.nunitoSans(
            fontSize: 18,
            fontWeight: FontWeight.w600
          ),),
        ),
        SizedBox(height: 10,),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Container (
            height: MediaQuery.of(context).size.height / 8,
            child: TextFormField(
              controller: add.addNewItemDescriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 20,top: 20),
                labelStyle: TextStyle(color: Colors.black),
                hintText: 'Enter item description here, it can include ingredients / speciality / or any details of the item',
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
          ),
        ),
      ],
    );
  }

  Widget buildSaveAndCancelButton(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 10,right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: GestureDetector(
              onTap: (){
                if(add.addNewItemNameController.text.toString() == null || add.addNewItemNameController.text.toString() == "" || selectedCuisineId == null || selectedCuisineId == "null" ||
                    selectedItemType == null || selectedItemType == "null" || add.itemCategory.toString() == null || add.itemCategory.toString() == "null" || add.itemQuantity == null || add.itemQuantity == "null" ||
                    add.addNewItemAmountNumController.text.toString() == null || add.addNewItemAmountNumController.text.toString() == "" ||
                    add.addNewItemPriceController.text.toString() == null || add.addNewItemPriceController.text.toString() == "" ||
                    add.addNewItemDescriptionController.text.toString() == null || add.addNewItemDescriptionController.text.toString() == ""){
                  Fluttertoast.showToast(msg: "All fields are mandatory!", backgroundColor: Colors.black, textColor: Colors.white);
                }else{
                  print("else loop entered...");
                  prAddItem.show();
                  addNewItem(context);
                }
              },
              child: Container(
                height: MediaQuery.of(context).size.height/15,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.blue[700],
//                    boxShadow: [BoxShadow(
//                        color: Colors.black.withOpacity(0.5),
//                        blurRadius: 10
//                    )]
                ),
                child: Center(
                  child: Text('Next ->\nAdd Item Images',
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
          SizedBox(width: 20,),
          Flexible(
            child: Container(
              height: MediaQuery.of(context).size.height/15,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.grey[300],
//                  boxShadow: [BoxShadow(
//                      color: Colors.black.withOpacity(0.5),
//                      blurRadius: 10
//                  )]
              ),
              child: Center(
                child: Text('Cancel',style: GoogleFonts.nunitoSans(
                    fontWeight: FontWeight.bold,
                    fontSize: 18
                ),),
              ),
            ),
          )
        ],
      ),
    );
  }




  Widget buildNameField2(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Item Name',
            style: GoogleFonts.nunitoSans(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 15,
            child: TextFormField(
              controller: add.addNewItemNameController,
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.black),
                hintText: 'Enter item name here'
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildCuisineField2(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cuisine ',
            style: GoogleFonts.nunitoSans(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: Align(
              alignment: Alignment.center,
              child: SearchableDropdown.single(
                  items: cuisineNames == null ? []: cuisineNames.map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(
                        value,
                        textScaleFactor: 1,
                      ),
                    );
                  }).toList(),
                  value: "Select cuisine",
                  hint: "Select cuisine",
                  searchHint: "Search cuisine",
                  closeButton: SizedBox.shrink(),
                  onChanged: (value) {
                    setState(() {
                      int idx = cuisineNames.indexOf(value);
                      selectedCuisineId = cuisineIds[idx].toString();
                    });
                    print(selectedCuisineId);
                  },
                  isExpanded: true
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTypeField2(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Type ',
            style: GoogleFonts.nunitoSans(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: Align(
              alignment: Alignment.center,
              child: SearchableDropdown.single(
                  items: ['Breakfast', 'Lunch', 'Snacks', 'Dinner'].map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(
                        value,
                        textScaleFactor: 1,
                      ),
                    );
                  }).toList(),
                  value: "Select category",
                  hint: "Select category",
                  searchHint: "Select category",
                  closeButton: SizedBox.shrink(),
                  onChanged: (value) {
                    setState(() {
                      add.itemType = value;
                    });
                    if(value == "Breakfast"){
                      setState(() {
                        selectedItemType = "Breakfast";
                      });
                      print(selectedItemType);
                    }else if(value == "Lunch"){
                      setState(() {
                        selectedItemType = "Lunch";
                      });
                      print(selectedItemType);
                    }else if(value == "Snacks"){
                      setState(() {
                        selectedItemType = "Snacks";
                      });
                      print(selectedItemType);
                    }else if(value == "Dinner"){
                      setState(() {
                        selectedItemType = "Dinner";
                      });
                      print(selectedItemType);
                    }
                  },
                  isExpanded: true
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCategoryField2(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Category ',
            style: GoogleFonts.nunitoSans(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: Align(
              alignment: Alignment.center,
              child: SearchableDropdown.single(
                  items: ['Veg', 'Nonveg'].map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(
                        value,
                        textScaleFactor: 1,
                      ),
                    );
                  }).toList(),
                  value: "Select category",
                  hint: "Select category",
                  searchHint: "Select category",
                  closeButton: SizedBox.shrink(),
                  onChanged: (value) {
                    setState(() {
                      add.itemCategory = value;
                    });
                    print(add.itemCategory);
                  },
                  isExpanded: true
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAmountField2(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Amount ',
            style: GoogleFonts.nunitoSans(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                child: Container(
                  height: MediaQuery.of(context).size.height / 17,
                  child: TextFormField(
                    controller: add.addNewItemAmountNumController,
                    decoration: InputDecoration(
                      hintText: '',
                      hintStyle: GoogleFonts.nunitoSans(
                          fontSize: 15,fontWeight: FontWeight.w600,
                          color: Colors.grey[400]
                      ),
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
                ),
              ),
              SizedBox(width: 20,),
              Flexible(
                child: Container(
                  height: MediaQuery.of(context).size.height / 17,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                          elevation: 0,
                          value: add.itemQuantity,
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
                              add.itemQuantity = value;
                            });
                          }),
                    ),
                  ),
                ),
              )

            ],
          ),
        ],
      ),
    );
  }

  Widget buildPriceField2(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Price (in Rs.)',
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
              controller: add.addNewItemPriceController,
              decoration: InputDecoration(
                hintText: 'Enter item price in rupees',
                labelStyle: TextStyle(color: Colors.black),
              ),
            ),
          )
        ],
      ),
    );
  }

}


//['Breakfast', 'Lunch', 'Snacks', 'Dinner']