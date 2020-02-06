import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket/HistoryModel.dart';
import 'package:web_socket/MessageModel.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MyWebsocket extends StatefulWidget {
  @override
  _MyWebsocketState createState() => _MyWebsocketState();
}

class _MyWebsocketState extends State<MyWebsocket> {

  final WebSocketChannel channel = IOWebSocketChannel.connect('ws://10.167.0.157:3000/websocket?room=S3-T4');

  TextEditingController _controller = TextEditingController();
  TextEditingController controllerRoom = TextEditingController();
  TextEditingController controllerMessage = TextEditingController();
  String msg = "";

  bool showHistory = false;
  HistoryModel historyModel = HistoryModel();

  List<_Messages> messages = [];
  List<_Messages> reversedMessages = [];

  @override
  void initState() {
    _setGroup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

    void openSnackbar(String text, Duration duration) {
      _scaffoldKey.currentState.hideCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text(text),
            duration: duration,
            action: SnackBarAction(
              label: 'Hide',
              onPressed: () {
                _scaffoldKey.currentState.hideCurrentSnackBar();
              },
            ),
          )
      );
    }

    Widget viewHolderChat(String message, String time, bool delivered, bool isMe) {
      final bg = isMe ? Colors.orangeAccent.shade100 : Colors.white;
      final align = isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
      final icon = delivered ? Icons.done : Icons.done_all;
      final radius = isMe ? BorderRadius.only(
        topLeft: Radius.circular(5.0),
        bottomLeft: Radius.circular(5.0),
        bottomRight: Radius.circular(10.0),
      ) : BorderRadius.only(
        topRight: Radius.circular(5.0),
        bottomLeft: Radius.circular(10.0),
        bottomRight: Radius.circular(5.0),
      );
      final horMargin = isMe ? EdgeInsets.fromLTRB(48.0, 4.0, 4.0, 4.0) : EdgeInsets.fromLTRB(4.0, 4.0, 48.0, 4.0);
      final avatar = isMe ? Container() : Container(
        margin: EdgeInsets.only(right: 8.0),
        child: Container(
          width: 30.0,
          height: 30.0,
          color: Colors.grey,
        ),
      );

      return Column(
        crossAxisAlignment: align,
        children: <Widget>[
          Container(
            margin: horMargin,
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    blurRadius: .5,
                    spreadRadius: 1.0,
                    color: Colors.black.withOpacity(.12))
              ],
              color: bg,
              borderRadius: radius,
            ),
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 48.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      avatar,
                      Expanded(
                        child: Text(
                          message,
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0.0,
                  right: 0.0,
                  child: Row(
                    children: <Widget>[
                      Text(time,
                          style: TextStyle(
                            color: Colors.black38,
                            fontSize: 10.0,
                          )),
                      SizedBox(width: 3.0),
                      Icon(
                        icon,
                        size: 12.0,
                        color: Colors.black38,
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("My Websocket"),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: StreamBuilder(
          stream: channel.stream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              WidgetsBinding.instance.addPostFrameCallback((_) => openSnackbar("Error Connection", Duration(days: 1)));
            }

            if (snapshot.connectionState == ConnectionState.none) {
              print("ConnectionState None");
              WidgetsBinding.instance.addPostFrameCallback((_) => openSnackbar("No Connection", Duration(days: 1)));
            }
            else if (snapshot.connectionState == ConnectionState.waiting) {
              //saat pertama kali
              print("ConnectionState Waitting");
              WidgetsBinding.instance.addPostFrameCallback((_) => openSnackbar("Connected", Duration(seconds: 3,)));
            }
            else if (snapshot.connectionState == ConnectionState.done) {
              //saat disconnect server
              print("ConnectionState Done");
              WidgetsBinding.instance.addPostFrameCallback((_) => openSnackbar("Disconnected", Duration(days: 1,)));
            }
            else if (snapshot.connectionState == ConnectionState.active) {
              //saat ada chat terkirim
              print("ConnectionState Active");
              WidgetsBinding.instance.addPostFrameCallback((_) => _scaffoldKey.currentState.hideCurrentSnackBar());
            }

            if (snapshot.data == null) {
              WidgetsBinding.instance.addPostFrameCallback((_) => openSnackbar("No Data", Duration(days: 1)));
            } else {
              if (showHistory == false) {
                historyModel = HistoryModel.fromJson(jsonDecode(snapshot.data));
                showHistory = true;

                for (var i = 0; i < historyModel.data.length; i++) {
                  messages.add(
                    _Messages(
                      historyModel.data[i].room,
                      historyModel.data[i].message,
                      historyModel.data[i].from,
                      historyModel.data[i].to,
                      historyModel.data[i].createdAt
                    )
                  );
                }

                reversedMessages = messages.reversed.toList(); //reversed list (Desc)
              } else {
                MessageModel message = MessageModel.fromJson(jsonDecode(snapshot.data));
                messages.add(_Messages(message.room, message.message, message.from, message.to, message.createdAt));
                reversedMessages = messages.reversed.toList(); //reversed list (Desc)
              }
            }

            return ListView.builder(
              padding: EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 4.0),
              itemCount: reversedMessages.length,
              reverse: true,
              itemBuilder: (context, index) {
                return viewHolderChat(
                    reversedMessages[index].message,
                    reversedMessages[index].createdAt,
                    true,
                    (reversedMessages[index].from == "S3") ? true : false
                );
              },
            );
          },
        ),
//        Column(
//          crossAxisAlignment: CrossAxisAlignment.start,
//          children: <Widget>[
//            Form(
//              child: TextFormField(
//                controller: _controller,
//                decoration: InputDecoration(labelText: 'Send a message'),
//              ),
//            ),
//
//
//          ],
//        ),
      ),

      floatingActionButton: Builder(
        builder: (context) => Container(
          height: 140.0,
          child: Column(
            children: <Widget>[
              FloatingActionButton(
                heroTag: 0,
                onPressed: _setGroup,
                tooltip: 'Set Group',
                child: Icon(Icons.group),
              ),
              SizedBox(height: 16.0,),
              FloatingActionButton(
                heroTag: 1,
                onPressed: (){
                  //openSnackbar("Coba", Duration(seconds: 3));
                  _sendMessage();
                }, //_sendMessage
                tooltip: 'Send message',
                child: Icon(Icons.send),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _setGroup() {
//    if (controllerRoom.text.isNotEmpty) {

//      final mapRoom = Map<String, dynamic>();
//      mapRoom["action"] = "subscribe";
//      mapRoom["room"] = controllerRoom.text;
//
//      print(mapRoom);
//      widget.channel.sink.add(mapRoom);

//      print('{"action":"subscribe","room":"'+ controllerRoom.text +'", "message":"' + controllerMessage.text + '"}');
//      widget.channel.sink.add('{"action":"subscribe","room":"'+ controllerRoom.text +'", "message":"' + controllerMessage.text + '"}');

    String room = "S3-T4";

    print('{"action":"subscribe","room":"'+ room +'"}');
    channel.sink.add('{"action":"subscribe","room":"'+ room +'"}');
//    }
  }

  void _sendMessage() {
//    if (controllerMessage.text.isNotEmpty) {
    String room = "S3-T4";

    print('{"action":"publish","room":"'+ room +'", "message":"' + "Ini Xiaomi" + '"}');
    channel.sink.add('{"action":"publish","room":"'+ room + '", "message":"' + "Ini Xiaomi" + '"}');
//    }
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
}

class _Messages {
  String room;
  String message;
  String from;
  String to;
  String createdAt;

  _Messages(this.room, this.message, this.from, this.to, this.createdAt);
}