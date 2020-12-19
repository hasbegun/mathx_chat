import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:mathx_chat/ChatScreen.dart';

void main() {
  runApp(MyApp());
}

final ThemeData kIOSTheme = new ThemeData(
  primarySwatch: Colors.black12,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light,
);

final ThemeData kDefaultTheme = new ThemeData(
  primarySwatch: Colors.black12,
  accentColor: Colors.orangeAccent[400],
);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final title = 'MathX Chat';
  final wsDomain = 'localhost';
  final wsPort = 34596;
  final wsPath = 'websocket';
  // final channel = IOWebSocketChannel.connect('ws://$wsDomain:$wsPort/$wsPath');
  final channel = IOWebSocketChannel.connect('wss://echo.websocket.org'); // debug

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MathX 2',
      theme: defaultTargetPlatform == TargetPlatform.iOS
          ? kIOSTheme : kDefaultTheme,
      home: ChatScreen(title, channel),
    );
  }
}

