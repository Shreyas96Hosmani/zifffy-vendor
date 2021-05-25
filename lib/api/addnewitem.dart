import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendor_dabbawala/UI/add_item_page.dart';
import 'package:vendor_dabbawala/UI/data/globals_data.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:vendor_dabbawala/UI/data/login_data.dart' as login;
import 'package:vendor_dabbawala/UI/data/add_new_item_data.dart' as add;
import 'package:flutter/material.dart';

class AddNewItemApiProvider {


  Future<String> addNewItem(context) async {

    print(login.userIDResponse.toString());
    print(add.addNewItemNameController.text.toString());
    print(selectedCuisineId);
    print(selectedItemType);
    print(add.itemCategory.toString());
    print(add.addNewItemAmountNumController.text + add.itemQuantity.toString());
    print(add.addNewItemPriceController.text,);
    print(add.addNewItemDescriptionController.text.toString());

    prAddItem.hide();

    String url = globals.apiUrl + "addnewitem.php";

    http.post(url, body: {

      "vendorID": login.userIDResponse.toString(),
      "itemname" : add.addNewItemNameController.text.toString(),
      "cuisineID": selectedCuisineId.toString(),
      "itemtype": selectedItemType.toString(),
      "itemcategory":add.itemCategory.toString(),
      "itemamount": add.addNewItemAmountNumController.text.toString() + add.itemQuantity.toString(),
      "itemprice": add.addNewItemPriceController.text.toString(),
      "itemdescription": add.addNewItemDescriptionController.text.toString(),
      "productimages[0]" : "",
      "productimages[1]" : "",


    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");

      }
      add.responseArrayAddNewItem = jsonDecode(response.body);
      print(add.responseArrayAddNewItem);
      add.addNewItemResponse = add.responseArrayAddNewItem['status'].toString();
      add.addNewItemMessage = add.responseArrayAddNewItem['message'].toString();
      if(statusCode == 200){
        if(add.addNewItemMessage == "Successfully"){

          login.prlogin.hide().whenComplete((){

            Fluttertoast.showToast(msg: login.loginSuccess, backgroundColor: Colors.black, textColor: Colors.white);
            print(add.addNewItemMessage);

          });
        }else{

          Fluttertoast.showToast(msg: "Some error occured!", backgroundColor: Colors.black, textColor: Colors.white);

        }
      }

    });

  }

  Future<String> getCuisineId(context) async {

    String url = globals.apiUrl + "getallcuisine.php";

    http.post(url, body: {

    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");

      }
      add.responseArrayGetCuisineId = jsonDecode(response.body);
      print(add.responseArrayGetCuisineId);
      add.getCuisineIdResponse = add.responseArrayGetCuisineId['status'].toString();
      add.getCuisineIdMessage = add.responseArrayGetCuisineId['message'].toString();
      if(statusCode == 200){
        if(add.getCuisineIdMessage == "Cuisine Found"){
          add.cuisineID = List.generate(add.responseArrayGetCuisineId['data'].length, (index) => add.responseArrayGetCuisineId['data'][index]['cuisineID'].toString());
          print(add.cuisineID.toList());
          add.cuisineName = List.generate(add.responseArrayGetCuisineId['data'].length, (index) => add.responseArrayGetCuisineId['data'][index]['cuisineName'].toString());
          print(add.cuisineName.toList());

        }
        else{
          if(add.getCuisineIdMessage == "Error fetching data"){

          }
          else if(login.forgotPasswordMessage == 'Unable to add reset data'){
            login.prlogin.hide().whenComplete((){
              print('Hello');
              Fluttertoast.showToast(msg: login.invalidPassword,);
            });
          }
        }
      }

    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('cuisineId',add.cuisineID);

  }

}