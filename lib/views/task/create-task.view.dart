import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:intl/intl.dart';
import 'package:lifelog_app/controllers/task.controller.dart';
import 'package:lifelog_app/views/task/tasks.view.dart';
import 'package:lifelog_app/widgets/user-card.widget.dart';
import 'package:provider/provider.dart';
import 'package:lifelog_app/models/task.model.dart';
import 'package:lifelog_app/stores/app.store.dart';
import '../home.view.dart';

class CreateTaskView extends StatefulWidget {
  @override
  _CreateTaskViewState createState() => _CreateTaskViewState();
}

class _CreateTaskViewState extends State<CreateTaskView> {
  final _formKey = GlobalKey<FormState>();
  final _dateFormat = DateFormat('dd/MM/yyyy');

  String title = "";
  String desc = "";
  DateTime dateInit = DateTime.now();
  DateTime dateEnd = DateTime.now();
  String user = "";

  Future _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dateEnd,
      firstDate: DateTime(2000, 1),
      lastDate: DateTime(2040),
    );
    if (picked != null && picked != dateEnd) {
      setState(() {
        dateEnd = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<AppStore>(context);
    final controller = TaskController(store);

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(40.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "Título da tarefa",
                    labelStyle: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).primaryColor,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Título Inválido';
                    }
                    return null;
                  },
                  onSaved: (val) {
                    title = val!;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                  ),
                  child: Text(
                    _dateFormat.format(dateEnd),
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  child: const Text("Alterar Data"),
                  onPressed: () {
                    _selectDate(context);
                  },
                )
              ],
            ),
          ),
        ),
        SignInButtonBuilder(
          icon: Icons.save,
          text: "Criar tarefa",
          backgroundColor: Colors.deepPurple,
          onPressed: () {
            if (!_formKey.currentState!.validate()) {
              return;
            }

            _formKey.currentState!.save();
            var task = Task(
                id: 0,
                title: title,
                done: false,
                dateInit: dateInit,
                dateEnd: dateEnd,
                desc: desc,
                user: user);

            controller.add(task).then((_) {
              Navigator.pop(context);
            });
          },
        ),
        TextButton(
          child: const Text("Cancelar"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );

    // return Scaffold(
    //   appBar: AppBar(
    //     backgroundColor: Theme.of(context).primaryColor,
    //     title: const Text('Criar nova tarefa'),
    //     automaticallyImplyLeading: false
    //   ),
    //   body: SingleChildScrollView(
    //     child: Column(
    //       children: <Widget>[
    //         Padding(
    //           padding: const EdgeInsets.all(40.0),
    //           child: Form(
    //             key: _formKey,
    //             child: Column(
    //               children: <Widget>[
    //                 TextFormField(
    //                   keyboardType: TextInputType.text,
    //                   decoration: InputDecoration(
    //                     labelText: "Título da tarefa",
    //                     labelStyle: TextStyle(
    //                       color: Theme.of(context).primaryColor,
    //                       fontWeight: FontWeight.w400,
    //                       fontSize: 16,
    //                     ),
    //                   ),
    //                   style: TextStyle(
    //                     fontSize: 20,
    //                     color: Theme.of(context).primaryColor,
    //                   ),
    //                   validator: (value) {
    //                     if (value!.isEmpty) {
    //                       return 'Título Inválido';
    //                     }
    //                     return null;
    //                   },
    //                   onSaved: (val) {
    //                     title = val!;
    //                   },
    //                 ),
    //                 Padding(
    //                   padding: const EdgeInsets.only(
    //                     top: 20,
    //                   ),
    //                   child: Text(
    //                     _dateFormat.format(dateEnd),
    //                     style: TextStyle(
    //                       color: Theme.of(context).primaryColor,
    //                       fontSize: 34,
    //                       fontWeight: FontWeight.bold,
    //                     ),
    //                   ),
    //                 ),
    //                 TextButton(
    //                   child: const Text("Alterar Data"),
    //                   onPressed: () {
    //                     _selectDate(context);
    //                   },
    //                 )
    //               ],
    //             ),
    //           ),
    //         ),
    //         Padding(
    //           padding: const EdgeInsets.only(
    //             left: 40.0,
    //             right: 40,
    //             top: 20,
    //             bottom: 10,
    //           ),
    //           child: SignInButtonBuilder(
    //             icon: Icons.save,
    //             text: "Salvar tarefa",
    //             backgroundColor: Colors.deepPurple,
    //             onPressed: () {
    //               if (!_formKey.currentState!.validate()) {
    //                 return;
    //               }

    //               _formKey.currentState!.save();
    //               var task = Task(
    //                 id: 0,
    //                 title: title,
    //                 done: false,
    //                 dateInit: dateInit,
    //                 dateEnd: dateEnd,
    //                 desc: desc,
    //                 user: user
    //               );

    //               controller.add(task).then((_) {
    //               Navigator.push(
    //                 context,
    //                 MaterialPageRoute(
    //                   builder: (context) => HomeView(),
    //                 ),
    //               );
    //             });
    //             },
    //           ),
    //         ),
    //         TextButton(
    //           child: const Text("Cancelar"),
    //           onPressed: () {
    //             Navigator.push(
    //               context,
    //               MaterialPageRoute(
    //                 builder: (context) => HomeView(),
    //               ),
    //             );
    //           },
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
