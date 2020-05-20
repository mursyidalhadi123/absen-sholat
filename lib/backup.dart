import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(ViewData());
class ViewData extends StatefulWidget {
  @override
  _ViewData createState() {
    return _ViewData();
  }
}

class _ViewData extends State<ViewData> {
  DateTime selectedDate = DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 5,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.brightness_1),text: "Shubuh"),
                Tab(icon: Icon(Icons.wb_sunny),text: "Dzuhur"),
                Tab(icon: Icon(Icons.cloud),text: "Ashar"),
                Tab(icon: Icon(Icons.brightness_3),text: "Maghrib"),
                Tab(icon: Icon(Icons.star),text: "Isya"),
              ],
            ),
            actions: <Widget>[
              Text("${selectedDate.toLocal()}".split(' ')[0]),
              SizedBox(height: 10.0,),
              RaisedButton(
                onPressed: () => _selectDate(context),
                child: Text('Select date'),
              ),
            ],
          ),
          body: TabBarView(
            children: [
              Icon(Icons.directions_car),
              Icon(Icons.directions_transit),
              Icon(Icons.directions_bike),
              Icon(Icons.directions_transit),
              Icon(Icons.directions_bike),
            ],
          ),
        ),
      ),
    );
  }
}