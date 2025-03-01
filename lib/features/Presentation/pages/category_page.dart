import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:family_cash/features/Presentation/bloc/category/category_bloc.dart';
import 'package:family_cash/features/data/datasources/local/icon_list.dart';
import 'package:family_cash/features/data/models/category_model.dart';
import 'package:family_cash/features/domain/entity/category_entity.dart';

class CategoryPage extends StatefulWidget {
  final CategoryEntity category;
  final CategoryBloc categoryBloc;
  final int famalyId;

  const CategoryPage(
      {super.key,
      required this.category,
      required this.categoryBloc,
      required this.famalyId});

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final TextEditingController _nameController = TextEditingController();
  IconData? _selectedIcon;
  Color _selectedColor = Colors.black;
  Prefix? _selectedPrefix;

  // Список для отслеживания состояния каждой кнопки (выбрана или нет)
  List<bool> isSelected = [false, false, false];

  @override
  void initState() {
    super.initState();
    if (widget.category.id > 0) {
      _selectedIcon = widget.category.icon;
      _selectedColor = widget.category.iconColor;
      _nameController.text = widget.category.name;
      _selectedPrefix = widget.category.prefix;
      for (int i = 0; i < isSelected.length; i++) {
        isSelected[i] = i == _selectedPrefix!.index;
      }
    }
  }

  // Метод для отображения диалога выбора цвета
  void _openColorPicker() async {
    final Color? pickedColor = await showDialog(
      context: context,
      builder: (BuildContext context) {
        Color tempColor = _selectedColor;
        return AlertDialog(
          title: const Text("Choose Color"),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: tempColor,
              onColorChanged: (color) => tempColor = color,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, tempColor),
              child: const Text("Select"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );

    if (pickedColor != null) {
      setState(() {
        _selectedColor = pickedColor;
      });
    }
  }

  // Метод для сохранения и возвращения на главный экран
  void _saveCategory() {
    if (_nameController.text.isNotEmpty &&
        _selectedIcon != null &&
        _selectedPrefix != null) {
      // Здесь можно добавить логику сохранения новой категории
      if (widget.category.id > 0) {
        widget.categoryBloc.add(UpdateCategoryEvent(
            categoryModel: CategoryModel(
                createdAt: widget.category.createdAt,
                id: widget.category.id,
                familyId: widget.category.familyId,
                name: _nameController.text,
                prefix: _selectedPrefix!,
                details: '',
                iconColor: _selectedColor,
                icon: _selectedIcon!)));
      } else {
        widget.categoryBloc.add(AddCategoryEvent(
            categoryModel: CategoryModel(
                createdAt: DateTime.now(),
                id: -1,
                familyId: widget.famalyId,
                name: _nameController.text,
                prefix: _selectedPrefix!,
                details: '',
                iconColor: _selectedColor,
                icon: _selectedIcon!)));
      }

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a name and select an icon")),
      );
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Удалить категорию'),
          content: const Text('Вы уверены, что хотите удалить эту категорию?'),
          actions: [
            TextButton(
              child: const Text('Отмена'),
              onPressed: () {
                Navigator.of(context).pop(); // Закрыть диалог
              },
            ),
            TextButton(
              child: const Text('Удалить'),
              onPressed: () {
                Navigator.of(context).pop(); // Закрыть диалог
                widget.categoryBloc.add(DeleteCategoriesEvent(
                    id: widget.category.id)); // Удаление категории
                Navigator.of(context).pop(true); // Возврат на предыдущий экран
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final iconList = iconMapping.entries
        .toList(); // Преобразуем Map в список пар ключ-значение
    return Scaffold(
      appBar: AppBar(
        title: widget.category.id > 0
            ? const Text("Update Category")
            : const Text("Add New Category"),
        actions: [
          if (widget.category.id > 0)
            IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () => _showDeleteConfirmationDialog(context),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ToggleButtons(
              isSelected: isSelected,
              onPressed: (int index) {
                setState(() {
                  // Обновляем состояние кнопок, чтобы только одна могла быть выбрана
                  for (int i = 0; i < isSelected.length; i++) {
                    isSelected[i] = i == index;
                  }
                  // Устанавливаем выбранный Prefix на основе индекса
                  _selectedPrefix = Prefix.values[index];
                });
              },
              borderRadius: BorderRadius.circular(8.0),
              selectedColor: Colors.white,
              fillColor: Colors.blue,
              color: Colors.black,
              constraints: const BoxConstraints(
                minHeight: 40.0,
                minWidth: 100.0,
              ),
              children: Prefix.values.map((prefix) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    prefixToString(prefix),
                    style: const TextStyle(fontSize: 16),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Category Name"),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 20),

            // Секция для выбора иконки
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: iconList.length,
                itemBuilder: (context, index) {
                  final icon = iconList[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIcon = icon.value;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: _selectedIcon == icon.value
                            ? _selectedColor.withOpacity(0.2)
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _selectedIcon == icon.value
                              ? _selectedColor
                              : const Color.fromARGB(0, 187, 26, 26),
                          width: 2,
                        ),
                      ),
                      child: Icon(icon.value,
                          color: _selectedIcon == icon.value
                              ? _selectedColor
                              : const Color.fromARGB(255, 0, 0, 0),
                          size: 32),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Кнопка для выбора цвета
            GestureDetector(
              onTap: _openColorPicker,
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: _selectedColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const Center(
                  child: Text(
                    "Choose Color",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Кнопка сохранения
            Center(
              child: ElevatedButton(
                onPressed: _saveCategory,
                child: widget.category.id > 0
                    ? const Text("Update")
                    : const Text("Save"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
