part of '../../pages/home_page.dart';

Widget _buildCategoriesGrid(
    BuildContext context,
    List<CategoryEntity> categories,
    String currentAmount,
    int familyDefault,
    Function(int) onSavePayment,
    CategoryBloc categoryBloc) {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.only(left: 6, right: 6),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: categories.length + 1,
        itemBuilder: (context, index) {
          if (index < categories.length) {
            final category = categories[index];
            return GestureDetector(
              onLongPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryPage(
                      category: categories[index],
                      categoryBloc: categoryBloc,
                      famalyId: familyDefault,
                    ),
                  ),
                );
              },
              onTap: () {
                if (double.tryParse(currentAmount) != 0) {
                  onSavePayment(index);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Посжалуйста набирите сумму")),
                  );
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: category.iconColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(category.icon, color: category.iconColor, size: 32),
                    const SizedBox(height: 8),
                    AutoSizeText(category.name,
                        maxLines: 1,
                        minFontSize: 12,
                        maxFontSize: 12,
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            );
          } else {
            return GestureDetector(
              onTap: () => _addCategory(context, familyDefault, categoryBloc),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.add, color: Colors.black, size: 32),
              ),
            );
          }
        },
      ),
    ),
  );
}

void _addCategory(
    BuildContext context, int familyDefault, CategoryBloc categoryBloc) {
  // Переход на страницу CategoryPage
  Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => CategoryPage(
              category: CategoryEntity(
                  iconColor: Colors.black,
                  createdAt: DateTime.now(),
                  id: -1,
                  familyId: familyDefault,
                  name: "",
                  prefix: Prefix.exp,
                  details: '',
                  icon: Icons.help_outline),
              categoryBloc: categoryBloc,
              famalyId: familyDefault,
            )),
  );
}
