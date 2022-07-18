
import 'package:mobx/mobx.dart';
import 'package:lifelog_app/models/task.model.dart';
part 'app.store.g.dart';

class AppStore = _AppStore with _$AppStore;

abstract class _AppStore with Store {
  @observable
  String currentState = "none";

  @observable
  bool busy = false;

  @observable
  ObservableList<Task> tasks = ObservableList<Task>();

  @action
  void changeSelected(String state) {
    currentState = state;
  }

  @action
  void addTask(Task item) {
    tasks.add(item);
  }

  @action
  void setTasks(List<Task> items) {
    tasks.addAll(items);
  }

  @action
  void clearTasks() {
    tasks = ObservableList<Task>();
  }
}