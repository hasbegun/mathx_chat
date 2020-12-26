import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:mathx_chat/ChatScreen.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  runApp(MathXChatApp());
}

final ThemeData kIOSTheme = new ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light,
);

final ThemeData kDefaultTheme = new ThemeData(
  primarySwatch: Colors.purple,
  accentColor: Colors.orangeAccent[400],
);

class MathXChatApp extends StatelessWidget {

  final String title = 'MathX Chat';
  // final websocketServerInfo = {'protocol': 'ws',
  //                              'domain': 'localhost',
  //                              'port': 34596,
  //                              'path': 'websocket'};
  // final String protocol = 'ws';
  // final String wsDomain = 'localhost';
  // final int wsPort = 34596;
  // final String wsPath = 'websocket';
  // final WebSocketChannel channel = IOWebSocketChannel.connect('ws://$wsDomain:$wsPort/$wsPath');
  // final WebSocketChannel channel = IOWebSocketChannel.connect('wss://echo.websocket.org'); // debug

  // FIXME: Android emulator doesn't work with localhost.
  // Emulator may point back if localhost is used.
  // however, localhost:port just works well on the iPhone emulator.
  final String serverAddress = 'ws://172.17.0.2:34596/websocket';
  // final String serverAddress = 'ws://chatservice.mathx.com:34596/websocket';

  // docker container ip is 172.17.0.2
  final String serverAddressIP = 'ws://172.17.0.2:34596/websocket';

  // echo server for debug
  // final String serverAddress = 'wss://echo.websocket.org';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MathX 2',
      theme: defaultTargetPlatform == TargetPlatform.iOS
          ? kIOSTheme : kDefaultTheme,
      home: ChatScreen(title: title,
          serverAddress: defaultTargetPlatform == TargetPlatform.iOS
              ? serverAddress : serverAddressIP),
        // serverAddress: serverAddress),
    );
  }
}

