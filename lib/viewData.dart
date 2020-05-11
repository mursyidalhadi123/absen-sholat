import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Create a Form widget.
class ViewData extends StatefulWidget {
  @override
  _ViewData createState() {
    return _ViewData();
  }
}

class _ViewData extends State<ViewData> {
  String id;
  final db = Firestore.instance;
  final _formKey = GlobalKey<FormState>();
  String name;
  String nim;

  Card buildItem(DocumentSnapshot doc) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'name: ${doc.data['nama']}',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              'nim: ${doc.documentID}',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Siswa'),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: <Widget>[
          StreamBuilder<QuerySnapshot>(
            stream: db.collection('ID').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(children: snapshot.data.documents.map((doc) => buildItem(doc)).toList());
              } else {
                return SizedBox();
              }
            },
          )
        ],
      ),
    );
  }

  void readData() async {
    DocumentSnapshot snapshot = await db.collection('ID').document(id).get();
    print(snapshot.data['nama']);
  }

  void deleteData(DocumentSnapshot doc) async {
    await db.collection('ID').document(doc.documentID).delete();
    setState(() => id = null);
  }
}