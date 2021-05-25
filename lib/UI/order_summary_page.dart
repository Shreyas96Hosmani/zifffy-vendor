import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'data/login_data.dart' as login;
import 'package:http/http.dart' as http;
import 'package:vendor_dabbawala/UI/data/globals_data.dart' as globals;
import 'dart:convert';

ProgressDialog prOrders;

var orderIds;
var orderItemIds;
var orderStatuses;

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

bool showOrders = false;

var selectedOrderId;

class OrderSummaryPage extends StatefulWidget {
  @override
  _OrderSummaryPageState createState() => _OrderSummaryPageState();
}

class _OrderSummaryPageState extends State<OrderSummaryPage> {

  Widget appBarTitle = new Text("AppBar Title");
  Icon actionIcon = new Icon(Icons.search,color: Colors.black,);

  Future<String> getOrders(context) async {

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

  Future<String> cancelOrder(context) async {

    String url = globals.apiUrl + "cancelcustomerorder.php";

    http.post(url, body: {

      "orderID": selectedOrderId.toString(),

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

          Fluttertoast.showToast(msg: 'This order has been cancelled', backgroundColor: Colors.black,
            textColor: Colors.white
          ).whenComplete((){
            getOrders(context);
          });

          prOrders.hide();

        }else{

          Fluttertoast.showToast(msg: 'Please check your network connection!', backgroundColor: Colors.black,
              textColor: Colors.white
          );
          prOrders.hide();

        }
      }
    });
  }

  Future<String> markOrderAsComplete(context) async {

    String url = globals.apiUrl + "markasdeliveredorder.php";

    http.post(url, body: {

      "orderID": selectedOrderId.toString(),

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

          Fluttertoast.showToast(msg: 'This order has been marked as delivered', backgroundColor: Colors.black,
              textColor: Colors.white
          ).whenComplete((){
            getOrders(context);
          });

          prOrders.hide();

        }else{

          Fluttertoast.showToast(msg: 'Please check your network connection!', backgroundColor: Colors.black,
              textColor: Colors.white
          );
          prOrders.hide();

        }
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    totalOrdersTillDate = null;
    showOrders = false;
    selectedOrderId = null;
    getOrders(context);
    itemNames = [];
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
    prOrders = ProgressDialog(context);
    return itemNames.isEmpty ? Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text("You have not received any orders yet"),
      ),
    ) : Scaffold(
      backgroundColor: Colors.white,
      appBar:buildAppBar(context),
      body: buildItems(context),
//      Center(
//        child: Container(width: MediaQuery.of(context).size.width/1.05,
//          height: MediaQuery.of(context).size.height/1,
//          decoration: BoxDecoration(
//              borderRadius: BorderRadius.all(Radius.circular(10)),
//              border: Border.all(color: Colors.black.withOpacity(0.5))
//          ),
//          child: SingleChildScrollView(
//            child: Column(
//              children: [
//                SizedBox(height: 10,),
//                buildNumberOfOrders(context),
//                buildOrderDetailsText(context),
//                buildSearchBar(context),
//                buildItems(context)
//              ],
//            ),
//          ),
//        ),
//      ),
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

  Widget buildNumberOfOrders(BuildContext context){
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 5,right: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Medu Wada :',style: GoogleFonts.nunitoSans(
                fontWeight: FontWeight.w600,
                fontSize: 15
              ),),
              Text('1',style: GoogleFonts.nunitoSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 15
              ),),
              Text('Medu Wada :',style: GoogleFonts.nunitoSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 15
              ),),
              Text('1',style: GoogleFonts.nunitoSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 15
              ),)
            ],
          ),
        ),
        SizedBox(height: 5,),
        Padding(
          padding: const EdgeInsets.only(left: 5,right: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Chutney :',style: GoogleFonts.nunitoSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 15
              ),),
              Text('1',style: GoogleFonts.nunitoSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 15
              ),),
              Text('Sambar :',style: GoogleFonts.nunitoSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 15
              ),),
              Text('1',style: GoogleFonts.nunitoSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 15
              ),)
            ],
          ),
        ),
        SizedBox(height: 5,),
        Padding(
          padding: const EdgeInsets.only(left: 5,right: 5, bottom: 10),
          child: Divider(
            height: 10,
            thickness: 0.5,
            color: Colors.grey,
          ),
        )
      ],
    );
  }
  Widget buildNumberOfOrders1(BuildContext context){
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 5,right: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Chapati :',style: GoogleFonts.nunitoSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 15
              ),),
              Text('2',style: GoogleFonts.nunitoSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 15
              ),),
              Text('Rice :',style: GoogleFonts.nunitoSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 15
              ),),
              Text('2',style: GoogleFonts.nunitoSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 15
              ),)
            ],
          ),
        ),
        SizedBox(height: 5,),
        Padding(
          padding: const EdgeInsets.only(left: 5,right: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Gulab Jamun :',style: GoogleFonts.nunitoSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 15
              ),),
              Text('3',style: GoogleFonts.nunitoSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 15
              ),),
              Text('Papad :',style: GoogleFonts.nunitoSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 15
              ),),
              Text('3',style: GoogleFonts.nunitoSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 15
              ),)
            ],
          ),
        ),
        SizedBox(height: 5,),
        Padding(
          padding: const EdgeInsets.only(left: 5,right: 5, bottom: 10),
          child: Divider(
            height: 10,
            thickness: 0.5,
            color: Colors.grey,
          ),
        )
      ],
    );
  }
  Widget buildNumberOfOrders2(BuildContext context){
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 5,right: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Chole :',style: GoogleFonts.nunitoSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 15
              ),),
              Text('1',style: GoogleFonts.nunitoSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 15
              ),),
              Text('Bhature :',style: GoogleFonts.nunitoSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 15
              ),),
              Text('5',style: GoogleFonts.nunitoSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 15
              ),)
            ],
          ),
        ),
        SizedBox(height: 5,),
        Padding(
          padding: const EdgeInsets.only(left: 5,right: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Gulab Jamun :',style: GoogleFonts.nunitoSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 15
              ),),
              Text('1',style: GoogleFonts.nunitoSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 15
              ),),
              Text('Carrot Halwa :',style: GoogleFonts.nunitoSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 15
              ),),
              Text('2',style: GoogleFonts.nunitoSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 15
              ),)
            ],
          ),
        ),
        SizedBox(height: 5,),
        Padding(
          padding: const EdgeInsets.only(left: 5,right: 5, bottom: 10),
          child: Divider(
            height: 10,
            thickness: 0.5,
            color: Colors.grey,
          ),
        )
      ],
    );
  }

  Widget buildOrderDetailsText(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 10,right: 10),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height/25,
        child: Text('Order Details :',textScaleFactor: 1,
        style: GoogleFonts.nunitoSans(
          fontSize: 17,
          fontWeight: FontWeight.bold
        ),),
      ),
    );
  }

  Widget buildSearchBar(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 10,right: 10),
      child: Row(
        children: [

          Icon(Icons.search),
          SizedBox(width: 10,),
          Container(
            width: MediaQuery.of(context).size.width/1.3,
            height: MediaQuery.of(context).size.height/25,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              border: Border.all(color: Colors.black)
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10,top: 5),
              child: Text('Search',style: GoogleFonts.nunitoSans(
                color: Colors.grey[400]
              ),),
            ),
          )

        ],
      ),
    );
  }

  Widget buildItems(BuildContext context){
    return Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(left: 15,right: 15),
        child: Stack(
          children: [
            Positioned(
              left: 0, right: 0, top: 0,
              child: Container(
                height: 110,
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
                              Text("$key",textScaleFactor: 1,),
                              Text("${ordersMap[key]}",textScaleFactor: 1,)
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
            ),
//            Container(
//              decoration: BoxDecoration(
//                border: Border.all(color: Colors.black),
//                borderRadius: BorderRadius.all(Radius.circular(5)),
//              ),
//              child: Padding(
//                padding: const EdgeInsets.all(15.0),
//                child: Text(ordersMap.toString(),
//                  style: GoogleFonts.nunitoSans(
//                    fontSize: 18,
//                  ),
//                ),
//              ),
//            ),
            Padding(
              padding: const EdgeInsets.only(top: 120),
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: orderNumbers == null ? 0 : orderNumbers.length,
                  itemBuilder: (context, index) =>
                  orderStatuses[index] == "2" || orderStatuses[index] == "3" ? Container() : Padding(
                        padding: const EdgeInsets.only(top:15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
//                      orderNumbers[index] == "DW-PUN004" ? buildNumberOfOrders1(context) :
//                      orderNumbers[index] == "DW-PUN003" ? buildNumberOfOrders2(context) :
//                      orderNumbers[index] == "DW-PUN005" ? buildNumberOfOrders(context)
//                          : Container(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Name - '+ itemNames[index],textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12
                                    ),),
                                    SizedBox(height: 5,),
                                    Text('Amount-'+itemAmount[index],textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12
                                    ),),
                                    SizedBox(height: 5,),
                                    InkWell(
                                      onTap: (){
                                        launch("tel://<"+customerContact[index]+">");
                                      },
                                      child: Text('Phone no - '+customerContact[index],textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                                          color: Colors.blue[700],
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600
                                      ),),
                                    ),SizedBox(height: 5,),
                                    Text('Order Type - '+itemType[index],textScaleFactor: 1,style: GoogleFonts.nunitoSans(
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
                                    Text('SKU No - SKU-'+orderItemIds[index].toString(),textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12
                                    ),),
                                    SizedBox(height: 5,),
                                    Text('Order Id - '+orderNumbers[index],textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12
                                    ),),SizedBox(height: 5,),
                                    Text('Date - '+orderDateTime[index].toString().substring(0,10),textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12
                                    ),),SizedBox(height: 5,),
                                    Text('Time - '+orderDateTime[index].toString().substring(10, 19),textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12
                                    ),),SizedBox(height: 5,),
                                  ],
                                ),
                              ],
                            ),SizedBox(height: 5,),
                            Text(paymentStatus[index] == "1" ? 'Payment Status - Completed' : 'Payment Status - Pending',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 12
                            ),),SizedBox(height: 5,),
                            Text('Payment Type - '+paymentType[index],textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                                color: paymentType[index] == "COD" ? Colors.red : Colors.green,
                                fontWeight: FontWeight.w600,
                                fontSize: 12
                            ),),SizedBox(height: 15,),
//                            index == 0 ? Text('AdOns - \nEx.Chutney, Ex.Sambar.',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
//                                color: Colors.blue,
//                                fontWeight: FontWeight.w600,
//                                fontSize: 12
//                            ),) : Container(),index == 0 ? SizedBox(height: 15,) : Container(),
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
                                child: Text(orderAditionalRequirement[index] == null || orderAditionalRequirement[index] == "null" ? "No additional requirements" : orderAditionalRequirement[index],textScaleFactor: 1,style: GoogleFonts.nunitoSans(
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
                                child: Text(itemDescription[index],textScaleFactor: 1,style: GoogleFonts.nunitoSans(
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
                                  child: Text(customerName[index]+" - "+customerAddress[index],textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      color: Colors.black
                                  ),),
                                ),
                              ),
                            ),SizedBox(height: 10,),
//                            orderStatuses[index] == "3" ? Container(
//                              width: MediaQuery.of(context).size.width,
//                              height: 35,
//                              decoration: BoxDecoration(
//                                borderRadius: BorderRadius.all(Radius.circular(5)),
//                                color: Colors.red,
//                              ),
//                              child: Center(
//                                child: Text('This order has been cancelled',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
//                                    color: Colors.white,
//                                    fontSize: 14,
//                                    fontWeight: FontWeight.bold
//                                ),),
//                              ),
//                            ) : orderStatuses[index] == "2" ? Container(
//                              width: MediaQuery.of(context).size.width,
//                              height: 35,
//                              decoration: BoxDecoration(
//                                borderRadius: BorderRadius.all(Radius.circular(5)),
//                                color: Colors.green,
//                              ),
//                              child: Center(
//                                child: Text('This order has been delivered',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
//                                    color: Colors.white,
//                                    fontSize: 14,
//                                    fontWeight: FontWeight.bold
//                                ),),
//                              ),
//                            ) :
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    print("thryjtyjryj");
                                    var origin = myAddress[0];
                                    var address = customerAddressSplitted[index];
                                    print(address);
                                    final url = "https://maps.google.com/?q=<"+customerLat[index]+">,<"+customerLong[index]+"";//"https://www.google.com/maps/dir/?api=1&origin=" + origin + "&destination=" + address + "&travelmode=driving&dir_action=navigate";
                                    if (await canLaunch(url)) {
                                      await launch(url);
                                    } else {
                                      throw 'Could not launch $url';
                                    }
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
                                          fontSize: 14,
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
                                        prOrders.show();
                                        setState(() {
                                          itemNames = [];
                                          ordersMap = Map();
                                          selectedOrderId = orderIds[index].toString();
                                        });
                                        print(selectedOrderId);
                                        cancelOrder(context);
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
                                        prOrders.show();
                                        setState(() {
                                          itemNames = [];
                                          ordersMap = Map();
                                          selectedOrderId = orderIds[index].toString();
                                        });
                                        print(selectedOrderId);
                                        markOrderAsComplete(context);
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

              ),
            ),
          ],
        )) ;

  }

}
