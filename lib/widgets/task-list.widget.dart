import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:lifelog_app/controllers/task.controller.dart';
import 'package:lifelog_app/stores/app.store.dart';
import 'package:lifelog_app/widgets/busy.widget.dart';

class TaskList extends StatefulWidget {
  const TaskList({Key? key}) : super(key: key);

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  DateFormat _dateFormat = DateFormat();
  final ScrollController _scroll = ScrollController();
  int _currentMax = 10;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('pt_BR', null);
    _dateFormat = DateFormat.MMMMd('pt_BR');
    _scroll.addListener(() {
      if (_scroll.position.pixels == _scroll.position.maxScrollExtent) {
        _getmoreData();
      }
    });
  }

  _getmoreData() {
    for (var i = _currentMax; i < _currentMax + 10; i++) {}
    _currentMax += 10;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<AppStore>(context);
    final taskController = TaskController(store);

    final theme = Theme.of(context);
    final oldCheckboxTheme = theme.checkboxTheme;
    final newCheckBoxTheme = oldCheckboxTheme.copyWith(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
    ); // rounded checkbox

    return Observer(
      builder: (_) => TDBusy(
        busy: store.busy,
        child: store.tasks.isEmpty
            ? const Center(
                child: Text("Nenhuma tarefa encontrada!"),
              )
            : ListView.builder(
                controller: _scroll,
                padding: const EdgeInsets.only(left: 20, right: 20),
                itemCount: store.tasks.length,
                itemBuilder: (context, index) {
                  var task = store.tasks[index];

                  return Column(children: <Widget>[
                    Theme(
                        data: theme.copyWith(checkboxTheme: newCheckBoxTheme),
                        child: CheckboxListTile(
                          key: Key(task.title),
                          value: task.done,
                          controlAffinity: ListTileControlAffinity.leading,
                          activeColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100)),
                          side: MaterialStateBorderSide.resolveWith(
                            (states) => BorderSide(
                                color: Theme.of(context).primaryColor),
                          ),
                          title: Text(
                            task.title,
                            style: TextStyle(
                              fontSize: 14,
                              color: task.done
                                  ? Colors.black.withOpacity(0.2)
                                  : Colors.black,
                            ),
                          ),
                          subtitle: Text(_dateFormat.format(task.dateEnd),
                              style: const TextStyle(
                                fontSize: 12,
                              )),
                          secondary: task.done == true
                              ? IconButton(
                                  icon: const Icon(Icons.delete),
                                  color: Theme.of(context).primaryColor,
                                  splashRadius: 20.0,
                                  onPressed: () {
                                    taskController
                                        .delete(task)
                                        .then((value) => {setState(() {})})
                                        .catchError(
                                          (err) => {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(err.message),
                                              ),
                                            )
                                          },
                                        );
                                  },
                                )
                              : null,
                          onChanged: (value) {
                            if (value == true) {
                              taskController.markAsDone(task).then((data) {
                                setState(() {
                                  task.done = value!;
                                });
                              }).catchError((err) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(err.message)));
                              });
                            } else if (value == false) {
                              taskController.markAsUndone(task).then((data) {
                                setState(() {
                                  task.done = value!;
                                });
                              }).catchError((err) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(err.message)));
                              });
                            }
                          },
                          // onLongPress: () {
                          //   showDialog(
                          //     context: context,
                          //     builder: (BuildContext context) {
                          //       return AlertDialog(
                          //         title: const Text("Concluir a Tarefa"),
                          //         content:
                          //             Text("Deseja concluir a tarefa ${task.title}?"),
                          //         actions: <Widget>[
                          //           TextButton(
                          //             child: const Text("Cancelar"),
                          //             onPressed: () {
                          //               Navigator.of(context).pop();
                          //             },
                          //           ),
                          //           TextButton(
                          //             child: const Text(
                          //               "Concluir",
                          //               style: TextStyle(
                          //                 color: Colors.green,
                          //               ),
                          //             ),
                          //             onPressed: () {
                          //               controller.markAsDone(task).then((data) {
                          //                 Navigator.of(context).pop();
                          //               }).catchError((err) {
                          //                 ScaffoldMessenger.of(context)
                          //                   .showSnackBar(SnackBar(content: Text(err.message)));
                          //               });
                          //             },
                          //           ),
                          //         ],
                          //       );
                          //     },
                          //   );
                          // },
                        )),
                    Divider(color: Theme.of(context).primaryColor)
                  ]);
                },
              ),
      ),
    );
  }
}
