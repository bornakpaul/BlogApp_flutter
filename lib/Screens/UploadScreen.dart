import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datapack_flutter/Screens/HomeScreen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {

  final TextEditingController _descriptionEditingController = TextEditingController();

  File _imageFile;
  bool _loading = false;

  // ImagePicker imagePicker = ImagePicker();

  Future _chooseImage() async {
    var imagePicker = await ImagePicker.pickImage(
        source: ImageSource.gallery
    );

    setState(() {
      _imageFile = File(imagePicker.path);
    });
  }

  void _validate(){
    if(_imageFile == null && _descriptionEditingController.text.isEmpty){
      Fluttertoast.showToast(
          msg: 'Fields cannot be empty'
      );
    }
    else if(_imageFile == null){
      Fluttertoast.showToast(
          msg: 'Select an image'
      );
    }
    else if(_descriptionEditingController.text.isEmpty){
      Fluttertoast.showToast(
        msg: 'Enter a short description'
      );
    }
    else{
      setState(() {
        _loading = true;
      });
      _uploadImage();
    }
  }

  void _uploadImage(){
    String imageFileName = DateTime.now().millisecondsSinceEpoch.toString();
    final  storageReference = FirebaseStorage.instance.ref()
                   .child('Images').child(imageFileName);
    final uploadTask = storageReference.putFile(_imageFile);

    uploadTask.onComplete.then((taskSnapshot){
      taskSnapshot.ref.getDownloadURL().then((imageUrl){
        //save info to firestore
        _saveData(imageUrl);
      });
    }).catchError((error){
      setState(() {
        _loading = false;
      });
      Fluttertoast.showToast(
          msg: error.toString(),
      );
    });
  }

  void _saveData(String imageUrl){

    var dateFormat = DateFormat('MMM d, yyyy');
    var timeFormat = DateFormat('EEEE, hh:mm a');

    String date = dateFormat.format(DateTime.now()).toString();
    String time = timeFormat.format(DateTime.now()).toString();

    Firestore firestore = Firestore.instance;
    firestore.collection('posts').add({
      'imageUrl' : imageUrl,
      'description' : _descriptionEditingController.text,
      'date' : date,
      'time' : time,
    }).whenComplete((){
      setState(() {
        _loading = false;
      });
      Fluttertoast.showToast(
        msg: 'Post added successfully',
      );
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
        return UploadScreen();
      })
      );
    }).catchError((error){
      setState(() {
        _loading = false;
      });
      Fluttertoast.showToast(
        msg: error.toString(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery
        .of(context)
        .size
        .height;
    double width = MediaQuery
        .of(context)
        .size
        .width;

    return Scaffold(
      //resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Text("Upload", style: TextStyle(fontSize: 22),),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          padding: EdgeInsets.all(15.0),
          width: width,
          child: Column(
            children: <Widget>[
              _imageFile == null ? Container(
                width: width,
                height: height/2.5,
                color: Colors.grey[300],
                child: Center(
                  child: FlatButton(
                    onPressed: () {
                      _chooseImage();
                    },
                    child: Text(
                      "Select Image", style: TextStyle(fontSize:18 ,color: Colors.white),),
                    color: Colors.deepPurpleAccent,
                  ),
                ),
              )
              : GestureDetector(
                onTap: (){
                  _chooseImage();
                },
                child: Container(
                  width: width,
                  height: height/2.5,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(_imageFile),
                      fit: BoxFit.cover
                    )
                  ),
                ),
              ),
              SizedBox(height: 30.0,),
              Container(
                child: TextFormField(
                  style: TextStyle(fontSize: 18.0,color: Colors.grey[700]),
                  controller: _descriptionEditingController,

                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.description,color: Colors.grey[700]),
                    hintText: "Caption",
                    hintStyle: TextStyle(fontSize: 18.0,color: Colors.grey[500]),
                    hintMaxLines: 2,
                    filled: true,
                    fillColor: Colors.grey[300],
                    enabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide.none
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide.none
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30.0,),
              _loading ? CircularProgressIndicator() : Container(
                height: height/20,
                width: width,
                child: RaisedButton(
                  onPressed: () {
                    _validate();
                  },
                  child: Text(
                    "New Post", style: TextStyle(fontSize:18 ,color: Colors.white),),
                  color: Colors.deepPurpleAccent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
