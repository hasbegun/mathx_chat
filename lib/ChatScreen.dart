import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

class ChatScreen extends StatefulWidget {
  final String title;
  final String serverAddress;
  final String name;

  ChatScreen({Key key,
    @required this.title, @required this.serverAddress, @required this.name})
      : super(key: key);

  @override
  State createState() => new ChatScreenState();
}

class ChatScreenState extends State<ChatScreen>
                      with TickerProviderStateMixin {
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = new TextEditingController();
  bool _isComposing = false; // make it true whenever the user is typing in the input field.
  WebSocketChannel channel;

  initCommunication(String serverAdress) async {
    try {
      channel = await IOWebSocketChannel.connect(serverAdress);
      channel.stream.listen((message) {
        if (message.length > 0) {
          // Server sends back the message {'text': 'message'} format.
          ChatMessage res = ChatMessage(
            text: jsonDecode(message)['text'],
            name: 'Teacher',
            animationController: AnimationController(
              duration: Duration(milliseconds: 700),
              vsync: this,
            ),
          );
          setState(() {
            _messages.insert(0, res);
          });
          res.animationController.forward();
        }
      });
    } catch (err) {
      // fixme: need to retry... if failed to connect.
      print('Unable to connect the server');
    }
  }

  @override
  void initState() {
    super.initState();
    initCommunication(widget.serverAddress);
  }

  /* Modify _handleSubmitted to update _isComposing to false
  when the text field is cleared.*/
  Future<Null> _handleSubmitted(String text) async {
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
    ChatMessage message = new ChatMessage(
      text: text,
      name: widget.name,
      animationController: new AnimationController(
        duration: new Duration(milliseconds: 700),
        vsync: this,
      ),
    );

    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();

    // must wrap the message into 'text'
    await channel.sink.add(json.encode({'text': message.text}));
  }

  void dispose() {
    for (ChatMessage message in _messages)
      message.animationController.dispose();
    channel.sink.close();
    super.dispose();
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onChanged: (String text) {
                  setState(() {
                    _isComposing = text.length > 0;
                  });
                },
                onSubmitted: _handleSubmitted,
                decoration:
                  InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                child: Theme.of(context).platform == TargetPlatform.iOS
                    ? CupertinoButton(
                  child: Text("Send"),
                  onPressed: _isComposing
                      ? () => _handleSubmitted(_textController.text)
                      : null,
                )
                    : IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _isComposing
                      ? () => _handleSubmitted(_textController.text)
                      : null,
                )),
          ]),
          decoration: Theme.of(context).platform == TargetPlatform.iOS
              ? BoxDecoration(
              border:
              Border(top: BorderSide(color: Colors.grey[200])))
              : null),
    );
  }

  void _showSetting() {
  //  Fixme: need to be implemented
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("MathX Chat"),
          elevation:
            Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
          actions: <Widget> [
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: _showSetting,
            ),
          ]
      ),

      body: Container(
          child: Column(
              children: <Widget>[
                Flexible(
                    child: ListView.builder(
                      padding: EdgeInsets.all(8.0),
                      reverse: true,
                      itemBuilder: (_, int index) => _messages[index],
                      itemCount: _messages.length,
                    )
                ),
                Divider(height: 1.0),
                Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor),
                  child: _buildTextComposer(),
                ),
              ]
          ),
          decoration: Theme.of(context).platform == TargetPlatform.iOS
              ? BoxDecoration(
                border: Border(
                    top: BorderSide(
                        color: Colors.grey[200])))
              : null),//new
    );
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.animationController, this.name});
  final String name;
  final String text;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
        sizeFactor: CurvedAnimation(
            parent: animationController,
            curve: Curves.easeOut
        ),
        axisAlignment: 0.0,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(right: 16.0),
                child: CircleAvatar(child: Text(name[0])),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(name,
                        style: Theme.of(context).textTheme.subhead),
                    Container(
                      margin: const EdgeInsets.only(top: 5.0),
                      child: Text(text),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }
}
