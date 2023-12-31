
import 'package:aai_chennai/services/socket_client.dart';
import 'package:flutter/material.dart';

class SocketStatusNotifier with ChangeNotifier {
  
  SocketStatus _connectionState = SocketStatus.none;

  SocketStatus get connectionState => _connectionState;

  void setConnectionState(SocketStatus state) {
   _connectionState = state;
    notifyListeners();
  }
}