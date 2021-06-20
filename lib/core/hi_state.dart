import 'package:flutter/material.dart';

abstract class HiState<T extends StatefulWidget> extends State<T> {
  @override
  void setState(VoidCallback fn) {
    if(mounted) {
      super.setState(fn);
    }else {
      print('page has destroyed,current page ${toString()}');
    }
  }
}
