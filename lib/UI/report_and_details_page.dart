import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'data/login_data.dart' as login;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:progress_dialog/progress_dialog.dart';

var startDate;
var endDate;
ProgressDialog prDownload;
var salesDownloadReportUrl;

class ReportAndDetailsPage extends StatefulWidget {
  @override
  _ReportAndDetailsPageState createState() => _ReportAndDetailsPageState();
}

class _ReportAndDetailsPageState extends State<ReportAndDetailsPage> {

  Future<String> getReportDetails(context) async {

    String url = "https://admin.dabbawala.ml/excelreports/salesreports.php";

    http.post(url, body: {

      "fromdate": startDate.toString(),
      "todate" : endDate.toString(),
      "vendorID" : login.storedUserId.toString(),

    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");

      }
      var responseArrayGetOrders = jsonDecode(response.body);
      print(responseArrayGetOrders);

      var msg = responseArrayGetOrders['message'].toString();
      if(msg == "Found"){
        prDownload.hide();
        setState(() {
          salesDownloadReportUrl = "https://admin.dabbawala.ml/excelreports/"+responseArrayGetOrders['data'].toString();
        });
        print(salesDownloadReportUrl);
        launch(salesDownloadReportUrl);
      }else{
        prDownload.hide();
        Fluttertoast.showToast(msg: 'Please check your network connection!', backgroundColor: Colors.black, textColor: Colors.white);
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
  }

  @override
  Widget build(BuildContext context) {
    prDownload = ProgressDialog(context);
    return Scaffold(
      key:login.scaffoldKey,
      endDrawer: buildAppDrawer(context),
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width/1.2,
          height: MediaQuery.of(context).size.height/1.4,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: Colors.black.withOpacity(0.5))
          ),
          child: Column(
            children: [
              SizedBox(height: 10,),
              buildSalesReport(context),
              SizedBox(height: 20,),
              buildDownloadReportContainer(context),
              SizedBox(height: 30,),
              buildSettlemetReport(context),
              SizedBox(height: 20,),
              buildDownloadReportSettlementContainer(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAppBar(BuildContext context){
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0,
      leading: InkWell(
          onTap: (){
            Navigator.of(context).pop();
          },
          child: Icon(Icons.arrow_back_outlined,color: Colors.black,)),
      title: Text('Report And Details',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.blue[700]
      ),),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: InkWell(
              onTap: () => _openEndDrawer(),

              child: Icon(Icons.menu,color: Colors.black,)),
        )
      ],
    );
  }

  Widget buildSalesReport(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Sales Report',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
              fontWeight: FontWeight.bold,
              fontSize: 17
          ),),
          SizedBox(height: 20,),
          Row(
            children: [
              Text('Start Date :',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w600
              ),),
              SizedBox(width: 20,),
              InkWell(
                onTap: (){
                  DatePicker.showDatePicker(context,
                      showTitleActions: true,
                      minTime: DateTime(2021, 1, 1),
                      maxTime: DateTime(2099, 1, 1), onChanged: (date) {
                        print('change $date');
                        setState(() {
                          startDate = date.toString().substring(0,10);
                        });
                        print(startDate);
                      }, onConfirm: (date) {
                        print('confirm $date');
                        setState(() {
                          startDate = date.toString().substring(0,10);
                        });
                        print(startDate);
                      }, currentTime: DateTime.now(), locale: LocaleType.en);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width/3,
                  height: MediaQuery.of(context).size.height/20,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      border: Border.all(color: Colors.black)
                  ),
                  child: Center(
                    child: Text(startDate == null ? "select date" : startDate,textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                        fontWeight: FontWeight.w600,
                        fontSize: 17
                    ),),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 20,),
          Row(
            children: [
              Text('End Date :',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w600
              ),),
              SizedBox(width: 27,),
              InkWell(
                onTap: (){
                  DatePicker.showDatePicker(context,
                      showTitleActions: true,
                      minTime: DateTime(2021, 1, 1),
                      maxTime: DateTime(2099, 1, 1), onChanged: (date) {
                        print('change $date');
                        setState(() {
                          endDate = date.toString().substring(0,10);
                        });
                        print(endDate);
                      }, onConfirm: (date) {
                        print('confirm $date');
                        setState(() {
                          endDate = date.toString().substring(0,10);
                        });
                        print(endDate);
                      }, currentTime: DateTime.now(), locale: LocaleType.en);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width/3,
                  height: MediaQuery.of(context).size.height/20,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      border: Border.all(color: Colors.black)
                  ),
                  child: Center(
                    child: Text(endDate == null ? "select date" : endDate,textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                        fontWeight: FontWeight.w600,
                        fontSize: 17
                    ),),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget buildDownloadReportContainer(BuildContext context){
    return Center(
      child: GestureDetector(
        onTap: (){
          if(startDate == null || endDate == null){
            Fluttertoast.showToast(msg: 'Please select start and end date', backgroundColor: Colors.black, textColor: Colors.white);
          }else{
            prDownload.show();
            getReportDetails(context);
            //launch("https://admin.dabbawala.ml/appdata/all.csv");
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width/1.3,
          height: MediaQuery.of(context).size.height/15,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: Colors.blue[700],
            boxShadow: [BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 10,
            )],
          ),
          child: Center(
            child: Text('Download Report (CSV Format)',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold
            ),),
          ),
        ),
      ),
    );
  }

  Widget buildSettlemetReport(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Settlement Report',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
              fontWeight: FontWeight.bold,
              fontSize: 17
          ),),
          SizedBox(height: 20,),
          Row(
            children: [
              Text('Start Date :',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w600
              ),),
              SizedBox(width: 20,),
              Container(
                width: MediaQuery.of(context).size.width/3,
                height: MediaQuery.of(context).size.height/20,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    border: Border.all(color: Colors.black)
                ),
                child: Center(
                  child: Text('12/12/2020',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                      fontWeight: FontWeight.w600,
                      fontSize: 17
                  ),),
                ),
              )
            ],
          ),
          SizedBox(height: 20,),
          Row(
            children: [
              Text('End Date :',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w600
              ),),
              SizedBox(width: 27,),

              Container(
                width: MediaQuery.of(context).size.width/3,
                height: MediaQuery.of(context).size.height/20,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    border: Border.all(color: Colors.black)
                ),
                child: Center(
                  child: Text('12/12/2020',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                      fontWeight: FontWeight.w600,
                      fontSize: 17
                  ),),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget buildDownloadReportSettlementContainer(BuildContext context){
    return Center(
      child: GestureDetector(
        onTap: (){
          Fluttertoast.showToast(msg: 'Coming soon', backgroundColor: Colors.black, textColor: Colors.white);
        },
        child: Container(
          width: MediaQuery.of(context).size.width/1.3,
          height: MediaQuery.of(context).size.height/15,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: Colors.blue[700],
            boxShadow: [BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 10,
            )],
          ),
          child: Center(
            child: Text('Download Report (CSV Format)',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold
            ),),
          ),
        ),
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
