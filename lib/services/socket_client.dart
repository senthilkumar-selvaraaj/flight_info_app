import 'dart:io';
import 'dart:async';

import 'package:aai_chennai/main.dart';
import 'package:aai_chennai/models/lane.dart';
import 'package:aai_chennai/services/lane_service.dart';
import 'package:aai_chennai/services/socket_notifier.dart';
import 'package:aai_chennai/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SocketClient {
  static final SocketClient _instance = SocketClient._internal();
  Socket? _socket;
  bool _isConnected = false;
  BuildContext? context;
  List<Lane> lanes = database.store.box<Lane>().getAll();
  Function(String)? boardingStartCallback;
  Function(String)? boardingEndCallback;
  Function(String)? boardingCallback;

  bool get isConnected => _isConnected;

 String startBaordingCommand = "";

  factory SocketClient() {
    return _instance;
  }

  SocketClient._internal();

  Future<void> connect() async {
      try {
        //Local IP 192.168.1.11
        // Remote IP  3.111.72.224
        _socket = await Socket.connect('192.168.1.11', 2100,
            timeout: const Duration(seconds: 10));
        _isConnected = true;
        print(
            'Connected to: ${_socket?.remoteAddress.address}:${_socket?.remotePort}');
        Provider.of<SocketStatusNotifier>(context!, listen: false)
            .setConnectionState(SocketStatus.connected);

        sendLaneCommand();

        _socket?.listen(
          (List<int> data) {
            String serverResponse = String.fromCharCodes(data);
            print('LISTEN : $serverResponse');
            if (serverResponse.contains('\u0002') &&
                serverResponse.contains('\u0003')) {
              String command =
                  serverResponse.split('\u0002')[1].split('\u0003')[0];

              switch (command) {
                case lnERR:
                  Provider.of<SocketStatusNotifier>(context!, listen: false)
                      .setConnectionState(SocketStatus.disconnected);
                  if (boardingStartCallback != null) {
                    boardingStartCallback!(command);
                    boardingStartCallback = null;
                  }
                  if (boardingEndCallback != null) {
                    boardingEndCallback!(command);
                    boardingEndCallback = null;
                  }
                  break;
                case lnOK:
                  if(startBaordingCommand != ''){
                    print("BS COMMAND ==>");
                    restartBoardingCommand();
                  }
                  Provider.of<SocketStatusNotifier>(context!, listen: false)
                      .setConnectionState(SocketStatus.connected);
                  break;
                case bsERR:
                case bsOK:
                  if (boardingStartCallback != null) {
                    boardingStartCallback!(command);
                    boardingStartCallback = null;
                  }
                case beERR:
                case beOK:
                  if (boardingEndCallback != null) {
                    boardingEndCallback!(command);
                    boardingEndCallback = null;
                  }
                case cCStatus:
                  if (boardingCallback != null) {
                    boardingCallback!(serverResponse);
                  }
                  break;
                default:
              }

              switch (command) {
                case lnERR:
                case bsERR:
                case beERR:
                Provider.of<SocketStatusNotifier>(context!, listen: false)
                      .setConnectionState(SocketStatus.disconnected);
                      break;
                default:
                break;
              }

            } else {
              print('STX or ETX markers not found in data: $serverResponse');
            }
          },
          onDone: () {
            print('Socket closed');
            Provider.of<SocketStatusNotifier>(context!, listen: false)
                .setConnectionState(SocketStatus.disconnected);
            _socket?.destroy();
            _isConnected = false; 
            _retryConnection();// Set the flag for reconnection
          },
          onError: (error) {
            print('Error: $error');
            Provider.of<SocketStatusNotifier>(context!, listen: false)
                .setConnectionState(SocketStatus.error);
            _socket?.destroy();
            _isConnected = false; 
            _retryConnection();
          },
          cancelOnError: true,
        );

        // Wait for 5 seconds before attempting reconnection
        await Future.delayed(const Duration(seconds: 5));
      } catch (e) {
        print('Error connecting to the server: $e');
        Provider.of<SocketStatusNotifier>(context!, listen: false)
            .setConnectionState(SocketStatus.error);
        _isConnected = false; 
        _retryConnection();
      }
  }

  void _retryConnection() {
    if (!_isConnected) {
      print('Retrying connection in 5 seconds...');
      Future.delayed(const Duration(seconds: 5), () {
        connect();
      });
    }
  }


  void sendLaneCommand() {
    String laneCommand = LaneService.getLaneCommand();
    _socket?.writeln("\u0002LN\u0003$laneCommand");
  }
  
  void startBoardingCommand(String command, Function(String) onCallback) {
    boardingStartCallback = onCallback;
    startBaordingCommand = "\u0002BS\u0003$command";
    _socket?.writeln("\u0002BS\u0003$command");
  }

  void restartBoardingCommand(){
    _socket?.writeln(startBaordingCommand);
  }

  void endBoardingCommand(Function(String) onCallback) {
    startBaordingCommand = "";
    boardingEndCallback = onCallback;
    _socket?.writeln("\u0002BE\u0003\n");
  }

  void listenBoardingEvent(Function(String) onCallback) {
    boardingCallback = onCallback;
  }

  void disconnect() {
    _socket?.destroy();
    _isConnected = false;
  }
}

enum SocketStatus {
  none,
  connected,
  disconnected,
  error;

  Color getColor() {
    switch (this) {
      case SocketStatus.none:
        return Colors.transparent;
      case SocketStatus.connected:
        return Colors.green;
      case SocketStatus.disconnected:
        return Colors.orange;
      case SocketStatus.error:
        return Colors.red;
      default:
        return Colors.transparent;
    }
  }
}
