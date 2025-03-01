import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:family_cash/features/Presentation/bloc/family/family_bloc.dart';
import 'package:family_cash/features/Presentation/widget/loading_state_widget.dart';
import 'package:family_cash/features/data/models/family_model.dart';
import 'package:family_cash/features/domain/entity/family_entity.dart';
import 'package:family_cash/locator_server.dart';

class FamilyPage extends StatefulWidget {
  const FamilyPage({super.key});

  @override
  _FamilyPageState createState() => _FamilyPageState();
}

class _FamilyPageState extends State<FamilyPage> {
  // List<FamilyModel> familyList = [];
  // int? defaultFamilyId;
  final familyBloc = sl<FamilyBloc>()..add(GetAllFamiliesEvent());

  @override
  // void initState() {
  //   super.initState();
  //   //_loadData();
  // }

  // Загрузка данных из SharedPreferences
  // Future<void> _loadData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   List<String> familyStrings = prefs.getStringList('familyList') ?? [];
  //   defaultFamilyId = prefs.getInt('defaultFamilyId');

  //   setState(() {
  //     familyList = familyStrings.map((e) => FamilyModel.fromString(e)).toList();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // FamilyModel? defaultFamily = familyList.firstWhere(
    //     (family) => family.id == defaultFamilyId,
    //     orElse: () => familyList.isNotEmpty ? familyList.first : null);

    return BlocProvider<FamilyBloc>(
      create: (context) => familyBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Семьи'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _addFamily, // Добавить семью
            ),
          ],
        ),
        body: BlocBuilder<FamilyBloc, FamilyState>(
          builder: (context, state) {
            if (state is FamilyLoadingState) {
              return loadingStateWidget();
            } else if (state is FamilyLoadedState) {
              return loadedStateFamily(state);
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  // Добавление новой семьи
  void _addFamily() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController controller = TextEditingController();
        return AlertDialog(
          title: const Text('Добавить новую семью'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Имя семьи'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                final newFamily = FamilyModel(id: -1, name: controller.text);
                familyBloc.add(AddNewFamilyEvent(newFamily: newFamily));
                Navigator.pop(context);
              },
              child: const Text('Добавить'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
          ],
        );
      },
    );
  }

  Widget loadedStateFamily(FamilyLoadedState state) {
    state.familyDefaultId == -1
        ? const Center(child: Text('Нет дефолтной семьи'))
        : Column(
            children: [
              ListTile(
                title: const Text('Дефолтная семья: '),
                trailing: PopupMenuButton<FamilyEntity>(
                  icon: const Icon(Icons.more_vert),
                  itemBuilder: (context) => state.families
                      .map((family) => PopupMenuItem(
                            value: family,
                            child: Text(family.name),
                          ))
                      .toList(),
                  onSelected: (family) => setDefaultFamily(
                      family.id), // Переключение на другую семью
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: state.families.length,
                  itemBuilder: (context, index) {
                    final family = state.families[index];
                    return ListTile(
                      title: Text(family.name),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () =>
                                editFamily(family), // Редактировать семью
                          ),
                          IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => {}
                              // _deleteFamily(family), // Удалить семью
                              ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
    return Container();
  }

  // Переключение на другую семью
  void setDefaultFamily(int familyId) {
    familyBloc.add(SetDefaultFamilyEvent(id: familyId));
  }

  // Редактирование существующей семьи
  void editFamily(FamilyEntity family) {
    TextEditingController controller = TextEditingController(text: family.name);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Редактировать семью'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Имя семьи'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  //family.name = controller.text;
                  //_saveData();
                });
                Navigator.pop(context);
              },
              child: const Text('Сохранить'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
          ],
        );
      },
    );
  }

  // Сохранение данных в SharedPreferences
  Future<void> _saveData() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setStringList(
    //     'familyList', familyList.map((e) => e.toStringFormat()).toList());
    // if (defaultFamilyId != null) {
    //   prefs.setInt('defaultFamilyId', defaultFamilyId!);
    // }
  }

  // Удаление семьи с подтверждением
  // void _deleteFamily(FamilyEntity family) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text('Удалить семью'),
  //         content: Text('Вы уверены, что хотите удалить семью ${family.name}?'),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               setState(() {
  //                 familyList.remove(family);
  //                 if (defaultFamilyId == family.id) {
  //                   defaultFamilyId = null;
  //                 }
  //                 _saveData();
  //               });
  //               Navigator.pop(context);
  //             },
  //             child: Text('Удалить'),
  //           ),
  //           TextButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: Text('Отмена'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
