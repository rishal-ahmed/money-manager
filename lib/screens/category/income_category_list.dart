import 'package:flutter/material.dart';
import 'package:money_manager/db/category/category_db.dart';
import 'package:money_manager/models/category/category_model.dart';

class IncomeCategoryList extends StatelessWidget {
  const IncomeCategoryList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: CategoryDB().incomeCategoryListner,
      builder: (BuildContext ctx, List<CategoryModel> newList, Widget? _) {
        return ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            final category = newList[index];
            return Card(
              child: ListTile(
                title: Text(category.name),
                trailing: IconButton(
                  onPressed: () {
                    CategoryDB.instance.deleteCategory(category.id);
                  },
                  icon: const Icon(Icons.delete),
                ),
              ),
            );
          },
          itemCount: newList.length,
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(
              height: 10,
            );
          },
        );
      },
    );
  }
}
