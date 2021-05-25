import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

var responseArrayGetCuisineId;
var getUserIdResponse;
var getUserIdMessage;

final formKey = GlobalKey<FormState>();
TextEditingController addNewItemNameController = new TextEditingController();
TextEditingController addNewItemDescriptionController = new TextEditingController();
TextEditingController addNewItemPriceController = new TextEditingController();
TextEditingController addNewItemAmountNumController = new TextEditingController();


var itemQuantity;
var itemType;
var itemCategory;
File image;

var responseArrayAddNewItem;
var addNewItemResponse;
var addNewItemMessage;

var getCuisineIdResponse;
var getCuisineIdMessage;
var cuisineID;
List<String> cuisineName;
var cuisineId;





