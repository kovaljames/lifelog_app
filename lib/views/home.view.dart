import 'package:flutter/material.dart';
import 'package:lifelog_app/views/auth/account.view.dart';
import 'package:lifelog_app/views/search.view.dart';
import 'package:lifelog_app/views/task/tasks.view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;
  static Widget projectsWidget = const Center(child: Text('Projetos'));
  static Widget inboxWidget = const Center(child: Text('Caixa de entrada'));
  // static Widget searchWidget = const Center(child: Text('Buscar'));
  final List<Widget> _views = [
    projectsWidget,
    const TasksView(),
    inboxWidget,
    const SearchView(),
    const Account()
  ];
  final List<String> _appbarTitles = [
    "Projetos",
    "Minhas tarefas",
    "Caixa de entrada",
    "Buscar",
    "Conta"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
          _appbarTitles[_currentIndex],
        ),
        automaticallyImplyLeading: false,
      ),
      body: _views[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        fixedColor: Colors.deepPurple,
        unselectedItemColor: Colors.black38,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Página Inicial",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check),
            label: "Minhas tarefas",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "Caixa de entrada",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Buscar",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: "Conta",
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
