import 'package:flutter/material.dart';
import 'package:money_manager/db/category/category_db.dart';
import 'package:money_manager/models/category/category_model.dart';

ValueNotifier<CategoryType> selectedCategoryNotifier =
    ValueNotifier(CategoryType.income);

Future<void> showCategoryAddPopup(BuildContext context) async {
  final _nameEditingController = TextEditingController();
  showDialog(
    context: context,
    builder: (ctx) {
      return SimpleDialog(
        title: const Text('Add Category'),
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              controller: _nameEditingController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text('Categroy Name'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: const [
                RadioButton(title: 'Income', type: CategoryType.income),
                RadioButton(title: 'Expense', type: CategoryType.expense)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
              onPressed: () {
                final _name = _nameEditingController.text;
                if (_name.isEmpty) {
                  return;
                }
                final _type = selectedCategoryNotifier.value;
                final _category = CategoryModel(
                  name: _name,
                  type: _type,
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                );
                CategoryDB().inserCategory(_category);
                Navigator.of(ctx).pop();
              },
              child: const Text('Add'),
            ),
          )
        ],
      );
    },
  );
}

class RadioButton extends StatelessWidget {
  final String title;
  final CategoryType type;
  const RadioButton({Key? key, required this.title, required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ValueListenableBuilder(
          builder:
              (BuildContext context, CategoryType newCategory, Widget? child) {
            return Radio<CategoryType>(
              value: type,
              groupValue: newCategory,
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                print('Value == $value');
                selectedCategoryNotifier.value = value;
                selectedCategoryNotifier.notifyListeners();
              },
            );
          },
          valueListenable: selectedCategoryNotifier,
        ),
        Text(title)
      ],
    );
  }
}
