import 'package:datapack_flutter/Model/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReceiveScreen extends StatefulWidget {
  @override
  _ReceiveScreenState createState() => _ReceiveScreenState();
}

class _ReceiveScreenState extends State<ReceiveScreen> {

  Widget _cardUI(Post post){
    return Card(
      margin: EdgeInsets.all(16.0),
      elevation: 6.0,
      child: Container(
        padding: EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(post.date, textAlign: TextAlign.center,style: TextStyle(fontSize: 16.0, color: Colors.grey),),
                Text(post.time, textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, color: Colors.grey),),
              ],
            ),
            SizedBox(height: 10.0,),
            Image.network(post.imageUrl,width: double.infinity,height: 300.0,fit: BoxFit.cover,),
            SizedBox(height: 10.0,),
            Text(post.description, style: TextStyle(fontSize: 20.0, color: Colors.grey[800]),)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    Firestore firestore = Firestore.instance;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Text("Receive", style: TextStyle(fontSize: 22),),
      ),
      body: Container(
        child: new StreamBuilder<QuerySnapshot>(
          stream: firestore.collection('posts').snapshots(),
          builder: (context, snapshot){
            if(!snapshot.hasData){
              return Center(
                child: CircularProgressIndicator(),
              );
            }else{
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index){
                  Map<String, dynamic> postMap =
                      snapshot.data.documents[index].data;
                  Post post = Post(
                    description: postMap['description'],
                    imageUrl: postMap['imageUrl'],
                    date:  postMap['date'],
                    time:  postMap['time']
                  );
                  return _cardUI(post);
                },
              );
            }
          },
        ),
      ),
    );
  }
}
