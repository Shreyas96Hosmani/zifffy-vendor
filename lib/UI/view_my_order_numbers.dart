import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:vendor_dabbawala/UI/view_my_order_details.dart';
import 'data/login_data.dart' as login;
import 'package:http/http.dart' as http;
import 'package:vendor_dabbawala/UI/data/globals_data.dart' as globals;
import 'dart:convert';

var orderIds;
var orderItemIds;
var orderItemQtys;
var orderStatuses;

ProgressDialog prOrders2;

var orderNumbers;
var orderDateTime;
var itemNames;
var itemPrices;
var itemType;
var itemAmount;
var itemDescription;
var paymentType;
var paymentStatus;
var customerName;
var customerContact;
var customerAddress;
var customerAddressSplitted;
var customerLat;
var customerLong;
var myAddress;
var paymentTypes;
var paymentStatuses;
var orderAditionalRequirement;
var totalOrdersTillDate;
var ordersMap = Map();
var ordersMapA = Map();
bool showOrders = false;

var myOrderNumberIds;
var myOrderNumbers;
var myOrderNumbersDate;

var myOrderAdOnNamess;

var summaryItemNames;
var summaryItemQtys;

var summaryAdonNames;
var summaryAdonQtys;

var myOrderTotal;
var deliveryFees;
var taxFees;
var packingCharge;

class ViewMyOrderNumbers extends StatefulWidget {
  @override
  _ViewMyOrderNumbersState createState() => _ViewMyOrderNumbersState();
}

class _ViewMyOrderNumbersState extends State<ViewMyOrderNumbers> {

  Future<String> getOrders(context) async {

    ordersMap = Map();

    print("vendor id : "+login.storedUserId.toString());
    String url = globals.apiUrl + "getordersbyvendorid.php";

    http.post(url, body: {

      "vendorID": login.storedUserId.toString(),

    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");

      }

      var responseArrayGetOrders = jsonDecode(response.body);
      print(responseArrayGetOrders);

      var responseArrayGetOrdersMsg = responseArrayGetOrders['message'].toString();
      print(responseArrayGetOrdersMsg);

      if(statusCode == 200){
        if(responseArrayGetOrdersMsg == "Item Found"){

          setState(() {
            orderIds = List.generate(responseArrayGetOrders['data'].length, (index) => responseArrayGetOrders['data'][index]['orderID'].toString());
            orderItemIds = List.generate(responseArrayGetOrders['data'].length, (index) => responseArrayGetOrders['data'][index]['orderItemid'].toString());
            orderItemQtys = List.generate(responseArrayGetOrders['data'].length, (index) => responseArrayGetOrders['data'][index]['orderQnty'].toString());
            orderStatuses = List.generate(responseArrayGetOrders['data'].length, (index) => responseArrayGetOrders['data'][index]['orderStatus'].toString());
            orderNumbers = List.generate(responseArrayGetOrders['data'].length, (index) => responseArrayGetOrders['data'][index]['orderNumber'].toString());
            orderDateTime = List.generate(responseArrayGetOrders['data'].length, (index) => responseArrayGetOrders['data'][index]['orderDatetime'].toString());
            itemNames = List.generate(responseArrayGetOrders['data'].length, (index) => responseArrayGetOrders['data'][index]['itemName'].toString());
            itemPrices = List.generate(responseArrayGetOrders['data'].length, (index) => responseArrayGetOrders['data'][index]['itemPrice'].toString());
            itemType = List.generate(responseArrayGetOrders['data'].length, (index) => responseArrayGetOrders['data'][index]['itemType'].toString());
            itemAmount = List.generate(responseArrayGetOrders['data'].length, (index) => responseArrayGetOrders['data'][index]['orderAmnt'].toString());
            itemDescription = List.generate(responseArrayGetOrders['data'].length, (index) => responseArrayGetOrders['data'][index]['itemDescription'].toString());
            customerName = List.generate(responseArrayGetOrders['data'].length, (index) => responseArrayGetOrders['data'][index]['customerFullname'].toString());
            customerContact = List.generate(responseArrayGetOrders['data'].length, (index) => responseArrayGetOrders['data'][index]['orderMobileno'].toString());
            customerAddress = List.generate(responseArrayGetOrders['data'].length, (index) => responseArrayGetOrders['data'][index]['customeraddressAddress'].toString());
            customerLat = List.generate(responseArrayGetOrders['data'].length, (index) => responseArrayGetOrders['data'][index]['customeraddressLatitude'].toString());
            customerLong = List.generate(responseArrayGetOrders['data'].length, (index) => responseArrayGetOrders['data'][index]['customeraddressLongitude'].toString());
            List<int> idx = List.generate(customerAddress.length, (index) => customerAddress[index].indexOf("- Add"));
            print(idx);
            customerAddressSplitted = List.generate(customerAddress.length, (index) => customerAddress[index].toString().substring(0,idx[index]).trim());
            myAddress = List.generate(responseArrayGetOrders['data'].length, (index) => responseArrayGetOrders['data'][index]['vendorAddress'].toString());
            paymentType = List.generate(responseArrayGetOrders['data'].length, (index) => responseArrayGetOrders['data'][index]['orderPaymenttype'].toString());
            paymentStatus = List.generate(responseArrayGetOrders['data'].length, (index) => responseArrayGetOrders['data'][index]['orderPaymentStatus'].toString());
            orderAditionalRequirement = List.generate(responseArrayGetOrders['data'].length, (index) => responseArrayGetOrders['data'][index]['orderAdditionalinfo'].toString());
            totalOrdersTillDate = orderNumbers.length;

            itemNames.forEach((element) {
              if(!ordersMap.containsKey(element)) {
                ordersMap[element] = 1;
              } else {
                ordersMap[element] +=1;
              }
            });

            orderStatuses.forEach((element) {
              if(element == "2" || element == "3") {
                showOrders = false;
              } else {
                showOrders = true;
              }
            });

          });
          print(orderIds);
          print(orderItemIds);
          print("itemNames"+itemNames.toList().toString());
          print("orderItemQtys" + orderItemQtys.toList().toString());
          print(orderStatuses);
          print(orderNumbers);
          print(orderDateTime);
          print(itemNames);
          print(itemPrices);
          print(itemType);
          print(itemAmount);
          print(itemDescription);
          print(customerName);
          print(customerContact);
          print(customerAddress);
          print(customerAddressSplitted);
          print(customerLat);
          print(customerLong);
          print(myAddress);
          print(paymentType);
          print(paymentStatus);
          print(orderAditionalRequirement);
          print(totalOrdersTillDate);

          print(ordersMap);

        }else{

          setState(() {
            orderNumbers = null;
          });

        }
      }
    });
  }

  Future<String> getOrderNumbers(context) async {

    String url = globals.apiUrl + "getordernumbersbyvendorid.php";

    http.post(url, body: {

      "vendorID": login.storedUserId.toString(),

    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");

      }

      var responseArrayGetOrderNumbers = jsonDecode(response.body);
      print(responseArrayGetOrderNumbers);

      var responseArrayGetOrderNumbersMsg = responseArrayGetOrderNumbers['message'].toString();
      print(responseArrayGetOrderNumbersMsg);

      if(statusCode == 200){
        if(responseArrayGetOrderNumbersMsg == "Item Found"){

          setState(() {
            myOrderNumberIds = List.generate(responseArrayGetOrderNumbers['data'].length, (index) => responseArrayGetOrderNumbers['data'][index]['orderID'].toString());
            myOrderNumbers = List.generate(responseArrayGetOrderNumbers['data'].length, (index) => responseArrayGetOrderNumbers['data'][index]['orderNumber'].toString());
            myOrderNumbersDate = List.generate(responseArrayGetOrderNumbers['data'].length, (index) => responseArrayGetOrderNumbers['data'][index]['orderDatetime'].toString());

            deliveryFees = responseArrayGetOrderNumbers['data'][0]['orderDeliveryfee'].toString();
            taxFees = responseArrayGetOrderNumbers['data'][0]['orderTax'].toString();
            packingCharge = responseArrayGetOrderNumbers['data'][0]['orderPacking'].toString();

            //myOrderTotal = responseArrayGetOrderNumbers['totalamt'].toString();

          });
          print(myOrderNumbers);
          print(myOrderNumbersDate);

          print("deliveryFees"+deliveryFees.toString());
          print("taxFees"+taxFees.toString());
          print("packingCharge"+packingCharge.toString());
          //print("myOrderTotal"+myOrderTotal);

        }else{

          setState(() {
            myOrderNumbers = null;
          });

        }
      }
    });
  }

  Future<String> getOrderAdons(context) async {

    ordersMapA = Map();

    String url = "https://test.dabbawala.ml/mobileapi/vendor/getadsonordersbyvendorid.php";

    http.post(url, body: {

      "vendorID": login.storedUserId.toString(),

    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");

      }

      var responseArrayGetOrderAdOns = jsonDecode(response.body);
      print(responseArrayGetOrderAdOns);

      var responseArrayGetOrderAdOnsMsg = responseArrayGetOrderAdOns['message'].toString();
      print(responseArrayGetOrderAdOnsMsg);

      if(statusCode == 200){
        if(responseArrayGetOrderAdOnsMsg == "Item Found"){

          setState(() {
            myOrderAdOnNamess = List.generate(responseArrayGetOrderAdOns['data'].length, (index) => responseArrayGetOrderAdOns['data'][index]['itemadsonName'].toString());
            //myOrderAdOnPrices = List.generate(responseArrayGetOrderAdOns['data'].length, (index) => responseArrayGetOrderAdOns['data'][index]['itemadsonPrice'].toString());

            myOrderAdOnNamess.forEach((element) {
              if(!ordersMapA.containsKey(element)) {
                ordersMapA[element] = 1;
              } else {
                ordersMapA[element] +=1;
              }
            });

          });
          print(myOrderItemNames);
          print(myOrderAdOnNamess);
          //print(myOrderItemPrices);

        }else{

          setState(() {
            myOrderAdOnNamess = null;
          });

        }
      }
    });
  }

  Future<String> getOrderSummary(context) async {

    print("order summary api called");

    String url = globals.apiUrl + "ordersummary.php";

    http.post(url, body: {

      "vendorID": login.storedUserId.toString(),

    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");

      }

      var responseArrayGetOrdersSummary = jsonDecode(response.body);
      print(responseArrayGetOrdersSummary);

      var responseArrayGetOrdersSummaryMsg = responseArrayGetOrdersSummary['message'].toString();
      print(responseArrayGetOrdersSummaryMsg);

      if(statusCode == 200){
        if(responseArrayGetOrdersSummaryMsg == "Successfully"){

          setState(() {
            summaryItemNames = List.generate(responseArrayGetOrdersSummary['data'].length, (index) => responseArrayGetOrdersSummary['data'][index]['itemName'].toString());
            summaryItemQtys = List.generate(responseArrayGetOrdersSummary['data'].length, (index) => responseArrayGetOrdersSummary['data'][index]['neworderqnty'].toString());

          });

          print("***************");
          print(summaryItemNames);
          print(summaryItemQtys);
          print("***************");

        }else{

          setState(() {
            summaryItemNames = null;
          });

        }
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOrderSummary(context);
    myOrderAdOnNamess = null;
    orderNumbers = null;
    totalOrdersTillDate = null;
    showOrders = false;
    //selectedOrderId = null;
    getOrders(context);
    getOrderNumbers(context);
    getOrderAdons(context);
    itemNames = [];
    ordersMapA = Map();
    ordersMap = Map();

    var elements = ["a", "b", "c", "d", "e", "a", "b", "c", "f", "g", "h", "h", "h", "e"];
    var map = Map();

    elements.forEach((element) {
      if(!map.containsKey(element)) {
        map[element] = 1;
      } else {
        map[element] +=1;
      }
    });

    print(map);
  }

  @override
  Widget build(BuildContext context) {
    prOrders2 = ProgressDialog(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:buildAppBar(context),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Positioned(
              top: 0, left: 0, right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height/3.2,
                    width: MediaQuery.of(context).size.width/2.3,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: ListView.builder(
                      itemCount: ordersMap.length,
                      itemBuilder: (BuildContext context, int index) {
                        String key = ordersMap.keys.elementAt(index);
                        return new Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Text(summaryItemNames[index].toString(),
                                      maxLines: 1,overflow: TextOverflow.ellipsis,
                                      textScaleFactor: 1,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Text(summaryItemQtys[index].toString(),textScaleFactor: 1,),
                                  )
                                ],
                              ),
                            ), Divider(
                              height: 2.0,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height/3.2,
                    width: MediaQuery.of(context).size.width/2.3,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: ListView.builder(
                      itemCount: ordersMapA.length,
                      itemBuilder: (BuildContext context, int index) {
                        String key = ordersMapA.keys.elementAt(index);
                        return new Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Text("$key",
                                      maxLines: 1,overflow: TextOverflow.ellipsis,
                                      textScaleFactor: 1,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Text("${ordersMapA[key]}",textScaleFactor: 1,),
                                  )
                                ],
                              ),
                            ), Divider(
                              height: 2.0,
                            ),
                          ],
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/3),
              child: buildOrderNumbersListViewBuilder(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAppBar(BuildContext context){
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: InkWell(
          onTap: (){
            Navigator.of(context).pop();
          },
          child: Icon(Icons.arrow_back_outlined,color: Colors.black,)),
      title: Text('No of Confirmed Orders Till Date:',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: Colors.blue[700],
      ),),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 40),
          child: Center(
            child: Text(totalOrdersTillDate == null ? "0" : totalOrdersTillDate.toString(),style: GoogleFonts.nunitoSans(
                color: Colors.blue[700],
                fontSize: 18,
                fontWeight: FontWeight.bold
            ),),
          ),
        )
      ],
      centerTitle: true,
    );
  }

  Widget buildOrderNumbersListViewBuilder(BuildContext context){
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Scrollbar(
        child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: myOrderNumbers == null ? 0 : myOrderNumbers.length,
            itemBuilder: (context, index) => InkWell(
              onTap: (){
                Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (c, a1, a2) =>ViewMyOrderDetails(myOrderNumbers[index], deliveryFees, packingCharge, taxFees),
                      transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                      transitionDuration: Duration(milliseconds: 300),
                    )
                ).whenComplete((){
                  getOrders(context);
                  getOrderNumbers(context);
                  getOrderAdons(context);
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  //height: 50,
                  decoration: BoxDecoration(
                    //border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                    //color: Colors.blue,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, right: 10, bottom: 0, left: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: 10,),
                        Text(myOrderNumbers[index].toString(),
                          style: GoogleFonts.nunitoSans(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(myOrderNumbersDate[index].toString(),
                          style: GoogleFonts.nunitoSans(
                            fontSize: 16,color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Divider(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ),
      ),
    );
  }

}
