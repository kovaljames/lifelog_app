import 'package:flutter/material.dart';
import 'package:lifelog_app/controllers/login.controller.dart';
import 'package:lifelog_app/views/auth/forgotpass.view.dart';
import 'package:lifelog_app/views/home.view.dart';
import 'package:lifelog_app/views/auth/register.view.dart';
import 'package:lifelog_app/widgets/busy.widget.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:email_validator/email_validator.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final controller = LoginController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool busy = false;
  bool _passwordInVisible = true;

  handleSocialSignIn() {
    setState(() {
      busy = true;
    });
    controller.socialLogin().then((data) {
      onSuccess();
    }).catchError((err) {
      onError(err);
    }).whenComplete(() {
      onComplete();
    });
  }

  handleSignIn(String email, String password) {
    setState(() {
      busy = true;
    });
    controller.login(email, password).then((data) {
      onSuccess();
    }).catchError((err) {
      onError(err);
    }).whenComplete(() {
      onComplete();
    });
  }

  onSuccess() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeView(),
      ),
    );
  }

  onError(err) {
    if (err.code == "user-not-found") {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Usuário não encontrado!")));
    } else if (err.code == 'auth/wrong-password' ||
        err.code == 'auth/wrong-email') {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Usuário ou senha inválidos!")));
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
                        "Lifelog",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SignInButton(
                        Buttons.Google,
                        text: "Continuar com o Google",
                        onPressed: () {
                          handleSocialSignIn();
                        },
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
                                  fontSize: 14,
                                ),
                              ),
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
                            TextFormField(
                              onSaved: (String? value) {
                                password = value!;
                              },
                              keyboardType: TextInputType.text,
                              obscureText: _passwordInVisible,
                              decoration: InputDecoration(
                                labelText: "Senha",
                                labelStyle: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _passwordInVisible
                                        ? Icons.visibility_off
                                        : Icons
                                            .visibility, //change icon based on boolean value
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _passwordInVisible =
                                          !_passwordInVisible; //change boolean value
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value != null && value.isEmpty) {
                                  return 'Senha é obrigatório!';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SignInButtonBuilder(
                              icon: Icons.login,
                              text: "Continuar com o E-mail",
                              backgroundColor: Colors.deepPurple,
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  handleSignIn(email, password);
                                }
                              },
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ForgotPassView(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Esqueceu a senha?',
                                  style: TextStyle(color: Colors.deepPurple),
                                )),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RegisterView(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Criar nova conta',
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
