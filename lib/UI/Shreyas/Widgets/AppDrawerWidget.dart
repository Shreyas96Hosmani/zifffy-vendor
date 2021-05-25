import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppDrawerWidget extends StatefulWidget {
  @override
  _AppDrawerWidgetState createState() => _AppDrawerWidgetState();
}

class _AppDrawerWidgetState extends State<AppDrawerWidget> {
  @override
  Widget build(BuildContext context) {
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
}
