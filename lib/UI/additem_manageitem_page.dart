import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'data/login_data.dart' as login;
import 'add_item_page.dart';
import 'manage_menu_page.dart';
import 'package:http/http.dart' as http;
import 'package:vendor_dabbawala/UI/data/globals_data.dart' as globals;
import 'dart:convert';
import 'package:vendor_dabbawala/UI/data/login_data.dart' as login;

var itemId;
var itemName;
List<String> itemNameWithId;
var itemPrice;
var image;
var itemDescription;
var itemCuisine;
var itemAmount;
var itemType;
var itemStatuses;
var itemCategory;
var itemBLSD;

var selectedItemIdForSearch;

bool showSearchedItem = false;

class AddItemManageItemPage extends StatefulWidget {
  @override
  _AddItemManageItemPageState createState() => _AddItemManageItemPageState();
}

class _AddItemManageItemPageState extends State<AddItemManageItemPage> {

  void _openEndDrawer() {
    login.scaffoldKeys.currentState.openEndDrawer();
  }
  Widget appBarTitle = new Text("AppBar Title",textScaleFactor: 1,);
  Icon actionIcon = new Icon(Icons.search,color: Colors.black,);

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
            itemId = List.generate(responseArrayGetItems['data'].length, (index) => responseArrayGetItems['data'][index]['itemID']);
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedItemIdForSearch = null;
    showSearchedItem = false;
    getItemList(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key:login.scaffoldKeys,
      endDrawer: buildAppDrawer(context),
      appBar: buildAppBar(context),
      bottomNavigationBar: buildAddNewItemContainer(context),
      backgroundColor: Colors.white,
      body: buildItems(context),
    );
  }

  Widget buildAppBar(BuildContext context){
    return AppBar(
      title: appBarTitle,
      backgroundColor: Colors.white,
      elevation: 0,
      leading: InkWell(
          onTap: (){
            Navigator.of(context).pop();
          },
          child: Icon(Icons.arrow_back_outlined,color: Colors.black,)),
      actions: [
        new IconButton(icon: actionIcon,color: Colors.black,onPressed:(){
          setState(() {
            if ( this.actionIcon.icon == Icons.search){
              this.actionIcon = new Icon(Icons.close,color: Colors.black,);

              this.appBarTitle = SearchableDropdown.single(
                  items: itemNameWithId == null ? []: itemNameWithId.map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(
                        value.toString().substring(1),
                        textScaleFactor: 1,
                      ),
                      /*
                     Padding(
                       padding: const EdgeInsets.only(top: 15),
                       child: InkWell(
                         onTap: (){
                           setState(() {
                             selectedItemId = home.itemId2[int.parse(selectedItemIdForSearch)].toString();
                           });
                           print(selectedItemId);
                           //addToCart(context);
                           //getItemAdons(context);
                           //slideSheetAddOns();
                         },
                         child: Container(
                             padding: EdgeInsets.only(left: 10, right: 10),
                             width: MediaQuery.of(context).size.width,
                             height: 120,
                             decoration: BoxDecoration(
                               color: Colors.white,
                             ),
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.start,
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Container(
                                   width: MediaQuery.of(context).size.width/2.5,
                                   height: MediaQuery.of(context).size.height/7,
                                   decoration: BoxDecoration(
                                     borderRadius:
                                     BorderRadius.all(Radius.circular(15)),
                                   ),
                                   child: Image.network("https://admin.dabbawala.ml/"+home.image2[int.parse(selectedItemIdForSearch)].toString(),
                                     fit: BoxFit.fill,
                                   ),
                                 ),
                                 SizedBox(width: 10,),
                                 Column(
                                     mainAxisAlignment: MainAxisAlignment.start,
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                       Padding(
                                         padding: const EdgeInsets.only(right: 0, top: 0),
                                         child: Container(
                                           width: 150,
                                           child: Text(
                                             home.itemNameTwo[int.parse(selectedItemIdForSearch)],
                                             maxLines: 2,
                                             style: GoogleFonts.nunitoSans(
                                                 color: Colors.black,
                                                 fontWeight: FontWeight.bold,
                                                 fontSize: 14),
                                           ),
                                         ),
                                       ),
                                       SizedBox(height: 0,),
                                       Container(
                                         width: 150,
                                         child: Text(
                                           home.itemDescription2[int.parse(selectedItemIdForSearch)],
                                           maxLines: 2,
                                           style: GoogleFonts.nunitoSans(
                                             color: Colors.grey,
                                             fontSize: 12.5,),
                                         ),
                                       ),
                                       SizedBox(height: 3,),
                                       Padding(
                                         padding: const EdgeInsets.only(right: 39),
                                         child: Text(
                                           home.vendorName2[int.parse(selectedItemIdForSearch)],
                                           style: GoogleFonts.nunitoSans(
                                               color: Colors.orange[800],
                                               fontWeight: FontWeight.bold,
                                               fontSize: 12),
                                         ),
                                       ),
                                       Spacer(),
                                       Padding(
                                         padding: const EdgeInsets.only(bottom: 5),
                                         child: Row(
                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                           crossAxisAlignment: CrossAxisAlignment.end,
                                           children: [
                                             counters2[selectedItemIdForSearch] > 0 ? Row(
                                               mainAxisAlignment: MainAxisAlignment.start,
                                               crossAxisAlignment: CrossAxisAlignment.center,
                                               children: [
                                                 InkWell(
                                                     onTap: (){
                                                       if(counters2[int.parse(selectedItemIdForSearch)] > 0){
                                                         setState(() {
                                                           counters2[int.parse(selectedItemIdForSearch)]--;
                                                         });
                                                         print(counters2[int.parse(selectedItemIdForSearch)]);
                                                         setState(() {
                                                           selectedItemId = home.itemId2[int.parse(selectedItemIdForSearch)].toString();
                                                         });
                                                         print(selectedItemId);
                                                         prAddToCart.show();
                                                         removeFromCart(context);
                                                       }else{

                                                       }
                                                     },
                                                     child: Padding(
                                                       padding: const EdgeInsets.only(right: 5),
                                                       child: Icon(Icons.delete, color: Colors.grey, size: 20,),
                                                     )),
                                                 Container(
                                                   decoration: BoxDecoration(
                                                       borderRadius: BorderRadius.all(Radius.circular(5)),
                                                       border: Border.all(color: Colors.grey)
                                                   ),
                                                   child: Center(
                                                     child: Padding(
                                                       padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                                                       child: Text(counters2[int.parse(selectedItemIdForSearch)].toString(),
                                                         style: GoogleFonts.nunitoSans(
                                                           color: Colors.black,
                                                           fontSize: 12,
                                                         ),
                                                       ),
                                                     ),
                                                   ),
                                                 ),
                                                 InkWell(
                                                     onTap: (){
                                                       setState(() {
                                                         counters2[int.parse(selectedItemIdForSearch)]++;
                                                       });
                                                       print(counters2[int.parse(selectedItemIdForSearch)]);
                                                       setState(() {
                                                         selectedItemId = home.itemId2[int.parse(selectedItemIdForSearch)].toString();
                                                       });
                                                       print(selectedItemId);
                                                       prAddToCart.show();
                                                       getItemAdons(context);
                                                       addToCart(context).whenComplete((){
                                                         Future.delayed(Duration(seconds: 3), () async {
                                                           if(home.adonName == null){
                                                             prAddToCart.hide();
                                                           }else{
                                                             prAddToCart.hide();
                                                             Navigator.push(
                                                                 context,
                                                                 PageRouteBuilder(
                                                                   pageBuilder: (c, a1, a2) => ChooseAdOns(selectedItemId, tempCartId, home.itemPrice2[int.parse(selectedItemIdForSearch)]),
                                                                   transitionsBuilder: (c, anim, a2, child) =>
                                                                       FadeTransition(opacity: anim, child: child),
                                                                   transitionDuration: Duration(milliseconds: 300),
                                                                 )
                                                             );
                                                           }
                                                         });
                                                       });
                                                     },
                                                     child: Padding(
                                                       padding: const EdgeInsets.only(right: 5),
                                                       child: Icon(Icons.add, color: Colors.grey, size: 20,),
                                                     )),
                                               ],
                                             ) : InkWell(
                                               onTap: (){
                                                 setState(() {
                                                   selectedItemId = home.itemId2[int.parse(selectedItemIdForSearch)].toString();
                                                   counters2[int.parse(selectedItemIdForSearch)]++;
                                                 });
                                                 print(selectedItemId);
                                                 print(counters2[int.parse(selectedItemIdForSearch)]);
                                                 prAddToCart.show();
                                                 getItemAdons(context);
                                                 addToCart(context).whenComplete((){
                                                   Future.delayed(Duration(seconds: 3), () async {
                                                     if(home.adonName == null){
                                                       prAddToCart.hide();
                                                     }else{
                                                       prAddToCart.hide();
                                                       Navigator.push(
                                                           context,
                                                           PageRouteBuilder(
                                                             pageBuilder: (c, a1, a2) => ChooseAdOns(selectedItemId, tempCartId, home.itemPrice2[int.parse(selectedItemIdForSearch)]),
                                                             transitionsBuilder: (c, anim, a2, child) =>
                                                                 FadeTransition(opacity: anim, child: child),
                                                             transitionDuration: Duration(milliseconds: 300),
                                                           )
                                                       );
                                                     }
                                                   });
                                                 });
                                                 /*
                                            showModalBottomSheet(
                                                isScrollControlled: true,
                                                context: context,
                                                builder: (context) {
                                                  return StatefulBuilder(
                                                      builder: (BuildContext context, StateSetter setState) {
                                                        return Padding(
                                                          padding: MediaQuery.of(context).viewInsets,
                                                          child: Container(
                                                            color: Color(0xFF737373),
                                                            child: Container(
                                                              height: MediaQuery.of(context).size.height,
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.only(
                                                                    topLeft: Radius.circular(15),
                                                                    topRight: Radius.circular(15)),
                                                                color: Colors.white,
                                                              ),
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                children: <Widget>[
                                                                  SizedBox(
                                                                    height: 30,
                                                                  ),
                                                                  Text(
                                                                    'Add-Ons ?',
                                                                    style: GoogleFonts.nunitoSans(
                                                                        fontWeight: FontWeight.bold, fontSize: 20),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 20,
                                                                  ),
                                                                  ListView.builder(
                                                                    shrinkWrap: true,
                                                                    physics: NeverScrollableScrollPhysics(),
                                                                    padding: EdgeInsets.all(0.0),
                                                                    scrollDirection: Axis.vertical,
                                                                    itemCount: home.adonName == null ? 0 : home.adonName.length,
                                                                    itemBuilder: (context, index) => Padding(
                                                                      padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                        children: [
                                                                          Text(home.adonName[index] == null || home.adonName[index] == "null" ? "loading" : home.adonName[index] + " (Rs " + home.adonPrice[index] + ")"),
                                                                          Row(
                                                                            children: [
                                                                              Container(
                                                                                width: MediaQuery.of(context).size.width / 18,
                                                                                height:
                                                                                MediaQuery.of(context).size.height / 40,
                                                                                decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.only(
                                                                                        bottomLeft: Radius.circular(50),
                                                                                        topLeft: Radius.circular(50)),
                                                                                    color: Colors.deepPurple[700]),
                                                                                child: GestureDetector(
                                                                                    onTap: () {
                                                                                      if(counter>0){
                                                                                        setState(() {
                                                                                          counter--;
                                                                                        });
                                                                                      }
                                                                                      else{

                                                                                      }
                                                                                    },
                                                                                    child: Icon(
                                                                                      Icons.delete,
                                                                                      color: Colors.white,
                                                                                      size: 16,
                                                                                    )),
                                                                              ),
                                                                              Container(
                                                                                width: MediaQuery.of(context).size.width / 18,
                                                                                height:
                                                                                MediaQuery.of(context).size.height / 40,
                                                                                color: Colors.white,
                                                                                child:
                                                                                Center(child: Text(counter.toString())),
                                                                              ),
                                                                              Container(
                                                                                width: MediaQuery.of(context).size.width / 18,
                                                                                height:
                                                                                MediaQuery.of(context).size.height / 40,
                                                                                decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.only(
                                                                                        bottomRight: Radius.circular(50),
                                                                                        topRight: Radius.circular(50)),
                                                                                    color: Colors.deepPurple[700]),
                                                                                child: GestureDetector(
                                                                                  onTap: () {
                                                                                    setState(() {
                                                                                      counter++;
                                                                                    });
                                                                                  },
                                                                                  child: Icon(
                                                                                    Icons.add,
                                                                                    color: Colors.white,
                                                                                    size: 16,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 20,
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(left: 10),
                                                                    child: Align(
                                                                      alignment: Alignment.centerLeft,
                                                                      child: Text(
                                                                        'Special instructions',
                                                                        style: GoogleFonts.nunitoSans(
                                                                            fontWeight: FontWeight.bold, fontSize: 14),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(left: 10, right: 10),
                                                                    child: Row(
                                                                      children: [
                                                                        Container(
                                                                          width: MediaQuery.of(context).size.width / 1.06,
                                                                          height: MediaQuery.of(context).size.height / 9,
                                                                          decoration: BoxDecoration(
                                                                              border: Border.all(color: Colors.grey),
                                                                              borderRadius:
                                                                              BorderRadius.all(Radius.circular(5))),
                                                                          child: TextField(
                                                                            decoration: InputDecoration(
                                                                              contentPadding:
                                                                              EdgeInsets.only(left: 10, top: 5),
                                                                              border: InputBorder.none,
                                                                            ),
                                                                            maxLines: 5,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(left: 10, right: 10),
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                          'Total Price : ',
                                                                          style: GoogleFonts.nunitoSans(
                                                                              fontWeight: FontWeight.w600, fontSize: 18),
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets.only(right: 3),
                                                                          child: Container(
                                                                            width: 60,
                                                                            height: 30,
                                                                            decoration: BoxDecoration(
                                                                              borderRadius:
                                                                              BorderRadius.all(Radius.circular(5)),
                                                                              //border: Border.all(color: Colors.black)
                                                                            ),
                                                                            child: Center(
                                                                              child: Text(
                                                                                'Rs 225',
                                                                                style: GoogleFonts.nunitoSans(
                                                                                    fontSize: 18,
                                                                                    fontWeight: FontWeight.bold),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Spacer(),
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(right: 10, left: 10, bottom: 15),
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        InkWell(
                                                                          onTap: (){
                                                                            Navigator.of(context).pop();
                                                                            //addAddOnsToCart(context);
                                                                          },
                                                                          child: Container(
                                                                            width: MediaQuery.of(context).size.width / 2.3,
                                                                            height: MediaQuery.of(context).size.height / 20,
                                                                            decoration: BoxDecoration(
                                                                                borderRadius:
                                                                                BorderRadius.all(Radius.circular(7)),
                                                                                color: Colors.grey[300]),
                                                                            child: Center(
                                                                              child: Text(
                                                                                'Cancel',
                                                                                style: GoogleFonts.nunitoSans(
                                                                                    fontWeight: FontWeight.bold,
                                                                                    fontSize: 18,
                                                                                    color: Colors.black),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        InkWell(
                                                                          onTap: (){
                                                                            Navigator.push(
                                                                                context,
                                                                                PageRouteBuilder(
                                                                                  pageBuilder: (c, a1, a2) =>CartPage(),
                                                                                  transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                                                                                  transitionDuration: Duration(milliseconds: 300),
                                                                                )
                                                                            );
                                                                          },
                                                                          child: Container(
                                                                            width: MediaQuery.of(context).size.width / 2.3,
                                                                            height: MediaQuery.of(context).size.height / 20,
                                                                            decoration: BoxDecoration(
                                                                                borderRadius:
                                                                                BorderRadius.all(Radius.circular(7)),
                                                                                color: Colors.blue[700]),
                                                                            child: Center(
                                                                              child: Text(
                                                                                'Proceed',
                                                                                style: GoogleFonts.nunitoSans(
                                                                                    fontWeight: FontWeight.bold,
                                                                                    fontSize: 18,
                                                                                    color: Colors.white),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ) ;

                                                      });
                                                }).whenComplete((){
                                              getItemAdons(context).whenComplete((){
                                                Future.delayed(Duration(seconds: 3), () async {
                                                  print("setting state");
                                                  setState(() {

                                                  });
                                                });
                                              });
                                            });

                                             */
                                               },
                                               child: Container(
                                                 height: 30,
                                                 width: 60,
                                                 decoration: BoxDecoration(
                                                     borderRadius: BorderRadius.all(Radius.circular(5)),
                                                     border: Border.all(color: Colors.grey)
                                                 ),
                                                 child: Center(
                                                   child: Text("Add +",
                                                     style: GoogleFonts.nunitoSans(
                                                       color: Colors.black,
                                                       fontSize: 10,
                                                     ),
                                                   ),
                                                 ),
                                               ),
                                             ),
                                             SizedBox(width: 10,),
                                             Text(
                                               "Rs. "+home.itemPrice2[int.parse(selectedItemIdForSearch)],
                                               style: GoogleFonts.nunitoSans(
                                                   color: Colors.black,
                                                   fontSize: 16,
                                                   fontWeight: FontWeight.bold),
                                             ),
                                           ],
                                         ),
                                       ),
                                       /*
                                  GestureDetector(
                                    onTap: () {
                                      homePageApiProvider.getItemAdons(context);
                                    },
                                    child: Container(
                                      width: 50,
                                      height: 30,
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                color:
                                                Colors.black.withOpacity(0.5),
                                                blurRadius: 5)
                                          ],
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          color: Colors.green[500]),
                                      child: Center(
                                        child: Text(
                                          'Add',
                                          style: GoogleFonts.nunitoSans(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14),
                                        ),
                                      ),
                                    ),
                                  ),

                                   */
                                     ]),
                               ],
                             )),
                       ),
                     )

                      */
                    );
                  }).toList(),
                  value: "Search by item name...",
                  hint: "Search dishes",
                  searchHint: "Search dishes",
                  clearIcon: Icon(null),
//                  onClear: (){
//                    setState(() {
//                      selectedCategory = null;
//                    });
//                  },
                  onChanged: (value) {
                    setState(() {
                      selectedItemIdForSearch = (int.parse(value[0])-1).toString();
                      showSearchedItem = true;
                    });
                    print(selectedItemIdForSearch);
                  },
                  isExpanded: true
              );
            }
            else {
              setState(() {
                showSearchedItem = false;
              });
              this.actionIcon = new Icon(Icons.search,color: Colors.black,);
              this.appBarTitle = new Text("AppBar Title",textScaleFactor: 1,);
            }


          });
        } ,),
        SizedBox(width: 20,),
        InkWell(
            onTap: () => _openEndDrawer(),

            child: Icon(Icons.menu,color: Colors.black,)),
        SizedBox(width: 20,)
      ],
    );

  }

  Widget buildAddNewItemContainer(BuildContext context){
    return Container(
      height: MediaQuery.of(context).size.height/18,
      child: RaisedButton(
        onPressed: (){
          Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (c, a1, a2) =>AddItemPage(),
                transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                transitionDuration: Duration(milliseconds: 300),
              )
          ).whenComplete((){
            getItemList(context);
          });
        },
        child: Center(
          child: Text('Add New Item',textScaleFactor: 1,
            style: GoogleFonts.nunitoSans(
              color: Colors.white,
              fontSize: 18,
              letterSpacing: 1,
            ),
          ),
        ),
        color: Colors.blue[700],
      ),
    );
  }

  Widget buildItems(BuildContext context){
    return itemName == null ? Center(
      child: Text("Add a new item and start selling",textScaleFactor: 1,
        style: GoogleFonts.nunitoSans(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    ) : Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height/1,
        padding: EdgeInsets.only(left: 10,right: 10),
        child: showSearchedItem == true ?
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
                        child: Text(itemCuisine[selectedItemIdForSearch],textScaleFactor: 1,style: GoogleFonts.nunitoSans(
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
                ) :
        ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: itemName == null ? 0 : itemName.length,
            itemBuilder: (context, index) =>
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
                        child: Image.network("https://admin.dabbawala.ml/"+image[index].toString(),scale: 2,fit: BoxFit.fill,),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 115,top: 10),
                        child: Text(itemName[index],textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12
                        ),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 115, top: 90),
                        child: Text(itemDescription[index],
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
                        child: Text(itemAmount[index],textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 12
                        ),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 115,top: 70),
                        child: Text('Price - Rs '+itemPrice[index],textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w600
                        ),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 115,top: 30),
                        child: Text(itemCuisine[index],textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 12
                        ),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:280,top:10),
                        child: Text('SKU No - SKU-'+itemId[index],textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 12
                        ),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 290,top: 50),
                        child: Text('Type - '+itemType[index],textScaleFactor: 1,style: GoogleFonts.nunitoSans(
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
                                  pageBuilder: (c, a1, a2) =>ManageMenuPage(itemId[index],itemName[index],itemCuisine[index],itemAmount[index],itemPrice[index],itemDescription[index],itemType[index],itemStatuses[index],itemCategory[index],itemBLSD[index]),
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

        )) ;
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
                    Text('Home',textScaleFactor: 1,
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
                    Text('Add New Item And \nManage Menu',textScaleFactor: 1,
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
                    Text('Order And \nOrder Summary',textScaleFactor: 1,
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
                    Text('Report And Details',textScaleFactor: 1,
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

}
