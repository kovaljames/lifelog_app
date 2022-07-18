import 'package:flutter/material.dart';
import 'package:lifelog_app/controllers/login.controller.dart';
import 'package:lifelog_app/views/auth/login.view.dart';
import 'package:lifelog_app/widgets/busy.widget.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:email_validator/email_validator.dart';

class ForgotPassView extends StatefulWidget {
  @override
  _ForgotPassView createState() => _ForgotPassView();
}

class _ForgotPassView extends State<ForgotPassView> {
  final controller = LoginController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  String email = "";
  bool busy = false;

  handleResetPass(String email) {
    setState(() {
      busy = true;
    });
    controller.resetPassword(email).then((data) {
      onSuccess();
    }).catchError((err) {
      onError(err);
    }).whenComplete(() {
      onComplete();
    });
  }

  onSuccess() {
    const snackBar = SnackBar(
      content:
          Text('E-mail enviado! Para concluir o processo, siga as instruções!'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Future.delayed(const Duration(milliseconds: 5000), () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginView(),
        ),
      );
    });
  }

  onError(err) {
    if (err.code == "auth/user-not-found") {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Usuário não encontrado!")));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(err.message)));
    }
  }

  onComplete() {
    setState(() {
      busy = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30),
            child: TDBusy(
              busy: busy,
              child: Card(
                child: Container(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        "Esqueceu a senha?",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              onSaved: (String? value) {
                                email = value!;
                              },
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  labelText: "E-mail",
                                  labelStyle: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14)),
                              validator: (value) {
                                if (value != null && value.isEmpty) {
                                  return 'E-mail é obrigatório!';
                                } else if (value != null &&
                                    !EmailValidator.validate(value, true)) {
                                  return 'Insira um e-mail válido!';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SignInButtonBuilder(
                              icon: Icons.restore,
                              text: "Enviar instruções",
                              backgroundColor: Colors.deepPurple,
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  handleResetPass(email);
                                }
                              },
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginView(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Voltar ao Login',
                                style: TextStyle(
                                  color: Colors.deepPurple
                                ),
                              )
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
