import 'package:lifelog_app/models/task.model.dart';
import 'package:lifelog_app/repositories/task.repository.dart';
import 'package:lifelog_app/stores/app.store.dart';

class TaskController {
  late AppStore _store;
  late TaskRepository _repository;

  TaskController(AppStore store) {
    _store = store;
    _repository = TaskRepository();
  }

  void changeSelection(String selection) {
    _store.clearTasks();

    switch (selection) {
      case "all":
        {
          _store.busy = true;
          _store.changeSelected("all");
          _repository.getAll().then((data) {
            _store.setTasks(data);
            _store.busy = false;
          });
          return;
        }
    }
  }

  Future getAllByTitle(String title) async {
    _store.busy = true;
    await _repository.getAllByTitle(title);
    _store.busy = false;
  }

  Future add(Task task) async {
    _store.busy = true;
    await _repository.create(task);
    _store.busy = false;
    changeSelection(_store.currentState);
  }

  Future update(Task task) async {
    _store.busy = true;
    await _repository.update(task);
    _store.busy = false;
    changeSelection(_store.currentState);
  }

  Future markAsDone(Task item) async {
    _store.busy = true;
    await _repository.markAsDone(item);
    _store.busy = false;
    changeSelection(_store.currentState);
  }

  Future markAsUndone(Task item) async {
    _store.busy = true;
    await _repository.markAsUndone(item);
    _store.busy = false;
    changeSelection(_store.currentState);
  }

  Future delete(Task task) async {
    _store.busy = true;
    await _repository.delete(task);
    _store.busy = false;
    changeSelection(_store.currentState);
  }
}
