import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:vendor_dabbawala/UI/manage_subitems_page.dart';
import 'package:vendor_dabbawala/UI/subitems_page.dart';
import 'addons_page.dart';
import 'data/login_data.dart' as login;
import 'package:vendor_dabbawala/UI/data/add_new_item_data.dart' as add;
import 'package:http/http.dart' as http;
import 'package:vendor_dabbawala/UI/data/globals_data.dart' as globals;
import 'dart:convert';

import 'manage_item_images.dart';

var selectedCuisineId;
var selectedItemType;
ProgressDialog prAddItem;
File imageOne;
File imageTwo;
File imageThree;
File imageOneUpload;
File imageTwoUpload;
File imageThreeUpload;

var baseImageUniversal1;
var fileNameUniversal1;
var baseImageUniversal2;
var fileNameUniversal2;
var baseImageUniversal3;
var fileNameUniversal3;

List<String> cuisineIds;
List<String> cuisineNames;
List<String> cuisineNames2;

bool changeCuisine = false;
bool changeType = false;
bool changeCategory = false;
bool changeAmountQty = false;

var selectedCusinineName;

List<int> itemTypesss = [];

List<int> selectedItemsTypes = [];

int itemTypeLength;
var prevTypeList;
var newTypeList;

class AddItemPageForManage extends StatefulWidget {
  final id;
  final name;
  final cuisine;
  final amount;
  final price;
  final desc;
  final type;
  final category;
  final blsd;
  AddItemPageForManage(this.id, this.name, this.cuisine, this.amount, this.price, this.desc, this.type, this.category, this.blsd) : super();
  @override
  _AddItemPageForManageState createState() => _AddItemPageForManageState();
}

class _AddItemPageForManageState extends State<AddItemPageForManage> {

  Future<String> addNewItem(context) async {

    print("itemId"+widget.id.toString());
    print("myUserID"+login.storedUserId.toString());
    print("itemName"+add.addNewItemNameController.text.toString());
    print("cuisineID"+selectedCuisineId);
    print("selectedType"+selectedItemType);
    print("selectedCategory"+add.itemCategory.toString());
    print("amountAndQuantity"+add.addNewItemAmountNumController.text + add.itemQuantity.toString());
    print("itemPrice"+add.addNewItemPriceController.text,);
    print("description"+add.addNewItemDescriptionController.text.toString());

    prAddItem.hide();

    String url = globals.apiUrl + "edititems.php";

    http.post(url, body: {

      "itemID" : widget.id.toString(),
      "vendorID": login.storedUserId.toString(),
      "itemname" : add.addNewItemNameController.text.toString(),
      "cuisineID": selectedCuisineId.toString(),
      "itemtype": selectedItemType.toString(),//selectedItemsTypes.toList().toString(),//selectedItemType.toString(), [Breakfast, Snacks]
      "itemcategory":add.itemCategory.toString(),
      "itemamount": add.addNewItemAmountNumController.text.toString() + add.itemQuantity.toString(),
      "itemprice": add.addNewItemPriceController.text.toString(),
      "itemdescription": add.addNewItemDescriptionController.text.toString(),

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

          login.prlogin.hide().whenComplete((){

            Fluttertoast.showToast(msg: "Saved", backgroundColor: Colors.black, textColor: Colors.white);
            print(add.addNewItemMessage);
            Navigator.of(context).pop();

          });
        }else{

          Fluttertoast.showToast(msg: "Some error occured!", backgroundColor: Colors.black, textColor: Colors.white);

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
            cuisineNames2 = List.generate(responseArrayGetCusines['data'].length, (index) => responseArrayGetCusines['data'][index]['cuisineID'].toString()+"-"+responseArrayGetCusines['data'][index]['cuisineName'].toString());
          });
          print(cuisineIds.toList());
          print(cuisineNames.toList());

          cuisineNames2.forEach((element) {
            int idx = cuisineNames2.indexOf(element);
            if(cuisineNames2[idx].contains(widget.cuisine)){
              print("true");
              setState(() {
                var tmp = cuisineNames2[idx].toString();
                var tmp2 = tmp.split('-');
                print(tmp2);
                selectedCuisineId = tmp2[0].toString();
              });
              print("selected Cuisine ID : "+selectedCuisineId);
            }else{
              print("false");
            }
          });

//          Future.delayed(Duration(seconds: 3), () async {
//            setState(() {
//              int idx = cuisineNames.toList().indexOf('5');
//              selectedCuisineId = cuisineIds[idx];
//              print(idx);
//              print(selectedCuisineId);
//            });
//          });

        }else{
          //prGetItems.hide();
          setState(() {

          });

        }
      }
    });

  }

  Future getImageOneCamera() async{
    // ignore: deprecated_member_use
    final image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      imageOne = image;
      imageOneUpload = File(image.path);
      Navigator.of(context).pop();
    });
  }
  Future getImageOneGallery() async{
    // ignore: deprecated_member_use
    final img = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      imageOne = img;
      imageOneUpload = File(img.path);
      Navigator.of(context).pop();
    });
  }

  Future getImageTwoCamera() async{
    // ignore: deprecated_member_use
    final image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      imageTwo = image;
      imageTwoUpload = File(image.path);
      Navigator.of(context).pop();
    });
  }
  Future getImageTwoGallery() async{
    // ignore: deprecated_member_use
    final img = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      imageTwo = img;
      imageTwoUpload = File(img.path);
      Navigator.of(context).pop();
    });
  }

  Future getImageThreeCamera() async{
    // ignore: deprecated_member_use
    final image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      imageThree = image;
      imageThreeUpload = File(image.path);
      Navigator.of(context).pop();
    });
  }
  Future getImageThreeGallery() async{
    // ignore: deprecated_member_use
    final img = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      imageThree = img;
      imageThreeUpload = File(img.path);
      Navigator.of(context).pop();
    });
  }

  Future<String> getItemIdsByMasterId(context) async {

    String url = globals.apiUrl + "getitemsbymasterid.php";

    http.post(url, body: {

      "masterID" : widget.id,

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

            itemTypesss = List.generate(responseArrayGetItemsByMasterId['data'].length, (index) => responseArrayGetItemsByMasterId['data'][index]['itemType'] == "Breakfast" ? 0 : responseArrayGetItemsByMasterId['data'][index]['itemType'] == "Lunch" ? 1 : responseArrayGetItemsByMasterId['data'][index]['itemType'] == "Snacks" ? 2 : 3);
            prevTypeList = itemTypesss;

            itemTypeLength = itemTypesss.length;

          });
          print(itemTypesss);
          print(prevTypeList);
          print("itemTypeLength : "+itemTypeLength.toString());

        }else{
          //prGetItems.hide();
          setState(() {
            itemTypesss = null;
          });

        }
      }
    });

  }

  int _value = 1;

  void _openEndDrawer() {
    login.scaffoldKey.currentState.openEndDrawer();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print("widget.type ===== " + widget.type.toString());

    getItemIdsByMasterId(context);

    getCuisines(context);
    setState(() {

      itemTypesss = [];
      selectedCuisineId = null;

      changeCuisine = false;
      changeType = false;
      changeCategory = false;
      changeAmountQty = false;

      selectedCusinineName = widget.cuisine;
      add.itemType = widget.blsd;
      selectedItemType = widget.blsd;
      add.itemCategory = widget.category;

      if(widget.amount.toString().contains('gms')){
        print("gms : true");
        setState(() {
          add.itemQuantity = widget.amount.toString().replaceAll('gms', '');
        });
        //add.addNewItemAmountNumController = TextEditingController(text: widget.amount.toString().replaceAll('gms', ''));
      }else if(widget.amount.toString().contains('ml')){
        setState(() {
          add.itemQuantity = widget.amount.toString().replaceAll('ml', '');
        });
        //add.addNewItemAmountNumController = TextEditingController(text: widget.amount.toString().replaceAll('ml', ''));
      }else if(widget.amount.toString().contains('pcs')){
        setState(() {
          add.itemQuantity = widget.amount.toString().replaceAll('pcs', '');
        });
        //add.addNewItemAmountNumController = TextEditingController(text: widget.amount.toString().replaceAll('pcs', ''));
      }
      if(widget.amount.toString().contains('gms')){
        add.itemQuantity = "gms";
      }else if(widget.amount.toString().contains('pcs')){
        add.itemQuantity = "pcs";
      }else{
        add.itemQuantity = "ml";
      }

    });
    imageOne = null;
    imageTwo = null;
    imageThree = null;
    if(widget.amount.toString().contains('gms')){
      print("gms : true");
      setState(() {
        widget.amount.toString().replaceAll('gms', '');
      });
      add.addNewItemAmountNumController = TextEditingController(text: widget.amount.toString().replaceAll('gms', ''));
    }else if(widget.amount.toString().contains('ml')){
      setState(() {
        widget.amount.toString().replaceAll('ml', '');
      });
      add.addNewItemAmountNumController = TextEditingController(text: widget.amount.toString().replaceAll('ml', ''));
    }else if(widget.amount.toString().contains('pcs')){
      setState(() {
        widget.amount.toString().replaceAll('pcs', '');
      });
      add.addNewItemAmountNumController = TextEditingController(text: widget.amount.toString().replaceAll('pcs', ''));
    }

    add.addNewItemNameController = TextEditingController(text: widget.name.toString());
    add.addNewItemPriceController = TextEditingController(text: widget.price.toString());
    add.addNewItemDescriptionController = TextEditingController(text: widget.desc.toString());

    print(widget.id);
    print(widget.name);
    print(widget.cuisine);
    print(widget.amount);
    print(widget.price);
    print(widget.desc);
    print(widget.type);

//    if(add.itemType.toString() == [0].toString()){
//      print("trueee");
//      setState(() {
//        selectedItemsTypes = [0];
//      });
//    }else if(add.itemType.toString() == [0,1].toString()){
//      print("trueee");
//      setState(() {
//        selectedItemsTypes = [0,1];
//      });
//    }else if(add.itemType.toString() == [0,1,2].toString()){
//      print("trueee");
//      setState(() {
//        selectedItemsTypes = [0,1,2];
//      });
//    }else if(add.itemType.toString() == [0,1,2,3].toString()){
//      print("trueee");
//      setState(() {
//        selectedItemsTypes = [0,1,2,3];
//      });
//    } else{
//      print("trueee");
//      setState(() {
//        selectedItemsTypes = [0,1,2,3];
//      });
//    }

  }

  @override
  Widget build(BuildContext context) {
    prAddItem = ProgressDialog(context);
    return Scaffold(
      key:login.scaffoldKey1,
      endDrawer: buildAppDrawer(context),
      appBar: buildAppBar(context),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: add.formKey,
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5,),
                SizedBox(height: 10,),
                //buildSKUNo(context),
                buildNameField(context),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 90,
                ),
                buildCuisineField(context),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 90,
                ),
                buildTypeField2(context),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 90,
                ),
                buildCategoryField2(context),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 90,
                ),
                buildAmountField(context),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 90,
                ),
                buildPriceField(context),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 90,
                ),
                buildDescriptionField(context),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 50,
                ),
                buildSaveAndCancelButton(context),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 50,
                ),
              ],
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
        'Manage Item Menu',textScaleFactor: 1,
        style: GoogleFonts.nunitoSans(
            color: Colors.blue[700], fontSize: 20, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
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

    );
  }

  Widget buildSKUNo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        children: [
          Text(
            'SKU No - ',textScaleFactor: 1,
            style: GoogleFonts.nunitoSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 50),
          Container(
            height: 40,
            child: Center(
              child: Text(
                'DAB0342',textScaleFactor: 1,
                style: GoogleFonts.nunitoSans(
                    fontSize: 14, fontWeight: FontWeight.w600),
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
            'Item Name ',textScaleFactor: 1,
            style: GoogleFonts.nunitoSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 15,
            child: TextFormField(
              controller: add.addNewItemNameController,
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.black),
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
          Container(
              child: Align(
                alignment: Alignment.center,
                child: SearchableDropdown.single(
                    items: cuisineNames == null ? []: cuisineNames.map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(
                          value.toString(),
                          textScaleFactor: 1,
                        ),
                      );
                    }).toList(),
                    value: "Search cuisine...",
                    hint: widget.cuisine.toString(),
                    style: TextStyle(color: Colors.black),
                    searchHint: "Search cuisine",
                    doneButton: "Close",
                    closeButton: SizedBox.shrink(),
                    onChanged: (value) {
                      setState(() {
                        int idx = cuisineNames.indexOf(value);
                        selectedCuisineId = cuisineIds[idx];
                        selectedCusinineName = value.toString().substring(1);
                      });
                      print(selectedCuisineId);
                      print(selectedCusinineName);
                    },
                    isExpanded: true
                ),
              ),
          ),
        ],
      ),
    );
  }

  Widget buildTypeField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Type ',
            style: GoogleFonts.nunitoSans(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 2.6,
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
                    value: selectedItemType,//add.itemType.toString(),
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
              child: SearchableDropdown.multiple(
                items: ['Breakfast', 'Lunch', 'Snacks', 'Dinner'].map((String value) {
                  return new DropdownMenuItem<String>(
                    value: value,
                    child: new Text(
                      value,
                      textScaleFactor: 1,
                    ),
                  );
                }).toList(),
                selectedItems: itemTypesss,
                hint: "Select Item Type",
                searchHint: "",
                doneButton: "Close",
                closeButton: SizedBox.shrink(),
                onChanged: (value) {
                  setState(() {
                    itemTypesss = itemTypesss.toList();
                    itemTypesss = value;
                  });

                  if(itemTypesss.length > itemTypeLength){

                    //new item types added
                    print("new item types added");   // [0,1]->[0,1,2] OR [0,1]->[0,1,2,3]   OR [0,1]->[1,2,3] OR [0,1]->[1,2,3]
                    newTypeList = itemTypesss.where((element) => !prevTypeList.contains(element));

                  }else if(itemTypesss.length < itemTypeLength){

                    //itemTypes removed
                    print("itemTypes removed");  // [0,1]->[0] OR [0,1]->[1]
                    newTypeList = prevTypeList.where((element) => !itemTypesss.contains(element));

                  }else{

                    if(itemTypesss.length == itemTypeLength){

                      if(prevTypeList == itemTypesss){

                        //No Change
                        print("Item Type Shifted"); // [0]->[1] OR [1]->[0] OR [0,1]->[2,3] [0,1]->[0,3] OR ANYTHING.....   [Breakfast, Lunch] -> [Breakfast, Snacks, Dinner]

                      }else{

                        //Item Type removed from one and inserted into anothet (i.e shifted from Breakfast/Lunch to Snacks/Dinner)
                        print("No Change");// [0,1] -> [0,1]

                      }

                    }

                  }

                },
                dialogBox: false,
                isExpanded: true,
                menuConstraints: BoxConstraints.tight(Size.fromHeight(350)),
              ),
            ),
          ),
        ],
      ),
    );
  }


  // [breakfast, lunch] -> [0, 1, 1, 0]

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
                  //value: add.itemCategory,
                  hint: add.itemCategory,
                  searchHint: "Select category",
                  closeButton: SizedBox.shrink(),
                  onChanged: (value) {

                    print("valueeee   " + value.toString());

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

  Widget buildCategoryField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Category ',textScaleFactor: 1,
            style: GoogleFonts.nunitoSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Container(
            height: MediaQuery.of(context).size.height / 15,
            child: Align(
              alignment: Alignment.center,
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                    elevation: 0,
                    value: add.itemCategory,
                    items: [
                      DropdownMenuItem(
                        child: Text("Veg",textScaleFactor: 1,),
                        value: "Veg",
                      ),
                      DropdownMenuItem(
                        child: Text("Non-Veg",textScaleFactor: 1,),
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
            'Amount ',textScaleFactor: 1,
            style: GoogleFonts.nunitoSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              child: Text("gms",textScaleFactor: 1,),
                              value: 'gms',
                            ),
                            DropdownMenuItem(
                              child: Text("ml",textScaleFactor: 1,),
                              value: 'ml',
                            ),
                            DropdownMenuItem(
                              child: Text("pcs",textScaleFactor: 1,),
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
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
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
                labelStyle: TextStyle(color: Colors.black),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildPictureArea(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'Picture',textScaleFactor: 1,
            style: GoogleFonts.nunitoSans(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          SizedBox(width: MediaQuery.of(context).size.width/10,),
          GestureDetector(
            onTap: slideSheet1,
            child: imageOne == null ? Container(
                width: MediaQuery.of(context).size.width / 6,
                height: MediaQuery.of(context).size.height / 11.5,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: Colors.black)
                ),
                child:  Icon(Icons.add,size: 40,color: Colors.grey[400],)
            ) : Stack(
              children: [
                Container(
                    width: MediaQuery.of(context).size.width / 6,
                    height: MediaQuery.of(context).size.height / 11.5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: Colors.black)
                    ),
                    child : Image.file(imageOne)
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 55),
                  child: Container(
                    width: MediaQuery.of(context).size.width/20,
                    height: MediaQuery.of(context).size.height/40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      color: Colors.red[600]
                    ),
                    child: Center(
                      child: Text('-',style: GoogleFonts.nunitoSans(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10
                      ),),
                    ),
                  ),
                )
              ],
            )
          ),
          SizedBox(width: MediaQuery.of(context).size.width/20,),
          GestureDetector(
              onTap: slideSheet2,
              child: imageTwo == null ? Container(
                  width: MediaQuery.of(context).size.width / 6,
                  height: MediaQuery.of(context).size.height / 11.5,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      border: Border.all(color: Colors.black)
                  ),
                  child:  Icon(Icons.add,size: 40,color: Colors.grey[400],)
              ) : Stack(
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width / 6,
                      height: MediaQuery.of(context).size.height / 11.5,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: Colors.black)
                      ),
                      child : Image.file(imageTwo)
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 55),
                    child: Container(
                      width: MediaQuery.of(context).size.width/20,
                      height: MediaQuery.of(context).size.height/40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          color: Colors.red[600]
                      ),
                      child: Center(
                        child: Text('-',style: GoogleFonts.nunitoSans(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10
                        ),),
                      ),
                    ),
                  )
                ],
              )
          ),
          SizedBox(width: MediaQuery.of(context).size.width/20,),
          GestureDetector(
              onTap: slideSheet3,
              child: imageThree == null ? Container(
                  width: MediaQuery.of(context).size.width / 6,
                  height: MediaQuery.of(context).size.height / 11.5,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      border: Border.all(color: Colors.black)
                  ),
                  child:  Icon(Icons.add,size: 40,color: Colors.grey[400],)
              ) : Stack(
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width / 6,
                      height: MediaQuery.of(context).size.height / 11.5,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: Colors.black)
                      ),
                      child : Image.file(imageThree)
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 55),
                    child: Container(
                      width: MediaQuery.of(context).size.width/20,
                      height: MediaQuery.of(context).size.height/40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          color: Colors.red[600]
                      ),
                      child: Center(
                        child: Text('-',style: GoogleFonts.nunitoSans(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10
                        ),),
                      ),
                    ),
                  )
                ],
              )
          ),
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
          child: Text('Description',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
            fontSize: 14,
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

  Widget buildAdonsAndSubitemButton(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 10,right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: (){

            },
            child: Container(
              width: MediaQuery.of(context).size.width/2.2,
              height: MediaQuery.of(context).size.height/15,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.blue[700],
                  boxShadow: [BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 10
                  )]
              ),
              child: Center(
                child: Text('Add-ons',style: GoogleFonts.nunitoSans(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white
                ),),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (c, a1, a2) =>SubItemsPage(),
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
                  boxShadow: [BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 10
                  )]
              ),
              child: Center(
                child: Text('Sub Items',style: GoogleFonts.nunitoSans(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white
                ),),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSaveAndCancelButton(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 10,right: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: GestureDetector(
                  onTap: (){
                    if(add.addNewItemNameController.text.toString() == null || add.addNewItemNameController.text.toString() == "" || selectedCuisineId == null || selectedCuisineId == "null" ||
                        selectedItemType == null || selectedItemType == "null" || add.itemCategory.toString() == null || add.itemCategory.toString() == "null" ||
                        add.addNewItemAmountNumController.text.toString() == null || add.addNewItemAmountNumController.text.toString() == "" || add.itemQuantity == null || add.itemQuantity == "null" ||
                        add.addNewItemPriceController.text.toString() == null || add.addNewItemPriceController.text.toString() == "" ||
                        add.addNewItemDescriptionController.text.toString() == null || add.addNewItemDescriptionController.text.toString() == ""){
                      Fluttertoast.showToast(msg: "All fields are mandatory!", backgroundColor: Colors.black, textColor: Colors.white);
                    }else{
                      prAddItem.show();
                      addNewItem(context);
//                    print("else loop entered...");
//                    prAddItem.show();
//                    addNewItem(context);
                    }
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height/15,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.blue[700],
                        boxShadow: [BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 10
                        )]
                    ),
                    child: Center(
                      child: Text('Save',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white
                      ),),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 15,),
              Flexible(
                child: Container(
                  height: MediaQuery.of(context).size.height/15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.grey[300],
                      boxShadow: [BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 10
                      )]
                  ),
                  child: Center(
                    child: Text('Cancel',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                    ),),
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
                SizedBox(height: 70,),
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

  void slideSheet1() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              color: Color(0xFF737373),
              child: Container(
                height: MediaQuery.of(context).size.height /4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    SizedBox(height:MediaQuery.of(context).size.height/35),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: getImageOneCamera,
                          child: Column(
                            children: [
                              Icon(Icons.camera,color: Colors.deepPurple[700],size: 40,),
                              Text('Camera',style: GoogleFonts.nunitoSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600
                              ),),

                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: getImageOneGallery,
                          child: Column(
                            children: [
                              Icon(Icons.photo,color: Colors.deepPurple[700],size: 40,),
                              Text('Gallery',style: GoogleFonts.nunitoSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600
                              ),)


                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height/11,),

                    Row(
                      children: [
                        SizedBox(width: MediaQuery.of(context).size.width/1.8,),

                        Text('Just Once',style: GoogleFonts.nunitoSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w600
                        ),),
                        SizedBox(width: MediaQuery.of(context).size.width/15,),
                        Text('Always',style: GoogleFonts.nunitoSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w600
                        ),)
                      ],
                    ),
                    SizedBox(height: 20,)
                  ],
                ),
              ),
            ),
          );
        });
  }

  void slideSheet2() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              color: Color(0xFF737373),
              child: Container(
                height: MediaQuery.of(context).size.height /4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    SizedBox(height:MediaQuery.of(context).size.height/35),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: getImageTwoCamera,
                          child: Column(
                            children: [
                              Icon(Icons.camera,color: Colors.deepPurple[700],size: 40,),
                              Text('Camera',style: GoogleFonts.nunitoSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600
                              ),),

                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: getImageTwoGallery,
                          child: Column(
                            children: [
                              Icon(Icons.photo,color: Colors.deepPurple[700],size: 40,),
                              Text('Gallery',style: GoogleFonts.nunitoSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600
                              ),)


                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height/11,),

                    Row(
                      children: [
                        SizedBox(width: MediaQuery.of(context).size.width/1.8,),

                        Text('Just Once',style: GoogleFonts.nunitoSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w600
                        ),),
                        SizedBox(width: MediaQuery.of(context).size.width/15,),
                        Text('Always',style: GoogleFonts.nunitoSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w600
                        ),)
                      ],
                    ),
                    SizedBox(height: 20,)
                  ],
                ),
              ),
            ),
          );
        });
  }

  void slideSheet3() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              color: Color(0xFF737373),
              child: Container(
                height: MediaQuery.of(context).size.height /4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    SizedBox(height:MediaQuery.of(context).size.height/35),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: getImageThreeCamera,
                          child: Column(
                            children: [
                              Icon(Icons.camera,color: Colors.deepPurple[700],size: 40,),
                              Text('Camera',style: GoogleFonts.nunitoSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600
                              ),),

                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: getImageThreeGallery,
                          child: Column(
                            children: [
                              Icon(Icons.photo,color: Colors.deepPurple[700],size: 40,),
                              Text('Gallery',style: GoogleFonts.nunitoSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600
                              ),)


                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height/11,),

                    Row(
                      children: [
                        SizedBox(width: MediaQuery.of(context).size.width/1.8,),

                        Text('Just Once',style: GoogleFonts.nunitoSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w600
                        ),),
                        SizedBox(width: MediaQuery.of(context).size.width/15,),
                        Text('Always',style: GoogleFonts.nunitoSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w600
                        ),)
                      ],
                    ),
                    SizedBox(height: 20,)
                  ],
                ),
              ),
            ),
          );
        });
  }

}
