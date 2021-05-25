import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:vendor_dabbawala/UI/add_item_page_for_manage.dart';
import 'package:vendor_dabbawala/UI/addons_page.dart';
import 'package:vendor_dabbawala/UI/edit_item_availability.dart';
import 'package:vendor_dabbawala/UI/manage_item_images.dart';
import 'data/manage_menu_data.dart' as manage;
import 'data/login_data.dart' as login;
import 'manage_subitems_page.dart';

class ManageMenuPage extends StatefulWidget {
  final itemId;
  final name;
  final cuisine;
  final amount;
  final price;
  final description;
  final type;
  final status;
  final category;
  final blsd;
  ManageMenuPage(this.itemId, this.name, this.cuisine, this.amount, this.price, this.description, this.type, this.status, this.category, this.blsd) : super();
  @override
  _ManageMenuPageState createState() => _ManageMenuPageState();
}

class _ManageMenuPageState extends State<ManageMenuPage> {

  int _value = 1;

  void _openEndDrawer() {
    login.scaffoldKey.currentState.openEndDrawer();
  }

  String dropdownValue = 'Paneer Tikka';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key:login.scaffoldKey,
      endDrawer: buildAppDrawer(context),
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          manage1(context),
          SizedBox(height: 20,),
          manage5(context),
          SizedBox(height: 20,),
          manage2(context),
          SizedBox(height: 20,),
          manage3(context),
          SizedBox(height: 20,),
          manage4(context),
        ],
      ),
    );
  }

  Widget buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
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
      title: Text(
        'Manage Menu',textScaleFactor: 1,
        style: GoogleFonts.nunitoSans(
            color: Colors.blue[700], fontSize: 20, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
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

  Widget buildSelectItemField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10,right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Name',textScaleFactor: 1,
            style:
                GoogleFonts.nunitoSans(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          Container(
            width: MediaQuery.of(context).size.width/1.56,
            height: MediaQuery.of(context).size.height/15.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: Colors.black),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 15,top: 13),
              child: Text('Fish Curry',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                fontSize: 17,fontWeight: FontWeight.w600
              ),),
            )
          )
        ],
      ),
    );
  }

  Widget buildUpdateQuantityField(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Amount ',textScaleFactor: 1,
            style: GoogleFonts.nunitoSans(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width/8,
          ),
          Container(
            width: MediaQuery.of(context).size.width / 3,
            height: MediaQuery.of(context).size.height / 15,
            child: TextFormField(
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
          SizedBox(
            width: MediaQuery.of(context).size.width/28.8,
          ),
          Container(
            width: MediaQuery.of(context).size.width / 3.5,
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
                    value: _value,
                    items: [
                      DropdownMenuItem(
                        child: Text("gms"),
                        value: 1,
                      ),
                      DropdownMenuItem(
                        child: Text("ml"),
                        value: 2,
                      ),
                      DropdownMenuItem(
                        child: Text("pcs"),
                        value: 3,
                      ),

                    ],
                    onChanged: (value) {
                      setState(() {
                        _value = value;
                      });
                    }),
              ),
            ),
          )

        ],
      ),
    );
  }

  Widget buildMealTimeRow(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 10,right: 10),
      child: Row(
        children: [
          Text('Meal Time',style: GoogleFonts.nunitoSans(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),),
          SizedBox(width: 5,),

          GestureDetector(
            onTap: (){
              setState(() {
              manage.index[0]=1;
              });
            },
            child:manage.index[0] == 0 ? Container(
              width: MediaQuery.of(context).size.width/25,
              height: MediaQuery.of(context).size.height/45,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
            ) : GestureDetector(
              onTap: (){
                setState(() {
                  manage.index[0]=0;

                });
              },
              child: Container(
                width: MediaQuery.of(context).size.width/25,
                height: MediaQuery.of(context).size.height/45,
                decoration: BoxDecoration(
                  color: Colors.blue[700],
                  border: Border.all(color: Colors.black),
                ),
              ),
            )
          ),
          SizedBox(width: 5,),
          Text('BreakFast',style: GoogleFonts.nunitoSans(
            fontSize: 14,
            fontWeight: FontWeight.w600
          ),),
          SizedBox(width: 10,),
          GestureDetector(
            onTap: (){
              setState(() {
                manage.index[1]=1;
              });
            },
            child: manage.index[1] == 0 ? Container(
              width: MediaQuery.of(context).size.width/25,
              height: MediaQuery.of(context).size.height/45,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
            ) : GestureDetector(
              onTap: (){
                setState(() {
                  manage.index[1]=0;
                });
              },
              child: Container(
                width: MediaQuery.of(context).size.width/25,
                height: MediaQuery.of(context).size.height/45,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  color: Colors.blue[700]
                ),
              ),
            )
          ),
          SizedBox(width: 5,),
          Text('Lunch',style: GoogleFonts.nunitoSans(
              fontSize: 14,
              fontWeight: FontWeight.w600
          ),),
          SizedBox(width: 10,),
          GestureDetector(
            onTap: (){
              setState(() {
                manage.index[2]=1;
              });
            },
            child: manage.index[2] == 0 ? Container(
              width: MediaQuery.of(context).size.width/25,
              height: MediaQuery.of(context).size.height/45,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
            ) : GestureDetector(
              onTap: (){
                setState(() {
                  manage.index[2]=0;
                });
              },
              child: Container(
                width: MediaQuery.of(context).size.width/25,
                height: MediaQuery.of(context).size.height/45,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  color: Colors.blue[700]
                ),
              ),
            )
          ),
          SizedBox(width:5,),
          Text('Dinner',style: GoogleFonts.nunitoSans(
              fontSize: 16,
              fontWeight: FontWeight.w600
          ),),
          GestureDetector(
              onTap: (){
                setState(() {
                  manage.index[2]=1;
                });
              },
              child: manage.index[2] == 0 ? Container(
                width: MediaQuery.of(context).size.width/25,
                height: MediaQuery.of(context).size.height/45,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
              ) : GestureDetector(
                onTap: (){
                  setState(() {
                    manage.index[2]=0;
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width/25,
                  height: MediaQuery.of(context).size.height/45,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      color: Colors.blue[700]
                  ),
                ),
              )
          ),
          SizedBox(width:5,),
          Text('Snacks',style: GoogleFonts.nunitoSans(
              fontSize: 14,
              fontWeight: FontWeight.w600
          ),)
        ],
      ),
    );
  }

  Widget buildCuisineField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            width: MediaQuery.of(context).size.width / 2.6,
            height: MediaQuery.of(context).size.height / 15,
            padding: EdgeInsets.all(0.0),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.all(Radius.circular(10))
            ),
            child: Align(
              alignment: Alignment.center,
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                    elevation: 0,
                    value: _value,
                    items: [
                      DropdownMenuItem(
                        child: Text("North Indian"),
                        value: 1,
                      ),
                      DropdownMenuItem(
                        child: Text("South Indian"),
                        value: 2,
                      ),
                      DropdownMenuItem(
                          child: Text("Bengali"),
                          value: 3
                      ),
                      DropdownMenuItem(
                          child: Text("Gujrati"),
                          value: 4
                      ),
                      DropdownMenuItem(
                        child: Text("Italian"),
                        value: 5,
                      ),
                      DropdownMenuItem(
                        child: Text("Mexican"),
                        value: 6,
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _value = value;
                      });
                    }),
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
                    value: _value,
                    items: [
                      DropdownMenuItem(
                        child: Text("Breakfast"),
                        value: 1,
                      ),
                      DropdownMenuItem(
                        child: Text("Lunch"),
                        value: 2,
                      ),
                      DropdownMenuItem(
                          child: Text("Dinner"),
                          value: 3
                      ),
                      DropdownMenuItem(
                          child: Text("Snacks"),
                          value: 4
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _value = value;
                      });
                    }),
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

  Widget buildCategoryField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    value: _value,
                    items: [
                      DropdownMenuItem(
                        child: Text("Veg"),
                        value: 1,
                      ),
                      DropdownMenuItem(
                        child: Text("Non-Veg"),
                        value: 2,
                      ),

                    ],
                    onChanged: (value) {
                      setState(() {
                        _value = value;
                      });
                    }),
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
          child: Row(
            children: [
              Container (
                width: MediaQuery.of(context).size.width / 1.06,
                height: MediaQuery.of(context).size.height / 8,
                child: TextFormField(
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
              )


            ],
          ),
        ),
      ],
    );
  }

  Widget buildAddOns(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 10,right: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        width: MediaQuery.of(context).size.width,
        child: MultiSelectFormField(
          chipBackGroundColor: Colors.blue[700],
          chipLabelStyle: GoogleFonts.nunitoSans(
            color: Colors.white,
            fontWeight: FontWeight.w600
          ),
          fillColor: Colors.white,
          hintWidget: Text('Items'),
          title: Text('Add-On',style: GoogleFonts.nunitoSans(
            fontSize: 16,
            fontWeight: FontWeight.bold
          ),),
          autovalidate: false,
          dataSource: [

            {
              "display": "Curd",
              "value": "Curd",
            },
            {
              "display": "Juice",
              "value": "Juice",
            },
            {
              "display": "Pickle",
              "value": "Pickle",
            },
            {
              "display": "Papad",
              "value": "Papad",
            },
          ],
          textField: 'display',
          valueField: 'value',
          okButtonLabel: 'OK',
          cancelButtonLabel: 'Cancel',
        ),
      ),
    );
  }

  Widget buildAddOnsRow(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 10,right: 10),
      child: Row(
        children: [
          Text('Ad On',style: GoogleFonts.nunitoSans(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),),
          SizedBox(width: MediaQuery.of(context).size.width/20,),

          GestureDetector(
            onTap: (){
              setState(() {
                manage.index[3] = 1;
              });
            },
            child: manage.index[3]==0 ? Container(
              width: MediaQuery.of(context).size.width/25,
              height: MediaQuery.of(context).size.height/45,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
            ) : GestureDetector(
              onTap: (){
                setState(() {
                  manage.index[3] = 0;
                });
              },
              child: Container(
                width: MediaQuery.of(context).size.width/25,
                height: MediaQuery.of(context).size.height/45,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  color: Colors.blue[700]
                ),
              ),
            )
          ),
          SizedBox(width: 5,),
          Text('Papad',style: GoogleFonts.nunitoSans(
              fontSize: 16,
              fontWeight: FontWeight.w600
          ),),
          SizedBox(width: MediaQuery.of(context).size.width/15,),
          GestureDetector(
            onTap: (){
              setState(() {
                manage.index[4]=1;
              });
            },
            child: manage.index[4] == 0 ? Container(
              width: MediaQuery.of(context).size.width/25,
              height: MediaQuery.of(context).size.height/45,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
            ) : GestureDetector(
              onTap: (){
                setState(() {
                  manage.index[4]=0;
                });
              },
              child: Container(
                width: MediaQuery.of(context).size.width/25,
                height: MediaQuery.of(context).size.height/45,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  color: Colors.blue[700]
                ),
              ),
            )
          ),
          SizedBox(width: 5,),
          Text('Ice Cream',style: GoogleFonts.nunitoSans(
              fontSize: 16,
              fontWeight: FontWeight.w600
          ),),
          SizedBox(width: MediaQuery.of(context).size.width/15,),
          GestureDetector(
            onTap: (){
              setState(() {
                manage.index[5] = 1;
              });
            },
            child: manage.index[5] == 0 ? Container(
              width: MediaQuery.of(context).size.width/25,
              height: MediaQuery.of(context).size.height/45,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
            ) : GestureDetector(
              onTap: (){
                setState(() {
                  manage.index[5]=0;
                });
              },
              child: Container(
                width: MediaQuery.of(context).size.width/25,
                height: MediaQuery.of(context).size.height/45,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  color: Colors.blue[700]
                ),
              ),
            )
          ),
          SizedBox(width:5,),
          Text('Rasgulla',style: GoogleFonts.nunitoSans(
              fontSize: 16,
              fontWeight: FontWeight.w600
          ),)

        ],
      ),
    );
  }

  Widget buildAdOnSecondRow(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 10,right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [

          GestureDetector(
            onTap: (){
              setState(() {
                manage.index[6] = 1;
              });
            },
            child: manage.index[6]==0 ? Container(
              width: MediaQuery.of(context).size.width/25,
              height: MediaQuery.of(context).size.height/45,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
            ) : GestureDetector(
              onTap: (){
                setState(() {
                  manage.index[6]=0;
                });
              },
              child: Container(
                width: MediaQuery.of(context).size.width/25,
                height: MediaQuery.of(context).size.height/45,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  color: Colors.blue
                ),
              ),
            )
          ),
          Text('Curd',style: GoogleFonts.nunitoSans(
              fontSize: 16,
              fontWeight: FontWeight.w600
          ),),
          GestureDetector(
            onTap: (){
              setState(() {
                manage.index[7]=1;
              });
            },
            child: manage.index[7] == 0 ? Container(
              width: MediaQuery.of(context).size.width/25,
              height: MediaQuery.of(context).size.height/45,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
            ) : GestureDetector(
              onTap: (){
                setState(() {
                  manage.index[7]=0;
                });
              },
              child: Container(
                width: MediaQuery.of(context).size.width/25,
                height: MediaQuery.of(context).size.height/45,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  color: Colors.blue[700]
                ),
              ),
            )
          ),
          Text('Gulab Jamun',style: GoogleFonts.nunitoSans(
              fontSize: 16,
              fontWeight: FontWeight.w600
          ),),
          GestureDetector(
            onTap: (){
              setState(() {
                manage.index[8]=1;
              });
            },
            child: manage.index[8]==0 ? Container(
              width: MediaQuery.of(context).size.width/25,
              height: MediaQuery.of(context).size.height/45,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
            ) :  GestureDetector(
              onTap: (){
                setState(() {
                  manage.index[8]=0;
                });
              },
              child: Container(
                width: MediaQuery.of(context).size.width/25,
                height: MediaQuery.of(context).size.height/45,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  color: Colors.blue[700]
                ),
              ),
            )
          ),
          Text('Pickle',style: GoogleFonts.nunitoSans(
              fontSize: 16,
              fontWeight: FontWeight.w600
          ),),
          GestureDetector(
            onTap: (){
              setState(() {
                manage.index[9]=1;
              });
            },
            child: manage.index[9]==0 ? Container(
              width: MediaQuery.of(context).size.width/25,
              height: MediaQuery.of(context).size.height/45,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
            ) : GestureDetector(
              onTap: (){
                setState(() {
                  manage.index[9]=0;
                });
              },
              child: Container(
                width: MediaQuery.of(context).size.width/25,
                height: MediaQuery.of(context).size.height/45,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  color: Colors.blue[700]
                ),
              ),
            )
          ),
          Text('Juice',style: GoogleFonts.nunitoSans(
              fontSize: 16,
              fontWeight: FontWeight.w600
          ),)
        ],
      ),
    );
  }

  Widget buildSaveAndCancelButton(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 10,right: 10),
      child: Column(
        children: [
          GestureDetector(
            onTap: (){
//              Navigator.push(
//                  context,
//                  PageRouteBuilder(
//                    pageBuilder: (c, a1, a2) =>ManageSubItems(),
//                    transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
//                    transitionDuration: Duration(milliseconds: 300),
//                  )
//              );
            },
            child: Container(
            width: MediaQuery.of(context).size.width/1.17,
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
              child: Text('Manage Sub Items',style: GoogleFonts.nunitoSans(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white
              ),),
            ),
        ),
          ),
          SizedBox(height: 20,),
          Container(
            width: MediaQuery.of(context).size.width/1.17,
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
              child: Text('Save',style: GoogleFonts.nunitoSans(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white
              ),),
            ),
          ),
          SizedBox(height: 20,),
          Container(
            width: MediaQuery.of(context).size.width/1.17,
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
              child: Text('Cancel',style: GoogleFonts.nunitoSans(
                  fontWeight: FontWeight.bold,
                  fontSize: 18
              ),),
            ),
          )
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

  Widget manage1(BuildContext context){
    return GestureDetector(
      onTap: (){
        print(widget.itemId);
        print(widget.name);
        print(widget.cuisine);
        print(widget.amount);
        print(widget.price);
        print(widget.description);
        print(widget.type);
        print(widget.category);
        print(widget.blsd);
        // addNewItemApiProvider.getCuisineId(context);
        Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (c, a1, a2) =>AddItemPageForManage(widget.itemId, widget.name, widget.cuisine, widget.amount, widget.price, widget.description, widget.type, widget.category, widget.blsd),
              transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
              transitionDuration: Duration(milliseconds: 300),
            )
        );
      },
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width/1.2,
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
            child: Text('Edit Item Details',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),),
          ),
        ),
      ),
    );
  }

  Widget manage2(BuildContext context){
    return GestureDetector(
      onTap: (){
        Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (c, a1, a2) =>AddAdonsPage(widget.itemId),
              transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
              transitionDuration: Duration(milliseconds: 300),
            )
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width/1.2,
        height: MediaQuery.of(context).size.height/15,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: Colors.blue[700],
            boxShadow: [BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 10,
            )]
        ),
        child: Center(
          child: Text('Manage/Add AdOns',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),),
        ),
      ),
    );
  }

  Widget manage3(BuildContext context){
    return GestureDetector(
      onTap: (){
        Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (c, a1, a2) =>EditItemAvailability(widget.itemId, widget.status),
              transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
              transitionDuration: Duration(milliseconds: 300),
            )
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width/1.2,
        height: MediaQuery.of(context).size.height/15,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: Colors.blue[700],
            boxShadow: [BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 10,
            )]
        ),
        child: Center(
          child: Text('Edit Item Availability',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),),
        ),
      ),
    );
  }

  Widget manage4(BuildContext context){
    return GestureDetector(
      onTap: (){
        Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (c, a1, a2) =>ManageSubItems(widget.itemId),
              transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
              transitionDuration: Duration(milliseconds: 300),
            )
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width/1.2,
        height: MediaQuery.of(context).size.height/15,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: Colors.blue[700],
            boxShadow: [BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 10,
            )]
        ),
        child: Center(
          child: Text('Manage Sub Items',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),),
        ),
      ),
    );
  }

  Widget manage5(BuildContext context){
    return GestureDetector(
      onTap: (){
        Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (c, a1, a2) =>ManageItemImages(widget.itemId.toString()),
              transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
              transitionDuration: Duration(milliseconds: 300),
            )
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width/1.2,
        height: MediaQuery.of(context).size.height/15,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: Colors.blue[700],
            boxShadow: [BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 10,
            )]
        ),
        child: Center(
          child: Text('Manage Item Images',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),),
        ),
      ),
    );
  }

}
