import 'dart:io';
import 'dart:async';

import 'package:flight_info_app/main.dart';
import 'package:flight_info_app/models/lane.dart';
import 'package:flight_info_app/services/lane_service.dart';
import 'package:flight_info_app/services/socket_notifier.dart';
import 'package:flight_info_app/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SocketClient {
  static final SocketClient _instance = SocketClient._internal();
  Socket? _socket;
  bool _shouldReconnect = true;
  BuildContext? context;
  List<Lane> lanes = database.store.box<Lane>().getAll();
  Function(String)? boardingStartCallback;
  Function(String)? boardingEndCallback;

  factory SocketClient() {
    return _instance;
  }

  SocketClient._internal();

  Future<void> connect() async {
    while (_shouldReconnect) {
      try {
        _shouldReconnect = false; // Reset the reconnection flag
        _socket = await Socket.connect('3.111.72.224', 2100, timeout: const Duration(seconds: 10));
        print(
            'Connected to: ${_socket?.remoteAddress.address}:${_socket?.remotePort}');
        Provider.of<SocketStatusNotifier>(context!, listen: false)
            .setConnectionState(SocketStatus.connected);

        sendLaneCommand();

        _socket?.listen(
          (List<int> data) {
            String serverResponse = String.fromCharCodes(data);
            if (serverResponse.contains('\u0002') &&
                serverResponse.contains('\u0003')) {
              String command =
                  serverResponse.split('\u0002')[1].split('\u0003')[0];
              switch (command) {
                case lnERR:
                print("Lane Error");
                    Provider.of<SocketStatusNotifier>(context!, listen: false)
                    .setConnectionState(SocketStatus.disconnected);
                  break;
                  case lnOK:
                    Provider.of<SocketStatusNotifier>(context!, listen: false)
                    .setConnectionState(SocketStatus.connected);
                    break;
                   case bsERR:
                   case bsOK:
                      boardingStartCallback!(command);
                   case beERR:
                   case beOK:
                      boardingEndCallback!(command);
                    break;
                default:
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
            _shouldReconnect = true; // Set the flag for reconnection
          },
          onError: (error) {
            print('Error: $error');
            Provider.of<SocketStatusNotifier>(context!, listen: false)
                    .setConnectionState(SocketStatus.error);
            _socket?.destroy();
            _shouldReconnect = true;
          },
          cancelOnError: true,
        );

        // Wait for 5 seconds before attempting reconnection
        await Future.delayed(const Duration(seconds: 5));
      } catch (e) {
        print('Error connecting to the server: $e');
         Provider.of<SocketStatusNotifier>(context!, listen: false)
                    .setConnectionState(SocketStatus.error);
        _shouldReconnect = true; 
        await Future.delayed(const Duration(seconds: 5));
      }
    }
  }

  void sendLaneCommand(){
      String laneCommand = LaneService.getLaneCommand();  
      _socket?.writeln("\u0002LN\u0003$laneCommand");
  }

  void startBoardingCommand(String command, Function(String) onCallback){
    boardingStartCallback = onCallback;
     _socket?.writeln("\u0002BS\u0003$command");
  }

  void endBoardingCommand(Function(String) onCallback){
    boardingEndCallback = onCallback;
     _socket?.writeln("\u0002BE\u0003\n");
  }

  void disconnect() {
    _socket?.destroy();
    _shouldReconnect = false;
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
