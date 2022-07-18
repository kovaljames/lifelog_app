import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:lifelog_app/controllers/task.controller.dart';
import 'package:lifelog_app/stores/app.store.dart';

class Navbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final store = Provider.of<AppStore>(context);
    final controller = TaskController(store);

    return Container(
      width: double.infinity,
      height: 80,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Observer(
            builder: (_) => TextButton(
              child: Text(
                "Todas",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: store.currentState == "all"
                      ? FontWeight.bold
                      : FontWeight.w100,
                ),
              ),
              onPressed: () {
                controller.changeSelection("all");
              },
            ),
          ),
        ],
      ),
    );
  }
}