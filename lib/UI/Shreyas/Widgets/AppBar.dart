import 'package:flutter/material.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:vendor_dabbawala/UI/Shreyas/Utils/constants.dart';
import 'package:vendor_dabbawala/UI/data/login_data.dart' as login;

class BaseAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Text title;
  final AppBar appBar;
  final List<Widget> widgets;

  /// you can add more fields that meet your needs

  const BaseAppBar({Key key, this.title, this.appBar, this.widgets})
      : super(key: key);

  @override
  _BaseAppBarState createState() => _BaseAppBarState();

  @override
  Size get preferredSize => new Size.fromHeight(60);
}

class _BaseAppBarState extends State<BaseAppBar> {
  final Color backgroundColor = Colors.red;

  void _openEndDrawer() {
    login.scaffoldKeys.currentState.openEndDrawer();
  }

  Widget appBarTitle = new Text("AppBar Title",textScaleFactor: 1,);

  Icon actionIcon = new Icon(Icons.search,color: Colors.black,);

  @override
  Widget build(BuildContext context) {
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
}
