import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vendor_dabbawala/UI/Shreyas/Utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:vendor_dabbawala/UI/data/globals_data.dart' as globals;
import 'dart:convert';
import 'package:vendor_dabbawala/UI/data/login_data.dart' as login;
import 'package:vendor_dabbawala/UI/data/manage_menu_data.dart';
import 'package:vendor_dabbawala/UI/manage_menu_page.dart';

var selectedItemMasterId;

var itemIdssss;
var itemTypesss;

class VendorItemsList extends StatefulWidget {
  @override
  _VendorItemsListState createState() => _VendorItemsListState();
}

class _VendorItemsListState extends State<VendorItemsList> {

  Future<String> getItemList(context) async {

    String url = globals.apiUrl + "getallitems.php";

    http.post(url, body: {

      "vendorID" : login.storedUserId.toString(),

    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");

      }
      var responseArrayGetItems = jsonDecode(response.body);
      print(responseArrayGetItems);

      var responseArrayGetItemsMsg = responseArrayGetItems['message'].toString();
      print(responseArrayGetItemsMsg);

      if(statusCode == 200){
        if(responseArrayGetItemsMsg == "Item Found"){
          //prGetItems.hide();
          setState(() {
            itemId = List.generate(responseArrayGetItems['data'].length, (index) => responseArrayGetItems['data'][index]['itemMasterid']);
            itemName = List.generate(responseArrayGetItems['data'].length, (index) => responseArrayGetItems['data'][index]['itemName']);
            itemNameWithId = List.generate(responseArrayGetItems['data'].length, (index) => responseArrayGetItems['data'][index]['itemID']+responseArrayGetItems['data'][index]['itemName']);
            itemPrice = List.generate(responseArrayGetItems['data'].length, (index) => responseArrayGetItems['data'][index]['itemPrice']);
            image = List.generate(responseArrayGetItems['data'].length, (index) => responseArrayGetItems['data'][index]['imageName']);
            itemDescription = List.generate(responseArrayGetItems['data'].length, (index) => responseArrayGetItems['data'][index]['itemDescription']);
            itemCuisine = List.generate(responseArrayGetItems['data'].length, (index) => responseArrayGetItems['data'][index]['cuisineName']);
            itemType = List.generate(responseArrayGetItems['data'].length, (index) => responseArrayGetItems['data'][index]['itemCategory']);
            itemAmount = List.generate(responseArrayGetItems['data'].length, (index) => responseArrayGetItems['data'][index]['itemAmount']);
            itemStatuses = List.generate(responseArrayGetItems['data'].length, (index) => responseArrayGetItems['data'][index]['itemStatus'].toString());
            itemCategory = List.generate(responseArrayGetItems['data'].length, (index) => responseArrayGetItems['data'][index]['itemCategory'].toString());
            itemBLSD = List.generate(responseArrayGetItems['data'].length, (index) => responseArrayGetItems['data'][index]['itemType'].toString());
          });
          print(itemId);
          print(itemName);
          print(itemNameWithId);
          print(itemPrice);
          print(image);
          print(itemDescription);
          print(itemCuisine);
          print(itemType);
          print(itemAmount);
          print(itemStatuses);
          print(itemCategory);
          print(itemBLSD);

        }else{
          //prGetItems.hide();
          setState(() {
            itemName = null;
          });

        }
      }
    });

  }

  Future<String> getItemIdsByMasterId(context) async {

    String url = globals.apiUrl + "getitemsbymasterid.php";

    http.post(url, body: {

      "masterID" : selectedItemMasterId,

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
            itemTypesss = List.generate(responseArrayGetItemsByMasterId['data'].length, (index) => responseArrayGetItemsByMasterId['data'][index]['itemType']);
          });
          print(itemIdssss);
          print(itemTypesss);

        }else{
          //prGetItems.hide();
          setState(() {
            itemIdssss = null;
          });

        }
      }
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedItemMasterId = null;
    selectedItemIdForEditingToPass = null;
    reportList = [
      "Breakfast",
      "Lunch",
      "Snacks",
      "Dinner",
    ];
    setState(() {
      itemName = "1";
    });
    getItemList(context);
  }

  @override
  Widget build(BuildContext context) {
    return itemName == "1" ? Center(
      child: CircularProgressIndicator(),
    ) : itemName == null ? buildNoItemsContainer(context) : buildItemsContainer(context);
  }

  buildNoItemsContainer(BuildContext context){
    return Center(
      child: Text("Add a new item and start selling",textScaleFactor: 1,
        style: GoogleFonts.nunitoSans(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  buildItemsContainer(BuildContext context){
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height/1,
        padding: EdgeInsets.only(left: 10,right: 10),
        child: showSearchedItem == true ?
        buildSearchedItemContainer(context) :
        buildAllItemsContainer(context));
  }

  buildSearchedItemContainer(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(top:5, bottom: 10),
      child: Stack(
        children: [Container(
          padding: EdgeInsets.only(left: 10,right: 10),
          width: MediaQuery.of(context).size.width/1,
          height: MediaQuery.of(context).size.height/5,
        ),
          Container(
            width: MediaQuery.of(context).size.width/4,
            height: MediaQuery.of(context).size.height/6.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Image.network("https://admin.dabbawala.ml/"+image[int.parse(selectedItemIdForSearch)].toString(),scale: 2,fit: BoxFit.fill,),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 115,top: 10),
            child: Text(itemName[int.parse(selectedItemIdForSearch)],textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 12
            ),),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 115, top: 90),
            child: Text(itemDescription[int.parse(selectedItemIdForSearch)],
              textScaleFactor: 1,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: GoogleFonts.nunitoSans(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w600
              ),),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 115,top: 50),
            child: Text(itemAmount[int.parse(selectedItemIdForSearch)],textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 12
            ),),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 115,top: 70),
            child: Text('Price - Rs '+itemPrice[int.parse(selectedItemIdForSearch)],textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w600
            ),),
          ),
          Padding(
              padding: const EdgeInsets.only(left: 115,top: 30),
              child: Text(itemCuisine[int.parse(selectedItemIdForSearch)],textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 12
              ),)
          ),
          Padding(
            padding: const EdgeInsets.only(left:280,top:10),
            child: Text('SKU No - DAB0342',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 12
            ),),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 290,top: 50),
            child: Text('Type - '+itemType[int.parse(selectedItemIdForSearch)],textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 12
            ),),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 140),
            child: GestureDetector(
              onTap: (){
                Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (c, a1, a2) =>ManageMenuPage(itemId[int.parse(selectedItemIdForSearch)],itemName[int.parse(selectedItemIdForSearch)],itemCuisine[int.parse(selectedItemIdForSearch)],itemAmount[int.parse(selectedItemIdForSearch)],itemPrice[int.parse(selectedItemIdForSearch)],itemDescription[int.parse(selectedItemIdForSearch)],itemType[int.parse(selectedItemIdForSearch)], itemStatuses[int.parse(selectedItemIdForSearch)],itemCategory[selectedItemIdForSearch], itemBLSD[selectedItemIdForSearch]),
                      transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                      transitionDuration: Duration(milliseconds: 300),
                    )
                ).whenComplete((){
                  getItemList(context);
                });
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height/20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Colors.grey[100],
                  boxShadow: [BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 1,
                  )],
                ),
                child: Center(
                  child: Text('Manage Details, AdOns, etc',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                      color: Colors.black,
                      fontSize: 16,
                      letterSpacing: 1
                  ),),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildAllItemsContainer(BuildContext context){
    return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: itemName == null ? 0 : itemName.length,
        itemBuilder: (context, index) => index>0 && (itemName.reversed.toList()[index].toString() == itemName.reversed.toList()[index-1].toString()) ? Container() :
            Padding(
              padding: const EdgeInsets.only(top:5, bottom: 10),
              child: Stack(
                children: [Container(
                  padding: EdgeInsets.only(left: 10,right: 10),
                  width: MediaQuery.of(context).size.width/1,
                  height: MediaQuery.of(context).size.height/5,
                ),
                  Container(
                    width: MediaQuery.of(context).size.width/4,
                    height: MediaQuery.of(context).size.height/6.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Image.network("https://admin.dabbawala.ml/"+image.reversed.toList()[index].toString(),scale: 2,fit: BoxFit.fill,),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 115,top: 10),
                    child: Text(itemName.reversed.toList()[index],textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 12
                    ),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 115, top: 90),
                    child: Text(itemDescription.reversed.toList()[index],
                      textScaleFactor: 1,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: GoogleFonts.nunitoSans(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w600
                      ),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 115,top: 50),
                    child: Text(itemAmount.reversed.toList()[index],textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 12
                    ),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 115,top: 70),
                    child: Text('Price - Rs '+itemPrice.reversed.toList()[index],textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w600
                    ),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 115,top: 30),
                    child: Text(itemCuisine.reversed.toList()[index],textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 12
                    ),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:280,top:10),
                    child: Text('SKU No - SKU-'+itemId.reversed.toList()[index],textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 12
                    ),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 280,top: 60),
                    child: Text('Type - '+itemType.reversed.toList()[index],textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 12
                    ),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 140),
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          selectedItemMasterId = itemId.reversed.toList()[index].toString();
                        });
                        print(selectedItemMasterId);
//                        getItemIdsByMasterId(context);
//                        _showReportDialog();
                        Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (c, a1, a2) =>ManageMenuPage(itemId.reversed.toList()[index],itemName.reversed.toList()[index],itemCuisine.reversed.toList()[index],itemAmount.reversed.toList()[index],itemPrice.reversed.toList()[index],itemDescription.reversed.toList()[index],itemType.reversed.toList()[index],itemStatuses.reversed.toList()[index],itemCategory.reversed.toList()[index],itemBLSD.reversed.toList()[index]),
                              transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                              transitionDuration: Duration(milliseconds: 300),
                            )
                        ).whenComplete((){
                          getItemList(context);
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height/20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: Colors.grey[100],
                          boxShadow: [BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 1,
                          )],
                        ),
                        child: Center(
                          child: Text('Manage Details, AdOns, etc',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                              color: Colors.black,
                              fontSize: 16,
                              letterSpacing: 1
                          ),),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )

    );
  }

  _showReportDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          //Here we will build the content of the dialog
          return AlertDialog(
            title: Text("Choose Item Type"),
            content: MultiSelectChip(
              reportList,
              onSelectionChanged: (selectedList) {
                setState(() {
                  selectedReportList = selectedList;
                });
              },
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Continue"),
                onPressed: (){Navigator.of(context).pop();
                Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (c, a1, a2) =>ManageMenuPage(selectedItemIdForEditingToPass,itemName.reversed.toList()[index],itemCuisine.reversed.toList()[index],itemAmount.reversed.toList()[index],itemPrice.reversed.toList()[index],itemDescription.reversed.toList()[index],itemType.reversed.toList()[index],itemStatuses.reversed.toList()[index],itemCategory.reversed.toList()[index],itemBLSD.reversed.toList()[index]),
                      transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                      transitionDuration: Duration(milliseconds: 300),
                    )
                ).whenComplete((){
                  getItemList(context);
                });
                },
              )
            ],
          );
        });
  }

}

class MultiSelectChip extends StatefulWidget {
  final List<String> reportList;
  final Function(List<String>) onSelectionChanged; // +added
  MultiSelectChip(
      this.reportList,
      {this.onSelectionChanged} // +added
      );
  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}
class _MultiSelectChipState extends State<MultiSelectChip> {
  // String selectedChoice = "";
  List<String> selectedChoices = List();
  _buildChoiceList() {
    List<Widget> choices = List();
    itemTypesss.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item),
          selected: selectedChoices.contains(item),
          onSelected: (selected) {
            setState(() {

              int idx = itemTypesss.indexOf(item);

              selectedItemIdForEditingToPass = itemIdssss[idx];

              selectedChoices.contains(item)
                  ? selectedChoices.remove(item)
                  : selectedChoices.add(item);
              widget.onSelectionChanged(selectedChoices); // +added
            });

            print(selectedItemIdForEditingToPass);

          },
        ),
      ));
    });
    return choices;
  }
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}

List<String> reportList = [
  "Breakfast",
  "Lunch",
  "Snacks",
  "Dinner",
];
List<String> selectedReportList = List();

var selectedItemIdForEditingToPass;
