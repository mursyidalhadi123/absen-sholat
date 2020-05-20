import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Create a Form widget.
class ViewData extends StatefulWidget {
  @override
  _ViewData createState() {
    return _ViewData();
  }
}

class _ViewData extends State<ViewData> {

  Future<List> getData() async{
    final response = await http.get("http://127.0.0.1:8000/api/catatanSholat");
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Data absensi"),
      ),
      body: new FutureBuilder<List>(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? new ItemList(
            list: snapshot.data,
          )
              : new Center(
            child: new CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class ItemList extends StatelessWidget {
  final List list;
  ItemList({this.list});

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (context, i) {
        return new Container(
          padding: const EdgeInsets.all(10.0),
          child: new GestureDetector(
            child: new Card(

              child: new ListTile(
                title: new Text(list[i]['siswa_id']),
                leading: new Icon(Icons.person),
                subtitle: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(list[i]['jenis_sholat']),
                    Text(list[i]['waktu_absen']),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}