import 'package:flutter/material.dart';
import 'package:web_socket/MyWebsocket.dart';
import 'package:web_socket/WebsocketCookbook.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'Pilih Websocket';
    return MaterialApp(
      title: title,
      home: MyHomePage(
        title: title,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({Key key, @required this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(this.widget.title),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            RaisedButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => WebsocketCookbook(),
                ));
              },
              child: Text("Websocket by Cookbook"),
            ),
            RaisedButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => MyWebsocket(),
                ));
              },
              child: Text("My Websocket"),
            )
          ],
        ),
      ),
    );
  }
}