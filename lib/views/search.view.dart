import 'package:flutter/material.dart';
import 'package:lifelog_app/controllers/task.controller.dart';
import 'package:lifelog_app/stores/app.store.dart';
import 'package:provider/provider.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  State<SearchView> createState() => _SearchState();
}

class _SearchState extends State<SearchView> {
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('Pesquisar tarefas/usuários');

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<AppStore>(context);
    final controller = TaskController(store);

    return Scaffold(
      appBar: AppBar(
        title: customSearchBar,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                if (customIcon.icon == Icons.search) {
                  customIcon = const Icon(Icons.cancel);
                  customSearchBar = ListTile(
                    leading: const Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 28,
                    ),
                    title: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Buscar no workspace...',
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                        ),
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      onSubmitted: (value) {
                        controller
                            .getAllByTitle(value)
                            .then((value) => {setState(() {})})
                            .catchError((err) => {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(err.message)))
                                });
                      },
                    ),
                  );
                } else {
                  customIcon = const Icon(Icons.search);
                  customSearchBar = const Text('Pesquisar tarefas/usuários');
                }
              });
            },
            icon: customIcon,
          )
        ],
        centerTitle: true,
      ),
    );
  }
}
