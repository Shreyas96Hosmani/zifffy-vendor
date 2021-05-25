import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'data/login_data.dart' as login;
import 'package:http/http.dart' as http;
import 'package:vendor_dabbawala/UI/data/globals_data.dart' as globals;
import 'dart:convert';

ProgressDialog prImage;

var images;
var imageIds;

var imageOne;
var imageTwo;
var imageThree;
File imageOneUpload;
File imageTwoUpload;
File imageThreeUpload;

var baseImageUniversal1;
var fileNameUniversal1;
var baseImageUniversal2;
var fileNameUniversal2;
var baseImageUniversal3;
var fileNameUniversal3;

class ManageItemImages extends StatefulWidget {
  final id;
  ManageItemImages(this.id) : super();
  @override
  _ManageItemImagesState createState() => _ManageItemImagesState();
}

class _ManageItemImagesState extends State<ManageItemImages> {

  Future getImageOneCamera() async{
    // ignore: deprecated_member_use
    final image = await ImagePicker.pickImage(source: ImageSource.camera, imageQuality: 25);

    setState(() {
      imageOne = image;
      imageOneUpload = File(image.path);
      Navigator.of(context).pop();
    });
    addItemImage1(context);
  }
  Future getImageOneGallery() async{
    // ignore: deprecated_member_use
    final img = await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 25);

    setState(() {
      imageOne = img;
      imageOneUpload = File(img.path);
      Navigator.of(context).pop();
    });
    addItemImage1(context);
  }

  Future getImageTwoCamera() async{
    // ignore: deprecated_member_use
    final image = await ImagePicker.pickImage(source: ImageSource.camera, imageQuality: 25);

    setState(() {
      imageTwo = image;
      imageTwoUpload = File(image.path);
      Navigator.of(context).pop();
    });
    addItemImage2(context);
  }
  Future getImageTwoGallery() async{
    // ignore: deprecated_member_use
    final img = await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 25);

    setState(() {
      imageTwo = img;
      imageTwoUpload = File(img.path);
      Navigator.of(context).pop();
    });
    addItemImage2(context);
  }

  Future getImageThreeCamera() async{
    // ignore: deprecated_member_use
    final image = await ImagePicker.pickImage(source: ImageSource.camera, imageQuality: 25);

    setState(() {
      imageThree = image;
      imageThreeUpload = File(image.path);
      Navigator.of(context).pop();
    });
    addItemImage3(context);
  }
  Future getImageThreeGallery() async{
    // ignore: deprecated_member_use
    final img = await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 25);

    setState(() {
      imageThree = img;
      imageThreeUpload = File(img.path);
      Navigator.of(context).pop();
    });
    addItemImage3(context);
  }

  Future<String> getItemImages(context) async {

    String url = globals.apiUrl + "getimagebyitemid.php";

    http.post(url, body: {

      "itemID" : widget.id.toString(),

    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");

      }
      var responseArrayGetImages = jsonDecode(response.body);
      print(responseArrayGetImages);

      var responseArrayGetImagesMsg = responseArrayGetImages['message'].toString();
      print(responseArrayGetImagesMsg);

      if(statusCode == 200){
        if(responseArrayGetImagesMsg == "Successfully"){
          //prGetItems.hide();
          setState(() {
            imageIds = List.generate(responseArrayGetImages['data'].length, (index) => responseArrayGetImages['data'][index]['iimID'].toString());
            images = List.generate(responseArrayGetImages['data'].length, (index) => "https://admin.dabbawala.ml/"+responseArrayGetImages['data'][index]['imageName'].toString());
            if(images.length == 0){

            }else if(images.length == 1){
              imageOne = images[0];
            }else if(images.length == 2){
              imageOne = images[0];
              imageTwo = images[1];
            }else if(images.length == 3){
              imageOne = images[0];
              imageTwo = images[1];
              imageThree = images[2];
            }
          });
          print(imageIds);
          print(images);

        }else{
          //prGetItems.hide();
          setState(() {
            images = [];
          });

        }
      }
    });

  }

  Future<String> addItemImage1(context) async {

    prImage.show();

    String url = globals.apiUrl + "additemimages.php";

    baseImageUniversal1 = base64Encode(imageOne.readAsBytesSync());
    fileNameUniversal1 = imageOne.path.split("/").last;

    http.post(url, body: {

      "itemID" : widget.id.toString(),
      "image" : baseImageUniversal1,
      "name" : fileNameUniversal1,

    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");

      }
      var responseArrayAddImage1 = jsonDecode(response.body);
      print(responseArrayAddImage1);

      var responseArrayAddImage1Msg = responseArrayAddImage1['message'].toString();
      print(responseArrayAddImage1Msg);

      if(statusCode == 200){
        if(responseArrayAddImage1Msg == "Successfully"){

          prImage.hide();
          //prGetItems.hide();
          Fluttertoast.showToast(msg: "Saved", backgroundColor: Colors.black, textColor: Colors.white);
          getItemImages(context);

        }else{
          //prGetItems.hide();
          prImage.hide();
          Fluttertoast.showToast(msg: "Some error occured", backgroundColor: Colors.black, textColor: Colors.white);

        }
      }
    });

  }
  Future<String> addItemImage2(context) async {

    prImage.show();

    String url = globals.apiUrl + "additemimages.php";

    baseImageUniversal2 = base64Encode(imageTwo.readAsBytesSync());
    fileNameUniversal2 = imageTwo.path.split("/").last;

    http.post(url, body: {

      "itemID" : widget.id.toString(),
      "image" : baseImageUniversal2,
      "name" : fileNameUniversal2,

    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");

      }
      var responseArrayAddImage2 = jsonDecode(response.body);
      print(responseArrayAddImage2);

      var responseArrayAddImage2Msg = responseArrayAddImage2['message'].toString();
      print(responseArrayAddImage2Msg);

      if(statusCode == 200){
        if(responseArrayAddImage2Msg == "Successfully"){
          prImage.hide();
          Fluttertoast.showToast(msg: "Saved", backgroundColor: Colors.black, textColor: Colors.white);
          getItemImages(context);

        }else{
          prImage.hide();
          Fluttertoast.showToast(msg: "Some error occured", backgroundColor: Colors.black, textColor: Colors.white);

        }
      }
    });

  }
  Future<String> addItemImage3(context) async {

    String url = globals.apiUrl + "additemimages.php";

    baseImageUniversal3 = base64Encode(imageThree.readAsBytesSync());
    fileNameUniversal3 = imageThree.path.split("/").last;

    http.post(url, body: {

      "itemID" : widget.id.toString(),
      "image" : baseImageUniversal3,
      "name" : fileNameUniversal3,

    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");

      }
      var responseArrayAddImage3 = jsonDecode(response.body);
      print(responseArrayAddImage3);

      var responseArrayAddImage3Msg = responseArrayAddImage3['message'].toString();
      print(responseArrayAddImage3Msg);

      if(statusCode == 200){
        if(responseArrayAddImage3Msg == "Successfully"){
          prImage.hide();
          Fluttertoast.showToast(msg: "Saved", backgroundColor: Colors.black, textColor: Colors.white);
          getItemImages(context);

        }else{
          prImage.hide();
          Fluttertoast.showToast(msg: "Some error occured", backgroundColor: Colors.black, textColor: Colors.white);

        }
      }
    });

  }

  Future<String> removeItemImage1(context) async {

    String url = globals.apiUrl + "removeimagebyimageid.php";

    http.post(url, body: {

      "imageiD" : imageIds[0].toString(),

    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");

      }
      var responseRemove1 = jsonDecode(response.body);
      print(responseRemove1);

      var responseRemove1Msg = responseRemove1['message'].toString();
      print(responseRemove1Msg);

      if(statusCode == 200){
        if(responseRemove1Msg == "Successfully"){
          //prGetItems.hide();
          Fluttertoast.showToast(msg: "Removed", backgroundColor: Colors.black, textColor: Colors.white).whenComplete((){
            setState(() {
              imageOne = null;
            });
            getItemImages(context);
          });

        }else{
          //prGetItems.hide();
          Fluttertoast.showToast(msg: "Some error occured", backgroundColor: Colors.black, textColor: Colors.white);

        }
      }
    });

  }
  Future<String> removeItemImage2(context) async {

    String url = globals.apiUrl + "removeimagebyimageid.php";

    http.post(url, body: {

      "imageiD" : imageIds[1].toString(),

    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");

      }
      var responseRemove2 = jsonDecode(response.body);
      print(responseRemove2);

      var responseRemove2Msg = responseRemove2['message'].toString();
      print(responseRemove2Msg);

      if(statusCode == 200){
        if(responseRemove2Msg == "Successfully"){
          //prGetItems.hide();
          Fluttertoast.showToast(msg: "Removed", backgroundColor: Colors.black, textColor: Colors.white).whenComplete((){
            setState(() {
              imageTwo = null;
            });
            getItemImages(context);
          });

        }else{
          //prGetItems.hide();
          Fluttertoast.showToast(msg: "Some error occured", backgroundColor: Colors.black, textColor: Colors.white);

        }
      }
    });

  }
  Future<String> removeItemImage3(context) async {

    String url = globals.apiUrl + "removeimagebyimageid.php";

    http.post(url, body: {

      "imageiD" : imageIds[2].toString(),

    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");

      }
      var responseRemove3 = jsonDecode(response.body);
      print(responseRemove3);

      var responseRemove3Msg = responseRemove3['message'].toString();
      print(responseRemove3Msg);

      if(statusCode == 200){
        if(responseRemove3Msg == "Successfully"){
          //prGetItems.hide();
          Fluttertoast.showToast(msg: "Removed", backgroundColor: Colors.black, textColor: Colors.white).whenComplete((){
            setState(() {
              imageThree = null;
            });
            getItemImages(context);
          });

        }else{
          //prGetItems.hide();
          Fluttertoast.showToast(msg: "Some error occured", backgroundColor: Colors.black, textColor: Colors.white);

        }
      }
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    images = null;
    imageOne = null;
    imageTwo = null;
    imageThree = null;
    getItemImages(context);
  }

  @override
  Widget build(BuildContext context) {
    prImage = ProgressDialog(context);
    prImage.style(message: "Please wait while the image is being uploaded!", backgroundColor: Colors.black, messageTextStyle: TextStyle(
        color: Colors.white)
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: buildSaveCancelButton(context),
      ),
      body: images == null ? Center(child: CircularProgressIndicator(),) : buildPictureArea(context),
    );
  }

  Widget buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: Text(
        'Manage Images',
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

  Widget buildPictureArea(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10,right: 10,top: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          imageOne == null ? GestureDetector(
            onTap: slideSheet1,
            child: Container(
                width: 250,
                height: 125,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: Colors.black)
                ),
                child:  Icon(Icons.add,size: 40,color: Colors.grey[400],)
            ),
          ) : Stack(
            children: [
              Container(
                width: 250,
                height: 125,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: Colors.black)
                ),
                child : imageOne.toString().contains("https") ? Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.network(images[0].toString(),fit: BoxFit.fill,),
                ) : Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.file(imageOne,fit: BoxFit.fill,),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 225),
                child: GestureDetector(
                  onTap: (){
                    removeItemImage1(context);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width/20,
                    height: MediaQuery.of(context).size.height/40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: Colors.red[600]
                    ),
                    child: Center(
                      child: Text('-',style: GoogleFonts.nunitoSans(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10
                      ),),
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 20,),
          imageTwo == null ? GestureDetector(
            onTap: slideSheet2,
            child: Container(
                width: 250,
                height: 125,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: Colors.black)
                ),
                child:  Icon(Icons.add,size: 40,color: Colors.grey[400],)
            ),
          ) : Stack(
            children: [
              Container(
                width: 250,
                height: 125,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: Colors.black)
                ),
                child : imageTwo.toString().contains("https") ? Image.network(images[1].toString()) : Image.file(imageTwo),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 225),
                child: GestureDetector(
                  onTap: (){
                    removeItemImage2(context);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width/20,
                    height: MediaQuery.of(context).size.height/40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: Colors.red[600]
                    ),
                    child: Center(
                      child: Text('-',style: GoogleFonts.nunitoSans(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10
                      ),),
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 20,),
          imageThree == null ? GestureDetector(
            onTap: slideSheet3,
            child: Container(
                width: 250,
                height: 125,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: Colors.black)
                ),
                child:  Icon(Icons.add,size: 40,color: Colors.grey[400],)
            ),
          ) : Stack(
            children: [
              Container(
                width: 250,
                height: 125,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: Colors.black)
                ),
                child : imageThree.toString().contains("https") ? Image.network(images[2].toString()) : Image.file(imageThree),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 225),
                child: GestureDetector(
                  onTap: (){
                    removeItemImage3(context);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width/20,
                    height: MediaQuery.of(context).size.height/40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: Colors.red[600]
                    ),
                    child: Center(
                      child: Text('-',style: GoogleFonts.nunitoSans(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10
                      ),),
                    ),
                  ),
                ),
              )
            ],
          ),
          Spacer(),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Center(
              child: Text("Note : If you do not upload any image, this item wont be visible in the app to your customers!",
                textAlign: TextAlign.center,
                style: GoogleFonts.nunitoSans(
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void slideSheet1() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              color: Color(0xFF737373),
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    SizedBox(height:MediaQuery.of(context).size.height/35),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: getImageOneCamera,
                          child: Column(
                            children: [
                              Icon(Icons.camera,color: Colors.deepPurple[700],size: 40,),
                              Text('Camera',style: GoogleFonts.nunitoSans(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600
                              ),),

                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: getImageOneGallery,
                          child: Column(
                            children: [
                              Icon(Icons.photo,color: Colors.deepPurple[700],size: 40,),
                              Text('Gallery',style: GoogleFonts.nunitoSans(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600
                              ),)


                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 20,)
                  ],
                ),
              ),
            ),
          );
        });
  }

  void slideSheet2() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              color: Color(0xFF737373),
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    SizedBox(height:MediaQuery.of(context).size.height/35),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: getImageTwoCamera,
                          child: Column(
                            children: [
                              Icon(Icons.camera,color: Colors.deepPurple[700],size: 40,),
                              Text('Camera',style: GoogleFonts.nunitoSans(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600
                              ),),

                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: getImageTwoGallery,
                          child: Column(
                            children: [
                              Icon(Icons.photo,color: Colors.deepPurple[700],size: 40,),
                              Text('Gallery',style: GoogleFonts.nunitoSans(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600
                              ),)
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20,)
                  ],
                ),
              ),
            ),
          );
        });
  }

  void slideSheet3() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              color: Color(0xFF737373),
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    SizedBox(height:MediaQuery.of(context).size.height/35),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: getImageThreeCamera,
                          child: Column(
                            children: [
                              Icon(Icons.camera,color: Colors.deepPurple[700],size: 40,),
                              Text('Camera',style: GoogleFonts.nunitoSans(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600
                              ),),

                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: getImageThreeGallery,
                          child: Column(
                            children: [
                              Icon(Icons.photo,color: Colors.deepPurple[700],size: 40,),
                              Text('Gallery',style: GoogleFonts.nunitoSans(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600
                              ),)


                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 20,)
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget buildSaveCancelButton(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 0,right: 0),
      child: GestureDetector(
        onTap: (){
          if(imageOne == null && imageTwo == null && imageThree == null){
            Fluttertoast.showToast(msg: 'Please upload atleast one image!', backgroundColor: Colors.black, textColor: Colors.white);
          }else{
            Navigator.of(context).popUntil((route) => route.isFirst);
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width/2.2,
          height: MediaQuery.of(context).size.height/15,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.blue[700],

          ),
          child: Center(
            child: Text('Done',style: GoogleFonts.nunitoSans(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white
            ),),
          ),
        ),
      ),
    );
  }

}
