import 'package:flutter/material.dart';
import 'package:share/share.dart';

class GiffPage extends StatelessWidget {
  final Map _giffData;

  GiffPage(this._giffData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text(
          _giffData["title"],
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
        actions: [
          IconButton(icon: Icon(Icons.share), onPressed: (){
                  Share.share(_giffData["images"]["fixed_height"]["url"]);
          })
        ],
      ),
      body: Center(
        child: Image.network(_giffData["images"]["fixed_height"]["url"]),
      ),
    );
  }
}
