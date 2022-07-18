import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:lifelog_app/controllers/task.controller.dart';
import 'package:lifelog_app/stores/app.store.dart';
import 'package:lifelog_app/widgets/busy.widget.dart';
import 'package:provider/provider.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<AppStore>(context);
    final controller = TaskController(store);

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
                          secondary: task.done == true
                              ? FloatingActionButton(
                                  mini: true,
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  onPressed: () {
                                    controller
                                        .delete(task)
                                        .then((value) => {setState(() {})})
                                        .catchError((err) => {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content:
                                                          Text(err.message)))
                                            });
                                  },
                                  child: const Icon(Icons.delete))
                              : null,
                          onChanged: (value) {
                            if (value == true) {
                              controller.markAsDone(task).then((data) {
                                setState(() {
                                  task.done = value!;
                                });
                              }).catchError((err) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(err.message)));
                              });
                            } else if (value == false) {
                              controller.markAsUndone(task).then((data) {
                                setState(() {
                                  task.done = value!;
                                });
                              }).catchError((err) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(err.message)));
                              });
                            }
                          },
                        )),
                    Divider(color: Theme.of(context).primaryColor)
                  ]);
                },
              ),
      ),
    );
  }
}
