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
  final String url = 'http://asrama.systemof.fail/api/catatanSholat';
  List data; //DEFINE VARIABLE data DENGAN TYPE List AGAR DAPAT MENAMPUNG COLLECTION / ARRAY

  Future<String> getData() async {
    // MEMINTA DATA KE SERVER DENGAN KETENTUAN YANG DI ACCEPT ADALAH JSON
    var res = await http.get(Uri.encodeFull(url), headers: { 'accept':'application/json' });

    setState(() {
      //RESPONSE YANG DIDAPATKAN DARI API TERSEBUT DI DECODE
      var content = json.decode(res.body);
      //KEMUDIAN DATANYA DISIMPAN KE DALAM VARIABLE data,
      //DIMANA SECARA SPESIFIK YANG INGIN KITA AMBIL ADALAH ISI DARI KEY hasil
      data = content;
      print(data);
    });
    return 'success!';
  }

  Widget build(context) {
    return MaterialApp(
      title: 'A',
      home: Scaffold(
          appBar: AppBar(
              title: Text('BB')
          ),
          body: Container(
            margin: EdgeInsets.all(10.0),
            child: ListView.builder(
              itemCount: data == null ? 0 : data.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                    child: Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min, children: <Widget>[
                        ListTile(
                          leading: Text('${data[index]['NIS']}', style: TextStyle(
                              fontSize: 30.0),),
                          title: Text(data[index]['name'], style: TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.bold),),
                        ),
                      ],),
                    )
                );
              },
            ),
          )
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getData();
  }
}