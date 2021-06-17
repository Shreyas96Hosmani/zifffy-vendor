import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vendor_dabbawala/UI/order_summary_page.dart';
import 'package:vendor_dabbawala/UI/view_my_order_numbers.dart';
import 'data/login_data.dart' as login;
import 'package:http/http.dart' as http;
import 'package:vendor_dabbawala/UI/data/globals_data.dart' as globals;
import 'dart:convert';

ProgressDialog prOrders3;
var ordersMap = Map();
var myOrderIds;
var myOrderItemNames;
List<String> myOrderItemPrices;
var myOrderItemDescription;
var myOrderCustomerContactNumbers;
var myOrderTypes;
var myOrderStatus;
var myOrderPaymentType;
var myOrderPaymentStatus;
var myOrderSkuNo;
var myOrderDate;
var myOrderTime;
var myOrderDeliveryAddressLat;
var myOrderDeliveryAddressLong;

var myOrderQtyItems;
var myOrderQtyAdDOns;
var myOrderAdsonItemType;

var myOrderAdOnNames;
List<String> myOrderAdOnPrices;

var myOrderAdditionalInfo;

bool showOrder = false;

var selectedOrderIdForCancelling;
var selectedOrderIdForMarkingAsComplete;

var orderStatus;
var chotaBetaOrderIds;
var orderIdForGettingDetails;

List<String> orderIdsListChotaBeta = [];
List<String> orderStatusMessagesList = [];
List<String> orderDeliveryBoyId = [];
List<String> orderDeliveryBoyName = [];
List<String> orderDeliveryBoyContact = [];
List<String> orderDeliveryBoyStatusText = [];
List<String> orderDeliveryBoyLat = [];
List<String> orderDeliveryBoyLong = [];

int sumItems;
int sumAdons;

var tmpSum;
var tmpSumA;

var totalItems;
var totalItemAdons;

var customerAddress;
var customerAddressSplitted;

var flagString;

class ViewMyOrderDetails extends StatefulWidget {
  final orderNumber;
  final delivery;
  final packing;
  final tax;
  ViewMyOrderDetails(this.orderNumber, this.delivery, this.packing, this.tax) : super();
  @override
  _ViewMyOrderDetailsState createState() => _ViewMyOrderDetailsState();
}

class _ViewMyOrderDetailsState extends State<ViewMyOrderDetails> {

  int i;

  Future<String> getOrderDetails(context) async {

    ordersMap = Map();

    String url = globals.apiUrl + "getorderitemsbyodernonvendorid.php";

    http.post(url, body: {

      "vendorID": login.storedUserId.toString(),
      "ordernumber" : widget.orderNumber.toString(),

    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");

      }

      var responseArrayGetOrderDetails = jsonDecode(response.body);
      print(responseArrayGetOrderDetails);

      var responseArrayGetOrderDetailsMsg = responseArrayGetOrderDetails['message'].toString();
      print(responseArrayGetOrderDetailsMsg);

      if(statusCode == 200){
        if(responseArrayGetOrderDetailsMsg == "Item Found"){

          setState(() {
            myOrderIds = List.generate(responseArrayGetOrderDetails['data'].length, (index) => responseArrayGetOrderDetails['data'][index]['orderID'].toString());
            myOrderItemNames = List.generate(responseArrayGetOrderDetails['data'].length, (index) => responseArrayGetOrderDetails['data'][index]['itemName'].toString());
            myOrderItemPrices = List.generate(responseArrayGetOrderDetails['data'].length, (index) => responseArrayGetOrderDetails['data'][index]['itemPrice'].toString());
            myOrderCustomerContactNumbers = List.generate(responseArrayGetOrderDetails['data'].length, (index) => responseArrayGetOrderDetails['data'][index]['orderMobileno'].toString());
            myOrderTypes = List.generate(responseArrayGetOrderDetails['data'].length, (index) => responseArrayGetOrderDetails['data'][index]['itemType'].toString());
            myOrderStatus = List.generate(responseArrayGetOrderDetails['data'].length, (index) => responseArrayGetOrderDetails['data'][index]['orderStatus'].toString());
            myOrderPaymentType = List.generate(responseArrayGetOrderDetails['data'].length, (index) => responseArrayGetOrderDetails['data'][index]['orderPaymenttype'].toString());
            myOrderPaymentStatus = List.generate(responseArrayGetOrderDetails['data'].length, (index) => responseArrayGetOrderDetails['data'][index]['orderPaymentStatus'].toString());
            myOrderSkuNo = List.generate(responseArrayGetOrderDetails['data'].length, (index) => responseArrayGetOrderDetails['data'][index]['orderItemid'].toString());
            myOrderDate = List.generate(responseArrayGetOrderDetails['data'].length, (index) => responseArrayGetOrderDetails['data'][index]['orderDatetime'].toString().substring(0,10));
            myOrderTime = List.generate(responseArrayGetOrderDetails['data'].length, (index) => responseArrayGetOrderDetails['data'][index]['orderDatetime'].toString().substring(11));
            myOrderDeliveryAddressLat = List.generate(responseArrayGetOrderDetails['data'].length, (index) => responseArrayGetOrderDetails['data'][index]['customeraddressLatitude'].toString());
            myOrderDeliveryAddressLong = List.generate(responseArrayGetOrderDetails['data'].length, (index) => responseArrayGetOrderDetails['data'][index]['customeraddressLongitude'].toString());
            myOrderAdditionalInfo = List.generate(responseArrayGetOrderDetails['data'].length, (index) => responseArrayGetOrderDetails['data'][index]['orderAdditionalinfo'].toString());
            myOrderItemDescription = List.generate(responseArrayGetOrderDetails['data'].length, (index) => responseArrayGetOrderDetails['data'][index]['itemDescription'].toString());
            orderStatus = List.generate(responseArrayGetOrderDetails['data'].length, (index) => responseArrayGetOrderDetails['data'][index]['orderStatus'].toString());

            customerAddress = List.generate(responseArrayGetOrderDetails['data'].length, (index) => responseArrayGetOrderDetails['data'][index]['customeraddressAddress'].toString());
            List<int> idx = List.generate(customerAddress.length, (index) => customerAddress[index].indexOf("- Add"));
            print(idx);
            customerAddressSplitted = List.generate(customerAddress.length, (index) => customerAddress[index].toString().substring(0,idx[index]).trim());

            myOrderQtyItems = List.generate(responseArrayGetOrderDetails['data'].length, (index) => responseArrayGetOrderDetails['data'][index]['orderQnty'].toString());
            tmpSum = List.generate(responseArrayGetOrderDetails['data'].length, (index) => int.parse(responseArrayGetOrderDetails['data'][index]['orderQnty'].toString()) * int.parse(responseArrayGetOrderDetails['data'][index]['itemPrice'].toString()) );
            totalItems = myOrderQtyItems.map((value)=>int.parse(value.toString())).reduce((x,y)=>x+y);

            myOrderTypes.forEach((element) {
              if(!ordersMap.containsKey(element)) {
                ordersMap[element] = 1;
              } else {
                ordersMap[element] +=1;
              }
            });
            
          });
          print(myOrderIds);
          print(myOrderItemNames);
          print(myOrderItemPrices);
          print(myOrderCustomerContactNumbers);
          print(myOrderTypes);
          print(myOrderStatus);
          print(myOrderPaymentType);
          print(myOrderPaymentStatus);
          print(myOrderSkuNo);
          print(myOrderDate);
          print(myOrderTime);
          print(myOrderDeliveryAddressLat);
          print(myOrderDeliveryAddressLong);
          print(myOrderAdditionalInfo);
          print(myOrderItemDescription);
          print(orderStatus);

          print(myOrderQtyItems);

          print("********");
          print(customerAddress);
          print(customerAddressSplitted);
          print("********");

          getOrderAdons(context);

        }else{

          setState(() {
            myOrderItemNames = null;
          });

          getOrderAdons(context);

        }
      }
    });
  }

  Future<String> getOrderAdons(context) async {

    String url = globals.apiUrl + "getorderadsonbyodernonvendorid.php";

    http.post(url, body: {

      "vendorID": login.storedUserId.toString(),
      "ordernumber" : widget.orderNumber.toString(),

    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");

      }

      var responseArrayGetOrderAdOns = jsonDecode(response.body);
      print("00000000000000");
      print(responseArrayGetOrderAdOns);
      print("00000000000000");


      var responseArrayGetOrderAdOnsMsg = responseArrayGetOrderAdOns['message'].toString();
      print(responseArrayGetOrderAdOnsMsg);

      if(statusCode == 200){
        if(responseArrayGetOrderAdOnsMsg == "Item Found"){

          setState(() {
            myOrderAdOnNames = List.generate(responseArrayGetOrderAdOns['data'].length, (index) => responseArrayGetOrderAdOns['data'][index]['itemadsonName'].toString());
            myOrderAdOnPrices = List.generate(responseArrayGetOrderAdOns['data'].length, (index) => responseArrayGetOrderAdOns['data'][index]['itemadsonPrice'].toString());

            myOrderQtyAdDOns = List.generate(responseArrayGetOrderAdOns['data'].length, (index) => responseArrayGetOrderAdOns['data'][index]['adsonordersQnty'].toString());

            myOrderAdsonItemType = List.generate(responseArrayGetOrderAdOns['data'].length, (index) => responseArrayGetOrderAdOns['data'][index]['adsonorderItemtype'].toString());

            tmpSumA = List.generate(responseArrayGetOrderAdOns['data'].length, (index) => int.parse(responseArrayGetOrderAdOns['data'][index]['adsonordersQnty'].toString()) * int.parse(responseArrayGetOrderAdOns['data'][index]['itemadsonPrice'].toString()) );
            totalItemAdons = myOrderQtyAdDOns.map((value)=>int.parse(value.toString())).reduce((x,y)=>x+y);

          });

          print("///////////");
          print(myOrderAdOnNames);
          print(myOrderAdOnPrices);
          print(myOrderAdsonItemType);
          print(myOrderQtyAdDOns);
          print("///////////");


          for(i = 0; i < myOrderItemPrices.length; i++){
            sumItems = tmpSum.map((value)=>int.parse(value.toString())).reduce((x,y)=>x+y);
          }

          for(i = 0; i < myOrderAdOnPrices.length; i++){
            sumAdons = tmpSumA.map((value)=>int.parse(value.toString())).reduce((x,y)=>x+y);
          }

          setState(() {
            int temp = sumItems + sumAdons;

            int deliveryTemp = 0;
            int packingChargeTemp = 0;
            double taxTemp = 0.0;

            deliveryTemp = int.parse(ordersMap.length.toString()) * int.parse(widget.delivery); //for now taken multiplier 3 because there are 3 item types
            packingChargeTemp = int.parse(totalItems.toString()) * int.parse(widget.packing);
            taxTemp = temp * double.parse(widget.tax)/100;

            print("totalItemsIII : " + (int.parse(totalItems.toString()) + int.parse(totalItemAdons.toString())).toString());
            print("tempIII : " + temp.toString());
            print("deliveryTempIII : " + deliveryTemp.toString());
            print("packingChargeTempIII : " + packingChargeTemp.toString());
            print("taxTempIII : " + taxTemp.toString());

            //total = 80 + 5 + 20 + 3.6

            myOrderTotal = temp + deliveryTemp + packingChargeTemp + taxTemp;

            print("myOrderTotalIII" + myOrderTotal.toString());


          });


        }else{

          setState(() {
            myOrderAdOnNames = null;
          });


          for(i = 0; i < myOrderQtyItems.length; i++){
            sumItems = tmpSum.map((value)=>int.parse(value.toString())).reduce((x,y)=>x+y);
          }

          setState(() {
            int temp  = sumItems; //total of item prices

            int deliveryTemp = 0;
            int packingChargeTemp = 0;
            double taxTemp = 0.0;

            deliveryTemp = int.parse(ordersMap.length.toString()) * int.parse(widget.delivery); //for now taken multiplier 3 because there are 3 item types
            packingChargeTemp = int.parse(totalItems.toString()) * int.parse(widget.packing);
            taxTemp = temp * double.parse(widget.tax)/100;

            print("totalItems" + totalItems.toString());
            print("temp" + temp.toString());
            print("deliveryTemp" + deliveryTemp.toString());
            print("packingChargeTemp" + packingChargeTemp.toString());
            print("taxTemp" + taxTemp.toString());

            myOrderTotal = temp + deliveryTemp + packingChargeTemp + taxTemp;

            print("myOrderTotal" + myOrderTotal.toString());

          }); //1500+5+18+20

        }
      }
    });
  }

  Future<String> cancelOrder(context) async {

    String url = globals.apiUrl + "cancelcustomerorder.php";

    http.post(url, body: {

      "orderID": selectedOrderIdForCancelling.toString(),
      "flags" : flagString.toString(),

    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");

      }
      var responseArrayCancelOrder = jsonDecode(response.body);
      print(responseArrayCancelOrder);

      var responseArrayCancelOrderMsg = responseArrayCancelOrder['message'].toString();
      print(responseArrayCancelOrderMsg);

      if(statusCode == 200){
        if(responseArrayCancelOrderMsg == "Successfully"){

          getOrderDetails(context);
//          Fluttertoast.showToast(msg: 'This order has been cancelled', backgroundColor: Colors.black,
//              textColor: Colors.white
//          ).whenComplete((){
//            getOrderDetails(context);
//            //getOrders(context);
//            //getOrderNumbers(context);
//          });
//
//          prOrders3.hide();

        }else{

//          Fluttertoast.showToast(msg: 'Please check your network connection!', backgroundColor: Colors.black,
//              textColor: Colors.white
//          );
//          prOrders3.hide();

        }
      }
    });
  }

  Future<String> markOrderAsComplete(context) async {

    String url = globals.apiUrl + "markasdeliveredorder.php";

    http.post(url, body: {

      "orderID": selectedOrderIdForMarkingAsComplete.toString(),
      "flags" : flagString.toString(),

    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");

      }
      var responseArrayMarkAsComplete = jsonDecode(response.body);
      print(responseArrayMarkAsComplete);

      var responseArrayMarkAsCompleteMsg = responseArrayMarkAsComplete['message'].toString();
      print(responseArrayMarkAsCompleteMsg);

      if(statusCode == 200){
        if(responseArrayMarkAsCompleteMsg == "Successfully"){

          getOrderDetails(context);
//          Fluttertoast.showToast(msg: 'This order has been marked as delivered', backgroundColor: Colors.black,
//              textColor: Colors.white
//          ).whenComplete((){
//            getOrderDetails(context);
//            //getOrders(context);
//            //getOrderNumbers(context);
//          });
//
//          prOrders3.hide();

        }else{

//          Fluttertoast.showToast(msg: 'Please check your network connection!', backgroundColor: Colors.black,
//              textColor: Colors.white
//          );
//          prOrders3.hide();

        }
      }
    });
  }

  Future<String> getChotaBetaOrderIds(context) async {

    String url = globals.apiUrl + "getchotabetaorder.php";

    http.post(url, body: {

      "ordernumber" : widget.orderNumber.toString(),

    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");

      }

      var responseArrayGetChotaBetaOrderIds = jsonDecode(response.body);
      print(responseArrayGetChotaBetaOrderIds);

      var responseArrayGetChotaBetaOrderIdsMsg = responseArrayGetChotaBetaOrderIds['message'].toString();
      print(responseArrayGetChotaBetaOrderIdsMsg);

      if(statusCode == 200){
        if(responseArrayGetChotaBetaOrderIdsMsg == "Data Found"){

          setState(() {
            chotaBetaOrderIds = List.generate(responseArrayGetChotaBetaOrderIds['data'].length, (index) => responseArrayGetChotaBetaOrderIds['data'][index]['chotabetaOrderid'].toString());

            chotaBetaOrderIds.forEach((element) {
              int idx = chotaBetaOrderIds.indexOf(element);
              orderIdForGettingDetails = chotaBetaOrderIds[idx].toString();
              print("orderIdForGettingDetails"+orderIdForGettingDetails);
              getChotaBetaOrderDetails(context);
            });

          });
          print("*********");
          print(chotaBetaOrderIds);
          print("*********");

        }else{

          print("ERRRRRRRRRRROOOORRRRR");
          setState(() {
            chotaBetaOrderIds = null;
          });

        }
      }
    });
  }

  Future<Map<String, dynamic>> getChotaBetaOrderDetails(context) async {

    print("Url for getting order id details : https://www.stackroger.com/api/parent-order-tracking?order_id=$orderIdForGettingDetails");

    var url = 'https://www.stackroger.com/api/parent-order-tracking?order_id=$orderIdForGettingDetails';

    var response = await http.get(
      url,

      headers: {
        'Authorization': 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6ImQ1YmE0MzkxNDQwODViOWU3MTEwYjNmMzMxMDgxNjhmNDBjMTI1NDU1NjNiZDBjZDk1OTAzOTE3YTMzZTM4MzQ3MTY1YTViOWYyMzQ0MTdhIn0.eyJhdWQiOiIzIiwianRpIjoiZDViYTQzOTE0NDA4NWI5ZTcxMTBiM2YzMzEwODE2OGY0MGMxMjU0NTU2M2JkMGNkOTU5MDM5MTdhMzNlMzgzNDcxNjVhNWI5ZjIzNDQxN2EiLCJpYXQiOjE2MTk2OTE2NTksIm5iZiI6MTYxOTY5MTY1OSwiZXhwIjoxNjUxMjI3NjU5LCJzdWIiOiIyMzgyODgzIiwic2NvcGVzIjpbXX0.oHh9YLnQq63UAmIujwvKNyKXQxRV0eH5gE2Rgkm5gcKROinz-Us9COqyGi3v1mDC2bOtdKQ43Yk6i92rOQWuJlZ9j1TKXC3sUsXd26ciZ00FS5Zp3n86XwTTeSYFzmLmKeecZ-aGY72MFVFoONr2pG8tqL0mTbGttUaEzOyHrTroMYM3Bnlo6v4MQbhUpDic6TY6N74trZHQ3GmPvEldWt-s5hXE4LgW4SuN0grGEAksIm1OCvS0pGGfEmir4IgyjmgCrUbzecSIvfVlYVz8OY01VIQV-g6q3xBWWqDPYZFPhAKIZpHyaAT3JBcwV8ZUnF7Daldd8D9rFpTDSimxyja8JayWTP4JLQ7t5klnb7E8MYT-aMuxRqAi2B8bXTHgbCvt1zVim3oQydgLK-8VgVSDAIfNjVbMdWfZ169jVFpg-gxGF9C6umy08yJ17Nxr0OYTVF5bU2sSwDjQ8RxWVSy0zwGqNG_R_CHJB_AazBdbE5DKpfejQ5HzuryB2NBow7pyMB6EaK4QNttQkpoSLAWedrZjH6LXF9XDu0Z5xeIwKCDIrb1ESDqNhC5jiJ-SOguBon8OkApPXQqe-vzCgBlVpVMPrGznMybX-otVkpweZql6nicJb1ar0NBcvN0hGZO8mp6CMLg8NMcEvArZnMIv08scD99FP0Xa0r9VdEA',
        'Content-Type' : 'application/json',
        'Cookie': '__cfduid=deaa90547c50f498317ee6794a24413de1618893328',
      },
    );

    // todo - handle non-200 status code, etc

    var chotaBetaPlaceGetOrderResponseArray = json.decode(response.body.toString());
    print(chotaBetaPlaceGetOrderResponseArray);

    setState(() {
      orderIdsListChotaBeta.add(chotaBetaPlaceGetOrderResponseArray['order_id'].toString());

      orderStatusMessagesList.add(chotaBetaPlaceGetOrderResponseArray['message'].toString() == "Order is in new state waiting for merge" ? "Your order is being prepared" : chotaBetaPlaceGetOrderResponseArray['message'].toString());

      orderDeliveryBoyId.add(chotaBetaPlaceGetOrderResponseArray['delivery_boy_id'].toString());

      orderDeliveryBoyName.add(chotaBetaPlaceGetOrderResponseArray['delivery_boy_name'].toString());

      orderDeliveryBoyStatusText.add(chotaBetaPlaceGetOrderResponseArray['delivery_boy_status_text'].toString());

      orderDeliveryBoyLat.add(chotaBetaPlaceGetOrderResponseArray['delivery_boy_latitude'].toString());

      orderDeliveryBoyLong.add(chotaBetaPlaceGetOrderResponseArray['delivery_boy_longitude'].toString());

      orderDeliveryBoyContact.add(chotaBetaPlaceGetOrderResponseArray['delivery_boy_mobile'].toString());
    });

    print("CCCCCCCCCCCCCCC");
    print(orderIdsListChotaBeta.toList());
    print(orderStatusMessagesList.toList());
    print(orderDeliveryBoyId.toList());
    print(orderDeliveryBoyName.toList());
    print(orderDeliveryBoyStatusText.toList());
    print(orderDeliveryBoyLat.toList());
    print(orderDeliveryBoyLong.toList());
    print(orderDeliveryBoyContact.toList());
    print("CCCCCCCCCCCCCCC");

    return jsonDecode(response.body);

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      ordersMap = Map();
      totalItems = null;
      tmpSum = null;
      myOrderTotal = null;
      myOrderItemNames = null;
      myOrderAdOnNames = null;
      orderIdsListChotaBeta = [];
      orderStatusMessagesList = [];
      orderDeliveryBoyId = [];
      orderDeliveryBoyName = [];
      orderDeliveryBoyStatusText = [];
      orderDeliveryBoyLat = [];
      orderDeliveryBoyLong = [];
      orderDeliveryBoyContact = [];
      orderStatus = null;
      selectedOrderIdForCancelling = null;
      selectedOrderIdForMarkingAsComplete = null;
      myOrderCustomerContactNumbers = null;
      showOrder = false;
    });
    Future.delayed(Duration(seconds: 3), () async {
      setState(() {
        showOrder = true;
      });
    });
    getChotaBetaOrderIds(context);
    getOrderDetails(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    //getOrderDetails(context);
    prOrders3 = ProgressDialog(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: orderStatus == null || orderStatus == "null" ? Text(
            widget.orderNumber,
          style: GoogleFonts.nunitoSans(
              fontSize: 16,
              color: Colors.black
          ),
        ) : Text(orderStatus == null ? widget.orderNumber : orderStatus[0] == "1" ? widget.orderNumber+" (Pending)" : orderStatus[0] == "2" ? widget.orderNumber+" (Delivered) " : orderStatus[0] == "3" ? widget.orderNumber+" (Cancelled) " : widget.orderNumber,
            style: GoogleFonts.nunitoSans(
              fontSize: 16,
              color: Colors.black
            ),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 0, right: 0, bottom: 10),
        child: Container(
          height: 150,
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,

            children: [
              Container(
                width: MediaQuery.of(context).size.width/2.2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: (){
                        launch("tel://<"+myOrderCustomerContactNumbers[0]+">");
                      },
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Center(
                          child: Text(myOrderCustomerContactNumbers == null ? "Call Customer" : "Customer - "+myOrderCustomerContactNumbers[0],
                            style: GoogleFonts.nunitoSans(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    GestureDetector(
                      onTap: () async {
                        final url = "https://maps.google.com/?q=<"+myOrderDeliveryAddressLat[0]+">,<"+myOrderDeliveryAddressLong[0]+"";//"https://www.google.com/maps/dir/?api=1&origin=" + origin + "&destination=" + address + "&travelmode=driving&dir_action=navigate";
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                      },
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.red[700],
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Center(
                          child: Text("Show Directions",
                            style: GoogleFonts.nunitoSans(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width/2.2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: (){
                        //launch("tel://<"+myOrderCustomerContactNumbers[0]+">");
                        if(orderStatus[0] == "1"){
                          myOrderIds.forEach((element) {
                            int idx = myOrderIds.indexOf(element);
                            setState(() {
                              selectedOrderIdForCancelling = myOrderIds[idx].toString();
                              if(myOrderIds[idx].toString() == myOrderIds[myOrderIds.toList().length-1]){
                                flagString = "true";
                              }else{
                                flagString = "false";
                              }
                            });
                            print("selectedOrderIdForCancelling :" + selectedOrderIdForCancelling.toString());
                            cancelOrder(context).whenComplete((){
                              //Navigator.of(context).pop();
                              Fluttertoast.showToast(msg: 'This order has been cancelled', backgroundColor: Colors.black,
                                  textColor: Colors.white
                              );
                              Future.delayed(Duration(seconds: 5), () async {
                                getOrderDetails(context);
                              });
                            });
                          });
                        }else if(orderStatus[0] == "2"){
                          Fluttertoast.showToast(msg: 'This order has been already been delivered', backgroundColor: Colors.black,
                              textColor: Colors.white
                          );
                        }else if(orderStatus[0] == "3"){
                          Fluttertoast.showToast(msg: 'This order has been already been cancelled', backgroundColor: Colors.black,
                              textColor: Colors.white
                          );
                        }
                      },
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: orderStatus == null ? Colors.grey : orderStatus[0] == "2" || orderStatus[0] == "3" ? Colors.grey[400] : Colors.grey,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Center(
                          child: Text("Cancel Order",
                            style: GoogleFonts.nunitoSans(
                              color: orderStatus == null ? Colors.grey : orderStatus[0] == "2" || orderStatus[0] == "3" ? Colors.grey[700] : Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    GestureDetector(
                      onTap: () async {
                        if(orderStatus[0] == "1"){
                          myOrderIds.forEach((element) {
                            int idx = myOrderIds.indexOf(element);
                            setState(() {
                              selectedOrderIdForMarkingAsComplete = myOrderIds[idx].toString();
                              if(myOrderIds[idx].toString() == myOrderIds[myOrderIds.toList().length-1]){
                                flagString = "true";
                              }else{
                                flagString = "false";
                              }
                            });
                            print("selectedOrderIdForMarkingAsComplete :" + selectedOrderIdForMarkingAsComplete.toString());
                            //prOrders3.show();
                            markOrderAsComplete(context).whenComplete((){
                              //Navigator.of(context).pop();
                              Fluttertoast.showToast(msg: 'This order has been marked as delivered', backgroundColor: Colors.black,
                                  textColor: Colors.white
                              );
                              Future.delayed(Duration(seconds: 5), () async {
                                getOrderDetails(context);
                              });
                            });
                          });
                        }else if(orderStatus[0] == "2"){
                          Fluttertoast.showToast(msg: 'This order has been already been delivered', backgroundColor: Colors.black,
                              textColor: Colors.white
                          );
                        }else if(orderStatus[0] == "3"){
                          Fluttertoast.showToast(msg: 'This order has been already been cancelled', backgroundColor: Colors.black,
                              textColor: Colors.white
                          );
                        }
                      },
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: orderStatus == null || orderStatus == "null" ? Colors.green[700] : orderStatus[0] == "2" || orderStatus[0] == "3" ? Colors.grey[400] : Colors.green[700],
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Center(
                          child: Text("Mark As Complete",
                            style: GoogleFonts.nunitoSans(
                              color: orderStatus == null || orderStatus == "null" ? Colors.white : orderStatus[0] == "2" || orderStatus[0] == "3" ? Colors.grey[700] : Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: showOrder == false ? Center(
        child: CircularProgressIndicator(),
      ) : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child://buildItemNamesBuilder(context),

          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Date - "+myOrderDate[0],
                    style: GoogleFonts.nunitoSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text("Time - "+myOrderTime[0],
                    style: GoogleFonts.nunitoSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      //color: Colors.blue,fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),

              GestureDetector(
                onTap: () async {
                  final url = "https://maps.google.com/?q=<"+myOrderDeliveryAddressLat[0]+">,<"+myOrderDeliveryAddressLong[0]+"";//"https://www.google.com/maps/dir/?api=1&origin=" + origin + "&destination=" + address + "&travelmode=driving&dir_action=navigate";
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: Text("Customer Address : "+customerAddress[0].toString(),
                  style: GoogleFonts.nunitoSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                    //color: Colors.green,fontWeight: FontWeight.bold,
                  ),
                ),
              ),


              SizedBox(height: 5,),
              Divider(color: Colors.black,),
              /*
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text("Total Amount (Order + Delivery + Tax + Packing Charges)",
                      style: GoogleFonts.nunitoSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        //color: Colors.green,fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Text(myOrderTotal == null || myOrderTotal == "null" ? "loading" : "Rs. "+myOrderTotal.toString(),
                      style: GoogleFonts.nunitoSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        //color: Colors.red,fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

               */
//              SizedBox(height: 5,),
//              Divider(color: Colors.black,),
              SizedBox(height: 10,),
              Text("Order Items : ",
                style: GoogleFonts.nunitoSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                  //color: Colors.green,fontWeight: FontWeight.bold,
                ),
              ),
              buildItemNamesBuilder(context),
              SizedBox(height: 10,),
              Divider(color: Colors.black,),
              Text("Order Add Ons : ",
                style: GoogleFonts.nunitoSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                  //color: Colors.green,fontWeight: FontWeight.bold,
                ),
              ),
              buildAdOnInfoBuilder(context),
              SizedBox(height: 10,),
              Divider(color: Colors.black,),
              Padding(
                padding: const EdgeInsets.only(left: 10,top: 10, bottom: 10, right: 10),
                child: myOrderAdditionalInfo[0].toString() == "null" || myOrderAdditionalInfo[0].toString() == "" ? Text("Additional Requirements : No Additional Requirements",
                  textScaleFactor: 1,
                  style: GoogleFonts.nunitoSans(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: Colors.orange[900],
                  ),) : Text("Additional Requirements : "+myOrderAdditionalInfo[0],
                  textScaleFactor: 1,
                  style: GoogleFonts.nunitoSans(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Colors.orange[900],
                  ),),
              ),
              SizedBox(height: 10,),
              Divider(color: Colors.black,),
              SizedBox(height: 10,),
              buildOrderNumbersAndStatuses(context),
              SizedBox(height: 10,),
              /*
              SizedBox(height: 5,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Order Total",
                    style: GoogleFonts.nunitoSans(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text("Rs. 110",
                    style: GoogleFonts.nunitoSans(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

               */
            ],
          ),


        ),
      ),
    );
  }

  Widget buildOrderNumbersAndStatuses(BuildContext context){
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: orderIdsListChotaBeta == null ? 0 : orderIdsListChotaBeta.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
//              Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                crossAxisAlignment: CrossAxisAlignment.center,
//                children: [
//                  Text('Order ID : '+orderIdsListChotaBeta[index],textScaleFactor: 1,style: GoogleFonts.nunitoSans(
//                      color: Colors.black,
//                      fontWeight: FontWeight.w600,
//                      fontSize: 12
//                  ),),
//                  Text('Status : '+orderStatusMessagesList[index],textScaleFactor: 1,style: GoogleFonts.nunitoSans(
//                      color: Colors.black,
//                      fontWeight: FontWeight.w600,
//                      fontSize: 12
//                  ),),
//                ],
//              ),
//            GestureDetector(
//              onTap: (){
//                getChotaBetaOrderIds(context);
//              },
//              child: Text('Order ID : '+orderIdsListChotaBeta[index],textScaleFactor: 1,style: GoogleFonts.nunitoSans(
//                  color: Colors.black,
//                  fontWeight: FontWeight.w600,
//                  fontSize: 12
//              ),),
//            ),
            orderStatusMessagesList[index].toString() == "null" ? Container() : Text('Status : '+orderStatusMessagesList[index],textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 12
            ),),
            orderDeliveryBoyName[index].toString() == "null" ? Container() : SizedBox(height: 5,),
//              Text(orderDeliveryBoyId[index].toString() == "null" ? 'orderDeliveryBoyId : Not Available' : 'orderDeliveryBoyId : '+orderDeliveryBoyId[index].toString(),textScaleFactor: 1,style: GoogleFonts.nunitoSans(
//                  color: Colors.black,
//                  fontWeight: FontWeight.w600,
//                  fontSize: 12
//              ),),SizedBox(height: 5,),
            orderDeliveryBoyName[index].toString() == "null" ? Container() : Text(orderDeliveryBoyName[index].toString() == "null" ? 'Delivery Boy Name : Not Available' : 'Delivery Boy Name : '+orderDeliveryBoyName[index].toString(),textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 12
            ),),//SizedBox(height: 5,),
//            GestureDetector(
//              onTap: (){
//                if(orderDeliveryBoyContact[index].toString() == "null"){
//
//                }else{
//                  launch("tel://<"+orderDeliveryBoyContact[index].toString()+">");
//                }
//              },
//              child: Text(orderDeliveryBoyContact[index].toString() == "null" ? 'Delivery Boy Contact No. : Not Available' : 'Delivery Boy Contact No. : '+orderDeliveryBoyContact[index].toString(),textScaleFactor: 1,style: GoogleFonts.nunitoSans(
//                  color: Colors.black,
//                  fontWeight: FontWeight.w600,
//                  fontSize: 12
//              ),),
//            ),
            orderDeliveryBoyStatusText[index].toString() == "null" ? Container() : SizedBox(height: 5,),
            orderDeliveryBoyStatusText[index].toString() == "null" ? Container() : Text(orderDeliveryBoyStatusText[index].toString() == "null" ? 'Delivery Boy Status : Not Available' : 'Delivery Boy Status : '+orderDeliveryBoyStatusText[index].toString(),textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 12
            ),),SizedBox(height: 5,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  orderDeliveryBoyContact[index].toString() == "null" ? Container() : GestureDetector(
                    onTap: (){
                      if(orderDeliveryBoyContact[index].toString() == "null"){

                      }else{
                        launch("tel://<"+orderDeliveryBoyContact[index].toString()+">");
                      }
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.blue[700],
                      child: Icon(
                        Icons.call,
                        color: Colors.white,
                        size: 20,
                      ),
                      radius: 20,
                    ),
                  ),
                  SizedBox(width: 10,),
                  orderDeliveryBoyLat[index].toString() == "null" || orderDeliveryBoyLong[index].toString() == "null" ? Container() : GestureDetector(
                    onTap: () async {
                      final url = "https://maps.google.com/?q=<"+orderDeliveryBoyLat[index]+">,<"+orderDeliveryBoyLong[index]+"";//"https://www.google.com/maps/dir/?api=1&origin=" + origin + "&destination=" + address + "&travelmode=driving&dir_action=navigate";
                      if (await canLaunch(url)) {
                      await launch(url);
                      } else {
                      throw 'Could not launch $url';
                      }
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.blue[700],
                      child: Icon(
                        Icons.pin_drop,
                        color: Colors.white,
                        size: 20,
                      ),
                      radius: 20,
                    ),
                  ),
                ],
              ),SizedBox(height: 5,),
//            GestureDetector(
//              onTap: () async {
//                final url = "https://maps.google.com/?q=<"+orderDeliveryBoyLat[index]+">,<"+orderDeliveryBoyLong[index]+"";//"https://www.google.com/maps/dir/?api=1&origin=" + origin + "&destination=" + address + "&travelmode=driving&dir_action=navigate";
//                if (await canLaunch(url)) {
//                  await launch(url);
//                } else {
//                  throw 'Could not launch $url';
//                }
//              },
//              child: Text('See delivery boy location',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
//                color: Colors.blue,
//                fontWeight: FontWeight.w600,
//                fontSize: 16,
//              ),),
//            ),SizedBox(height: 5,),
            Divider(),
          ],
        ),
      ),
    );
  }

  Widget buildItemNamesBuilder(BuildContext context){
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: myOrderItemNames == null ? 0 : myOrderItemNames.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width/2.4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text((index+1).toString()+". "+myOrderItemNames[index] + " (Qty x " + myOrderQtyItems[index]+")",
                          style: GoogleFonts.nunitoSans(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),SizedBox(height: 5,),
                        Text("Order Type - "+myOrderTypes[index],
                          style: GoogleFonts.nunitoSans(
                            fontSize: 13,
                          ),
                        ),
                        //SizedBox(height: 5,),
                        /*
                        Text("Total Price - Rs. - "+ (int.parse(myOrderItemPrices[index]) * int.parse(myOrderQtyItems[index])).toString(),
                          style: GoogleFonts.nunitoSans(
                            fontSize: 13,
                          ),
                        ),
//                        SizedBox(height: 5,),
//                        Text("Cust. Contact - +91-"+myOrderCustomerContactNumbers[index],
//                          style: GoogleFonts.nunitoSans(
//                            fontSize: 13,
//                            color: Colors.blue,
//                          ),
//                        ),
                        SizedBox(height: 5,),
                        Text("Order Type - "+myOrderTypes[index],
                          style: GoogleFonts.nunitoSans(
                            fontSize: 13,
                          ),
                        ),
//                        SizedBox(height: 5,),
//                        Text("Payment Status - "+myOrderPaymentStatus[index],
//                          style: GoogleFonts.nunitoSans(
//                            fontSize: 13,
//                            color: Colors.green
//                          ),
//                        ),
//                        SizedBox(height: 5,),
//                        Text("Payment Type - "+myOrderPaymentType[index],
//                          style: GoogleFonts.nunitoSans(
//                              fontSize: 13,
//                              color: Colors.red
//                          ),
//                        ),

                         */
                      ],
                    ),
                  ),
                  /*
                  Container(
                    width: MediaQuery.of(context).size.width/2.4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("SKU No- SKU-"+myOrderSkuNo[index],
                          style: GoogleFonts.nunitoSans(
                            fontSize: 13,
                            //fontWeight: FontWeight.bold,
                          ),
                        ),
//                        SizedBox(height: 5,),
//                        Text(widget.orderNumber.toString(),
//                          style: GoogleFonts.nunitoSans(
//                            fontSize: 13,
//                            //fontWeight: FontWeight.bold,
//                          ),
//                        ),
//                        SizedBox(height: 5,),
//                        Text("Date - "+myOrderDate[index],
//                          style: GoogleFonts.nunitoSans(
//                            fontSize: 13,
//                          ),
//                        ),
//                        SizedBox(height: 5,),
//                        Text("Time - "+myOrderTime[index],
//                          style: GoogleFonts.nunitoSans(
//                            fontSize: 13,
//                            color: Colors.blue,
//                          ),
//                        ),
                      ],
                    ),
                  ),

                   */
                ],
              ),
              //SizedBox(height: 10,),
//              Text('Item Description',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
//                  color: Colors.black,
//                  fontWeight: FontWeight.w600,
//                  fontSize: 12
//              ),),SizedBox(height: 5,),
//              Container(
//                width: MediaQuery.of(context).size.width/1.1,
//                decoration: BoxDecoration(
//                    borderRadius: BorderRadius.all(Radius.circular(10)),
//                    border: Border.all(color:Colors.black)
//                ),
//                child: Padding(
//                  padding: const EdgeInsets.only(left: 10,top: 10, bottom: 10, right: 10),
//                  child: Text(myOrderItemDescription[index],
//                    textScaleFactor: 1,
//                    maxLines: 2,
//                    overflow: TextOverflow.ellipsis,
//                    style: GoogleFonts.nunitoSans(
//                      fontWeight: FontWeight.w600,
//                      fontSize: 12,
//                      color: Colors.black
//                  ),),
//                ),
//              ),
            ],
          ),
        )

        /*
        //orderStatuses[index] == "2" || orderStatuses[index] == "3" ? Container() :
        Padding(
          padding: const EdgeInsets.only(top:15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name - Dinner Item Two',//+ itemNames[index],
                        textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 12
                      ),),
                      SizedBox(height: 5,),
//                      Text('Amount- 150',//+itemAmount[index],
//                        textScaleFactor: 1,style: GoogleFonts.nunitoSans(
//                          color: Colors.black,
//                          fontWeight: FontWeight.w600,
//                          fontSize: 12
//                      ),),
//                      SizedBox(height: 5,),
                      InkWell(
                        onTap: (){
                          //launch("tel://<"+customerContact[index]+">");
                        },
                        child: Text('Phone no - 7775049481',//+customerContact[index],
                          textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                            color: Colors.blue[700],
                            fontSize: 12,
                            fontWeight: FontWeight.w600
                        ),),
                      ),SizedBox(height: 5,),
                      Text('Order Type - Breakfast',//+itemType[index],
                        textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 12
                      ),),
                      SizedBox(height: 5,),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('SKU No - SKU-58',//+orderItemIds[index].toString(),
                       textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 12
                      ),),
                      SizedBox(height: 5,),
                      Text('Order Id - '+widget.orderNumber.toString(),//+orderNumbers[index],
                        textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 12
                      ),),SizedBox(height: 5,),
                      Text('Date - 2021-04-21',//+orderDateTime[index].toString().substring(0,10),
                        textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 12
                      ),),SizedBox(height: 5,),
                      Text('Time - 05:35 pm',//+orderDateTime[index].toString().substring(10, 19),
                        textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 12
                      ),),SizedBox(height: 5,),
                    ],
                  ),
                ],
              ),SizedBox(height: 5,),
              Text("Payment Status - Completed",//paymentStatus[index] == "1" ? 'Payment Status - Completed' : 'Payment Status - Pending',
                  textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 12
              ),),SizedBox(height: 5,),
              Text('Payment Type - COD',//+paymentType[index],
                  textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                  color: Colors.red,//paymentType[index] == "COD" ? Colors.red : Colors.green,
                  fontWeight: FontWeight.w600,
                  fontSize: 12
              ),),SizedBox(height: 15,),
              Text('Additional Requirement',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 12
              ),),SizedBox(height: 5,),
              Container(
                width: MediaQuery.of(context).size.width/1.1,
                height: MediaQuery.of(context).size.height/25,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color:Colors.black)
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10,top: 5),
                  child: Text("Order Additional Requirements : Please make it extra crispy!",//orderAditionalRequirement[index] == null || orderAditionalRequirement[index] == "null" ? "No additional requirements" : orderAditionalRequirement[index],
                      textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Colors.black
                  ),),
                ),

              ),SizedBox(height: 10,),
              Text('Description',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 12
              ),),SizedBox(height: 5,),
              Container(
                width: MediaQuery.of(context).size.width/1.1,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color:Colors.black)
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10,top: 10, bottom: 10, right: 10),
                  child: Text("Sample Demo Item Description",textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Colors.black
                  ),),
                ),

              ),SizedBox(height: 10,),
              Text('Address',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 12
              ),),SizedBox(height: 5,),
              Container(
                width: MediaQuery.of(context).size.width/1.1,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color:Colors.black)
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10,top: 10, bottom: 10, right: 100),
                  child: Container(
                    child: Text("Shreyas Hosmani"+" - "+"Customer Address Goes Here...",textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: Colors.black
                    ),),
                  ),
                ),
              ),SizedBox(height: 10,),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () async {
//                      print("thryjtyjryj");
//                      var origin = myAddress[0];
//                      var address = customerAddressSplitted[index];
//                      print(address);
//                      final url = "https://maps.google.com/?q=<"+customerLat[index]+">,<"+customerLong[index]+"";//"https://www.google.com/maps/dir/?api=1&origin=" + origin + "&destination=" + address + "&travelmode=driving&dir_action=navigate";
//                      if (await canLaunch(url)) {
//                        await launch(url);
//                      } else {
//                        throw 'Could not launch $url';
//                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: Colors.blue[700]
                      ),
                      child: Center(
                        child: Text('Google Maps',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold
                        ),),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: (){
//                          prOrders.show();
//                          setState(() {
//                            itemNames = [];
//                            ordersMap = Map();
//                            selectedOrderId = orderIds[index].toString();
//                          });
//                          print(selectedOrderId);
//                          cancelOrder(context);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width/2.3,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: Colors.grey[300],
                          ),
                          child: Center(
                            child: Text('Cancel Order',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                            ),),
                          ),
                        ),
                      ),
                      SizedBox(width: 10,),
                      InkWell(
                        onTap: (){
//                          prOrders.show();
//                          setState(() {
//                            itemNames = [];
//                            ordersMap = Map();
//                            selectedOrderId = orderIds[index].toString();
//                          });
//                          print(selectedOrderId);
//                          markOrderAsComplete(context);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width/2.3,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: Colors.grey[300],
                          ),
                          child: Center(
                            child: Text('Mark as Complete',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                            ),),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10,),
              Divider(),
            ],
          ),
        )

         */

    );
  }

  Widget buildAdOnInfoBuilder(BuildContext context){
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: myOrderAdOnNames == null ? 0 : myOrderAdOnNames.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text((index+1).toString()+". "+myOrderAdOnNames[index].toString() + " (Qty x " + myOrderQtyAdDOns[index]+")",
                style: GoogleFonts.nunitoSans(
                  fontSize: 13,fontWeight: FontWeight.bold,
                ),
              ),
//              SizedBox(height: 10,),
//              Text("Total Price - Rs. " + (int.parse(myOrderAdOnPrices[index]) * int.parse(myOrderQtyAdDOns[index])).toString(),
//                style: GoogleFonts.nunitoSans(
//                  fontSize: 13,
//                ),
//              ),
              SizedBox(height: 5,),
              Text("Order Type - " + myOrderAdsonItemType[index],
                style: GoogleFonts.nunitoSans(
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      /*
        //orderStatuses[index] == "2" || orderStatuses[index] == "3" ? Container() :
        Padding(
          padding: const EdgeInsets.only(top:15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name - Dinner Item Two',//+ itemNames[index],
                        textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 12
                      ),),
                      SizedBox(height: 5,),
//                      Text('Amount- 150',//+itemAmount[index],
//                        textScaleFactor: 1,style: GoogleFonts.nunitoSans(
//                          color: Colors.black,
//                          fontWeight: FontWeight.w600,
//                          fontSize: 12
//                      ),),
//                      SizedBox(height: 5,),
                      InkWell(
                        onTap: (){
                          //launch("tel://<"+customerContact[index]+">");
                        },
                        child: Text('Phone no - 7775049481',//+customerContact[index],
                          textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                            color: Colors.blue[700],
                            fontSize: 12,
                            fontWeight: FontWeight.w600
                        ),),
                      ),SizedBox(height: 5,),
                      Text('Order Type - Breakfast',//+itemType[index],
                        textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 12
                      ),),
                      SizedBox(height: 5,),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('SKU No - SKU-58',//+orderItemIds[index].toString(),
                       textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 12
                      ),),
                      SizedBox(height: 5,),
                      Text('Order Id - '+widget.orderNumber.toString(),//+orderNumbers[index],
                        textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 12
                      ),),SizedBox(height: 5,),
                      Text('Date - 2021-04-21',//+orderDateTime[index].toString().substring(0,10),
                        textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 12
                      ),),SizedBox(height: 5,),
                      Text('Time - 05:35 pm',//+orderDateTime[index].toString().substring(10, 19),
                        textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 12
                      ),),SizedBox(height: 5,),
                    ],
                  ),
                ],
              ),SizedBox(height: 5,),
              Text("Payment Status - Completed",//paymentStatus[index] == "1" ? 'Payment Status - Completed' : 'Payment Status - Pending',
                  textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 12
              ),),SizedBox(height: 5,),
              Text('Payment Type - COD',//+paymentType[index],
                  textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                  color: Colors.red,//paymentType[index] == "COD" ? Colors.red : Colors.green,
                  fontWeight: FontWeight.w600,
                  fontSize: 12
              ),),SizedBox(height: 15,),
              Text('Additional Requirement',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 12
              ),),SizedBox(height: 5,),
              Container(
                width: MediaQuery.of(context).size.width/1.1,
                height: MediaQuery.of(context).size.height/25,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color:Colors.black)
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10,top: 5),
                  child: Text("Order Additional Requirements : Please make it extra crispy!",//orderAditionalRequirement[index] == null || orderAditionalRequirement[index] == "null" ? "No additional requirements" : orderAditionalRequirement[index],
                      textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Colors.black
                  ),),
                ),

              ),SizedBox(height: 10,),
              Text('Description',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 12
              ),),SizedBox(height: 5,),
              Container(
                width: MediaQuery.of(context).size.width/1.1,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color:Colors.black)
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10,top: 10, bottom: 10, right: 10),
                  child: Text("Sample Demo Item Description",textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Colors.black
                  ),),
                ),

              ),SizedBox(height: 10,),
              Text('Address',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 12
              ),),SizedBox(height: 5,),
              Container(
                width: MediaQuery.of(context).size.width/1.1,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color:Colors.black)
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10,top: 10, bottom: 10, right: 100),
                  child: Container(
                    child: Text("Shreyas Hosmani"+" - "+"Customer Address Goes Here...",textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: Colors.black
                    ),),
                  ),
                ),
              ),SizedBox(height: 10,),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () async {
//                      print("thryjtyjryj");
//                      var origin = myAddress[0];
//                      var address = customerAddressSplitted[index];
//                      print(address);
//                      final url = "https://maps.google.com/?q=<"+customerLat[index]+">,<"+customerLong[index]+"";//"https://www.google.com/maps/dir/?api=1&origin=" + origin + "&destination=" + address + "&travelmode=driving&dir_action=navigate";
//                      if (await canLaunch(url)) {
//                        await launch(url);
//                      } else {
//                        throw 'Could not launch $url';
//                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: Colors.blue[700]
                      ),
                      child: Center(
                        child: Text('Google Maps',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold
                        ),),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: (){
//                          prOrders.show();
//                          setState(() {
//                            itemNames = [];
//                            ordersMap = Map();
//                            selectedOrderId = orderIds[index].toString();
//                          });
//                          print(selectedOrderId);
//                          cancelOrder(context);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width/2.3,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: Colors.grey[300],
                          ),
                          child: Center(
                            child: Text('Cancel Order',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                            ),),
                          ),
                        ),
                      ),
                      SizedBox(width: 10,),
                      InkWell(
                        onTap: (){
//                          prOrders.show();
//                          setState(() {
//                            itemNames = [];
//                            ordersMap = Map();
//                            selectedOrderId = orderIds[index].toString();
//                          });
//                          print(selectedOrderId);
//                          markOrderAsComplete(context);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width/2.3,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: Colors.grey[300],
                          ),
                          child: Center(
                            child: Text('Mark as Complete',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                            ),),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10,),
              Divider(),
            ],
          ),
        )

         */
    );
  }

  /*
  Widget temp(BuildContext context){
    return Container(
      child: ListView.builder(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: providerListener.ChotaBetaOrderList.length,
        itemBuilder: (context, index) => InkWell(
          onTap: () {},
          child: Container(
            margin: EdgeInsets.only(bottom: 10),
            padding: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(7)),
              color: Color(COLOR_TEXT_WHITE),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 0.5,
                  blurRadius: 4,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /* Padding(
                            padding: EdgeInsets.only(left: 5, right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {},
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0, right: 10),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            width: screenWidth - 100,
                                            child: Text(
                                              '#' +
                                                  providerListener
                                                      .ChotaBetaOrderList[index]
                                                      .chotabetaOrderid,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.nunitoSans(
                                                color: Color(COLOR_TEXT_BLACK),
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                //  buildAdsonCartPlusMinusButton(context, index),
                              ],
                            ),
                          ),*/
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 0, right: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width: screenWidth - 100,
                                  child: Text(
                                    'Status: ' +
                                        providerListener
                                            .delivery_boy_status_text[
                                        index] ??
                                        "",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.nunitoSans(
                                      color: Color(COLOR_TEXT_BLACK),
                                      fontSize: 17,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      //  buildAdsonCartPlusMinusButton(context, index),
                    ],
                  ),
                ),
                providerListener.delivery_boy_name[index] == "NA"
                    ? SizedBox(height: 20)
                    : SizedBox(height: 1),
                providerListener.delivery_boy_name[index] != "NA"
                    ? Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 0, right: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width: screenWidth - 100,
                                  child: Text(
                                    'Delivery Boy Name: ' +
                                        providerListener
                                            .delivery_boy_name[
                                        index] ??
                                        "",
                                    maxLines: 2,
                                    overflow:
                                    TextOverflow.ellipsis,
                                    style:
                                    GoogleFonts.nunitoSans(
                                      color: Color(
                                          COLOR_TEXT_BLACK),
                                      fontSize: 17,
                                      fontWeight:
                                      FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      //  buildAdsonCartPlusMinusButton(context, index),
                    ],
                  ),
                )
                    : SizedBox(height: 1),
                providerListener.delivery_boy_name[index] != "NA"
                    ? Padding(
                  padding: EdgeInsets.only(
                      top: 0, left: 10, right: 20, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () async {
                          if ((providerListener
                              .delivery_boy_latitude[
                          index] ??
                              "") !=
                              "NA") {
                            final url = "https://maps.google.com/?q=<" +
                                (providerListener
                                    .delivery_boy_latitude[
                                index] ??
                                    "") +
                                ">,<" +
                                (providerListener
                                    .delivery_boy_longitude[
                                index] ??
                                    "") +
                                "";
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          } else {
                            snackbarCommon(context,
                                "Delivery boy not assigned");
                          }
                        },
                        child: CircleAvatar(
                          backgroundColor: Color(COLOR_PRIMARY),
                          child: Icon(
                            Icons.gps_fixed_sharp,
                            color: Colors.white,
                            size: 20,
                          ),
                          radius: 20,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onTap: () {
                          if ((providerListener
                              .delivery_boy_mobile[
                          index] ??
                              "") !=
                              "NA") {
                            launch("tel://" +
                                (providerListener
                                    .delivery_boy_mobile[
                                index] ??
                                    ""));
                          } else {
                            snackbarCommon(context,
                                "Delivery boy not assigned");
                          }
                        },
                        child: CircleAvatar(
                          backgroundColor: Color(COLOR_PRIMARY),
                          child: Icon(
                            Icons.call,
                            color: Colors.white,
                            size: 20,
                          ),
                          radius: 20,
                        ),
                      ),
                    ],
                  ),
                )
                    : SizedBox(height: 1),
              ],
            ),
          ),
        ),
      ),
    );
  }

   */

}
