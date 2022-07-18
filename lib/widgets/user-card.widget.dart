import 'package:flutter/material.dart';
import 'package:lifelog_app/components/avatar.widget.dart';
import 'package:lifelog_app/controllers/login.controller.dart';
import 'package:lifelog_app/views/auth/login.view.dart';
import '../user.dart';

class UserCard extends StatelessWidget {
  final controller = new LoginController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 40,
      ),
      width: double.infinity,
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          TDAvatar(
            width: 80,
            path: user.picture,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            user.name,
            style: TextStyle(
              color: Colors.black
            ),
          ),
          Text(
            user.email,
            style: TextStyle(
              color: Colors.black
            ),
          ),
          Container(
            child: TextButton(
              child: Text(
                "Sair da conta",
                style:
                TextStyle(
                  color: Colors.deepPurple
                )
              ),
              onPressed: () {
                controller.logout().then((data) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginView(),
                    ),
                  );
                }); // TRATAR POSSÍVEL ERRO
              },
            ),
          ),
          SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }
}
