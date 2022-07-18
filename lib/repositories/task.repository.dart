import 'dart:io';
import 'package:lifelog_app/user.dart';
import 'package:dio/dio.dart';
import 'package:lifelog_app/models/task.model.dart';

class TaskRepository {
  Future<List<Task>> getAll() async {
    var url = "https://10.0.2.2:7010/v1/tasks";

    try {
      Response response = await Dio().get(
        url,
        options: Options(
          headers: {HttpHeaders.authorizationHeader: 'Bearer ${user.token}'},
        ),
      );
      return (response.data["data"]["tasks"] as List)
          .map((tasks) => Task.fromJson(tasks))
          .toList();
    } catch (e) {
      return List.empty();
    }
  }

  Future<List<Task>> getAllByTitle(String title) async {
    var url = "https://10.0.2.2:7010/v1/tasks/title";

    try {
      Response response = await Dio().get(
        url,
        options: Options(
          headers: {HttpHeaders.authorizationHeader: 'Bearer ${user.token}'},
        ),
      );
      return (response.data["data"]["tasks"] as List)
          .map((tasks) => Task.fromJson(tasks))
          .toList();
    } catch (e) {
      return List.empty();
    }
  }

  Future<Task?> create(Task item) async {
    var url = "https://10.0.2.2:7010/v1/tasks/create";

    try {
      Response response = await Dio().post(
        url,
        data: item,
        options: Options(
          headers: {HttpHeaders.authorizationHeader: 'Bearer ${user.token}'},
        ),
      );
      return Task.fromJson(response.data["data"]);
    } catch (e) {
      return null;
    }
  }

  Future<Task?> update(Task item) async {
    var url = "https://10.0.2.2:7010/v1/tasks/update";

    try {
      Response response = await Dio().put(
        url,
        data: item,
        options: Options(
          headers: {HttpHeaders.authorizationHeader: 'Bearer ${user.token}'},
        ),
      );
      return Task.fromJson(response.data["data"]);
    } catch (e) {
      return null;
    }
  }

  Future<Task?> markAsDone(Task item) async {
    var url = "https://10.0.2.2:7010/v1/tasks/update/mark-as-done";

    try {
      Response response = await Dio().put(
        url,
        data: item,
        options: Options(
          headers: {HttpHeaders.authorizationHeader: 'Bearer ${user.token}'},
        ),
      );
      return Task.fromJson(response.data["data"]);
    } catch (e) {
      return null;
    }
  }

  Future<Task?> markAsUndone(Task item) async {
    var url = "https://10.0.2.2:7010/v1/tasks/update/mark-as-undone";

    try {
      Response response = await Dio().put(
        url,
        data: item,
        options: Options(
          headers: {HttpHeaders.authorizationHeader: 'Bearer ${user.token}'},
        ),
      );
      return Task.fromJson(response.data["data"]);
    } catch (e) {
      return null;
    }
  }

  Future<Task?> delete(Task task) async {
    var url = "https://10.0.2.2:7010/v1/tasks/delete";

    try {
      Response response = await Dio().delete(
        url,
        data: task,
        options: Options(
            headers: {HttpHeaders.authorizationHeader: 'Bearer ${user.token}'}),
      );
      return Task.fromJson(response.data["data"]);
    } catch (e) {
      return null;
    }
  }
}
