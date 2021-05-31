import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:giphy_app/UI/giff_page.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search="";
  int _offset = 0;

  Future<Map> _getGifs() async {
    http.Response response;

    if (_search == "") {
      response = await http.get(
        Uri.parse(
            "https://api.giphy.com/v1/gifs/trending?api_key=QDb7o4gQF9nZ5V6R1frJOEq88aSi4zBJ&limit=20&rating=g"),
      );
    } else {
      response = await http.get(
        Uri.parse(
            "https://api.giphy.com/v1/gifs/search?api_key=QDb7o4gQF9nZ5V6R1frJOEq88aSi4zBJ&q=$_search&limit=19&offset=$_offset&rating=g&lang=en"),
      );
    }

    return json.decode(response.body);
  }


  @override
  void initState() {
    super.initState();
    _getGifs().then((map){
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Image.network("https://developers.giphy.com/branch/master/static/header-logo-8974b8ae658f704a5b48a2d039b8ad93.gif", width: 200,),
      ),
      body: Column(
        children: [
          barraPesquisar(),
          Expanded(
            child: FutureBuilder(
              future: _getGifs(),
              builder: (context, snapshot ){
                switch (snapshot.connectionState){
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5,
                      ),
                    );
                  default:
                    if (snapshot.hasError) return Container();
                    else return _createGiffTable(context, snapshot);
                }
              },

            ),
          ),


        ],
      ),
    );
  }

  int _getCount(List data){ //contador function
    if(_search == ""){
      return data.length; //caso a pesquisa seja vazia
    } else {
      return data.length +1; //caso a pesquisa não seja vazia
    }
  }

  Widget _createGiffTable (BuildContext context, AsyncSnapshot snapshot){ //function grade de imagens
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount( //regras do gridview
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _getCount(snapshot.data["data"]), //chamada do contador
      itemBuilder: (context, index){
        if(_search == "" || index < snapshot.data["data"].length){ //exibir trending ou pesqisa menos um item

          return GestureDetector(
            child: FadeInImage.memoryNetwork(
              image: snapshot.data["data"][index]["images"]["fixed_height"]["url"],
              height: 300.0,
              fit: BoxFit.cover,
              placeholder: kTransparentImage,
            ),
            onTap: (){
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => GiffPage(snapshot.data["data"][index]))
              );
            },
            onLongPress: (){
              Share.share(snapshot.data["data"][index]["images"]["fixed_height"]["url"]);
            },
          );
        } else {
          return Container(
            child: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: Colors.white, size: 50.0,),
                  Text("Carregar mais...", style: TextStyle(color: Colors.white, fontSize: 16),)
                ],
              ),
              onTap: (){
                setState(() {
                  _offset += 19; //mostrar mais giffs
                });
              },
            ),
          );
        }

      },
    );
  }

  Widget barraPesquisar() { //function
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(

        onSubmitted: (text){ //buscar texto ao submeter
          setState(() {
            _search = text; //altero o search e ele ja muda no getGiff
            _offset =0; //reseto o offset pra que ao buscar um novo texto não haja offset pre-setado
          });
        },
        style: TextStyle(color: Colors.white, fontSize: 18),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          labelText: "Pesquisar",
          labelStyle: TextStyle(color: Colors.white),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                  color: Colors.white
              )
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                  color: Colors.white
              )
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                  color: Colors.white
              )
          ),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                  color: Colors.white
              )
          ),
        ),
      ),
    );
  }

}

