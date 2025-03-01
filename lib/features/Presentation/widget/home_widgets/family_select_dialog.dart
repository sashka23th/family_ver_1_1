part of '../../pages/home_page.dart';

void _showFamilySelectionDialog(
    BuildContext context, FamilyState state, FamilyBloc familyBloc) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      if (state is FamilyLoadedState) {
        return AlertDialog(
          title: const Text('Select Family'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: state.families.map((family) {
                final isDefault = family.id == state.familyDefaultId;
                return ListTile(
                  title: Text(family.name),
                  tileColor: isDefault ? Colors.green.shade100 : null,
                  onTap: () {
                    familyBloc.add(SetDefaultFamilyEvent(id: family.id));
                    Navigator.of(context).pop();
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    alignment: Alignment.centerRight,
                    onPressed: () {
                      familyBloc.add(DeleteFamilyEvent(id: family.id));
                      Navigator.of(context).pop();
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showAddFamilyDialog(context, familyBloc);
              },
              child: const Text('Add'),
            ),
          ],
        );
      } else {
        return Container();
      }
    },
  );
}
