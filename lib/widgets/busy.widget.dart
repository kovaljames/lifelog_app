import 'package:flutter/material.dart';

class TDBusy extends StatelessWidget {
  bool busy = false;
  Widget child;

  TDBusy({Key? key, required this.busy, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return busy
        ? Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : child;
  }
}
