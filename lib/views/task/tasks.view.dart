import 'package:flutter/material.dart';
import 'package:lifelog_app/views/task/create-task.view.dart';
import 'package:lifelog_app/widgets/task-list.widget.dart';
import 'package:provider/provider.dart';

import '../../controllers/task.controller.dart';
import '../../stores/app.store.dart';

class TasksView extends StatefulWidget {
  const TasksView({Key? key}) : super(key: key);

  @override
  State<TasksView> createState() => _TasksViewState();
}

class _TasksViewState extends State<TasksView> {
  @override
  Widget build(BuildContext context) {
    final store = Provider.of<AppStore>(context);
    final controller = TaskController(store);

    // only occours on first app start
    if (store.currentState == "none") {
      controller.changeSelection("all");
    }

    return Scaffold(
      body: const TaskList(),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (BuildContext context) {
                return FractionallySizedBox(
                    heightFactor: 0.9, child: CreateTaskView());
              },
            );
          },
          backgroundColor: Theme.of(context).colorScheme.secondary,
          child: const Icon(Icons.add)),
    );
  }
}
