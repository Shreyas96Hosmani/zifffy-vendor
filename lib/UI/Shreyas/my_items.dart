import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vendor_dabbawala/UI/Shreyas/Widgets/AppBar.dart';
import 'package:vendor_dabbawala/UI/Shreyas/Widgets/VendorItems.dart';
import 'package:vendor_dabbawala/UI/add_item_page.dart';

class MyItems extends StatefulWidget {
  String get routeName => '/myItems';

  @override
  _MyItemsState createState() => _MyItemsState();
}

class _MyItemsState extends State<MyItems> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BaseAppBar(),
      bottomNavigationBar: buildAddNewItemContainer(context),
      body: VendorItemsList(),
    );
  }

  Widget buildAddNewItemContainer(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 18,
      child: RaisedButton(

        onPressed: (){
          Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (c, a1, a2) => AddItemPage(),
                transitionsBuilder: (c, anim, a2, child) =>
                    FadeTransition(opacity: anim, child: child),
                transitionDuration: Duration(milliseconds: 300),
              ));
        },
        child: Center(
          child: Text(
            'Add New Item',
            textScaleFactor: 1,
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
}
