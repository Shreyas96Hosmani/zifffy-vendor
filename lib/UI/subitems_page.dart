import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'data/login_data.dart' as login;



class SubItemsPage extends StatefulWidget {
  @override
  _SubItemsPageState createState() => _SubItemsPageState();
}

class _SubItemsPageState extends State<SubItemsPage> {

  int _value = 1;

  void _openEndDrawer() {
    login.scaffoldKeyy.currentState.openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: buildAppDrawer(context),
      key: login.scaffoldKeyy,
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height/20,),
          buildNameField(context),
          SizedBox(height: MediaQuery.of(context).size.height/20,),
buildSubNameField(context),
          SizedBox(height: MediaQuery.of(context).size.height/20,),
          buildAmountField(context),
          SizedBox(height: MediaQuery.of(context).size.height/20,),
          buildSaveAndCancelButton(context)
        ],
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
        'Add New Sub Item',
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

  Widget buildNameField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            width: MediaQuery.of(context).size.width / 1.56,
            height: MediaQuery.of(context).size.height / 15,
            child: TextFormField(
              enabled: false,
              controller: login.emailController,
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

  Widget buildSubNameField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Sub Item ',
            style: GoogleFonts.nunitoSans(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            width: 23,
          ),
          Container(
            width: MediaQuery.of(context).size.width / 1.56,
            height: MediaQuery.of(context).size.height / 15,
            child: TextFormField(
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

  Widget buildAmountField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Amount ',
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

  Widget buildSaveAndCancelButton(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 10,right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: MediaQuery.of(context).size.width/2.3,
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
              child: Text('Add',style: GoogleFonts.nunitoSans(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white
              ),),
            ),
          ),
          SizedBox(height: 15,),
          Container(
            width: MediaQuery.of(context).size.width/2.3,
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





}
