import 'package:flutter/material.dart';
import 'package:lifelog_app/controllers/login.controller.dart';
import 'package:lifelog_app/views/auth/login.view.dart';
import 'package:lifelog_app/widgets/busy.widget.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:email_validator/email_validator.dart';

class RegisterView extends StatefulWidget {
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final controller = LoginController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String confirmPassword = "";
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  bool busy = false;

  handleRegister(String email, String password) {
    setState(() {
      busy = true;
    });
    controller.register(email, password).then((data) {
      onSuccess();
    }).catchError((err) {
      onError(err);
    }).whenComplete(() {
      onComplete();
    });
  }

  onSuccess() {
    const snackBar = SnackBar(
      content: Text("Cadastro efetuado com sucesso!"
          " Um link de confirmação foi enviado para o seu e-mail!"),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Future.delayed(const Duration(milliseconds: 8000), () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginView(),
        ),
      );
    });
  }

  onError(err) {
    if (err.code == "weak-password") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Senha deve ter no mínimo 6 caracteres!")));
    } else if (err.code == 'email-already-in-use') {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("E-mail já está em uso!")));
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
                        width: double.infinity,
                      ),
                      const Text(
                        "Cadastre-se na Lifelog",
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        "Ao realizar o cadastro, concordo com a Política de privacidade"
                        " e com os Termos de uso da Lifelog",
                        style: TextStyle(fontSize: 10, color: Colors.black54),
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
                                if (value!.isEmpty) {
                                  return 'E-mail é obrigatório!';
                                } else if (value.isEmpty &&
                                    !EmailValidator.validate(value, true)) {
                                  return 'Insira um e-mail válido!';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              onSaved: (String? value) {
                                password = value!;
                              },
                              controller: _pass,
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: "Senha",
                                labelStyle: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14),
                              ),
                              validator: (value) {
                                if (value != null && value.isEmpty) {
                                  return 'Senha é obrigatório!';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: _confirmPass,
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: "Confirmar Senha",
                                labelStyle: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14),
                              ),
                              validator: (value) {
                                if (value != null && value.isEmpty) {
                                  return 'Confirmar Senha é obrigatório!';
                                }
                                if (value != null && value != _pass.text) {
                                  return 'As senhas não coincidem!';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SignInButtonBuilder(
                              icon: Icons.account_circle_outlined,
                              text: "Registrar a sua conta",
                              backgroundColor: Colors.deepPurple,
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  handleRegister(email, password);
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
                                  style: TextStyle(color: Colors.deepPurple),
                                )),
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
