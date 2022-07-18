class Task {
  late int id;
  late String title;
  late bool done;
  late DateTime dateInit;
  late DateTime dateEnd;
  late String desc;
  late String user;

  Task({required this.id, required this.title, required this.done,
    required this.dateInit, required this.dateEnd, required this.desc, required this.user});

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    done = json['done'];
    dateInit = DateTime.parse(json['dateInit']);
    dateEnd = DateTime.parse(json['dateEnd']);
    desc = json['desc'];
    user = json['userSlug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['title'] = title;
    data['done'] = done;
    data['dateInit'] = dateInit.toString().substring(0, 10);
    data['dateEnd'] = dateInit.toString().substring(0, 10);
    data['desc'] = desc;
    data['user'] = user;
    return data;
  }
}