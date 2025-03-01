part of '../../pages/home_page.dart';

void _showAddFamilyDialog(BuildContext context, FamilyBloc familyBloc) {
  final familyNameController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Add New Family'),
        content: TextField(
          controller: familyNameController,
          decoration: const InputDecoration(labelText: 'Family Name'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              familyBloc.add(AddNewFamilyEvent(
                  newFamily:
                      FamilyEntity(id: -1, name: familyNameController.text)));
              Navigator.of(context).pop();
            },
            child: const Text('Add Family'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      );
    },
  );
}
