import 'package:datapack_flutter/Screens/ReceiveScreen.dart';
import 'package:datapack_flutter/Screens/UploadScreen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        height: height,
        width: width,
        child: Column(
          children: <Widget>[
            //the blue portion of the screen
            Container(
              height: height/1.38,
              width: width,
              color: Colors.deepPurpleAccent,
              //the below column will hold an image and a text or maybe more..
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Image.asset("assets/picture.png",width: width/1.15,),
                  ),
                  Container(
                    padding: EdgeInsets.only(top:height/10),
                    child: Text("Welcome to DataStore.",
                      style: TextStyle(color: Colors.white,fontSize: 22),),
                  ),
                ],
              ),
            ),
            //the white portion of the screen
            Container(
              height: height/4.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  //this row holds the buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: width/3,
                        height: height/23,
                        decoration: BoxDecoration(
                            color: Colors.deepPurpleAccent,
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child: FlatButton(
                            onPressed: (){
                              setState(() {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => UploadScreen()
                                ));
                              });
                            },
                            child: Text("Upload", style: TextStyle(color: Colors.white,fontSize: 18),)
                        ),
                      ),
                      SizedBox(width: width/8,),
                      Container(
                        width: width/3,
                        height: height/23,
                        decoration: BoxDecoration(
                            color: Colors.deepPurpleAccent,
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child: FlatButton(
                            onPressed: (){
                              setState(() {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => ReceiveScreen()
                                ));
                              });
                            },
                            child: Text("Posts", style: TextStyle(color: Colors.white,fontSize: 18),)
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: height/23,),
                  Container(
                    alignment: Alignment.center,
                    width: width,
                    child: Text("you can always change it later in app",
                      style: TextStyle(color: Colors.grey[500]),),
                  ),
                ],
              ),
            ),
            //the grey portion of the screen
            Expanded(
              child: Container(
                alignment: Alignment.center,
                color: Colors.grey[300],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Want to know more about us? ",style: TextStyle(color: Colors.grey[600]),),
                    Text(" Click here",style: TextStyle(color: Colors.deepPurpleAccent),),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
