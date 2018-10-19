import 'package:flutter/material.dart';

class ViewPage extends StatefulWidget {
  final int id;

  ViewPage({Key key, @required this.id}) : super(key: key);

  @override
  _ViewPageData createState() => new _ViewPageData();
}

class _ViewPageData extends State<ViewPage> {
  @override
  Widget build(BuildContext context) {
    var id = widget.id;
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('详情'),
        elevation: 0.0,
        backgroundColor: Colors.red[400].withOpacity(0.5),
      ),
      body: Center(
        child: RaisedButton(
          child: Text("id是"+ id.toString()),
        ),
      ),
    );
  }
}
