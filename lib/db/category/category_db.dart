import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_manager/models/category/category_model.dart';

const CATEGORY_DB_NAME = 'category_db';

abstract class CategoryDbFunctions {
  Future<List<CategoryModel>> getCategories();
  Future<void> inserCategory(CategoryModel value);
  Future<void> deleteCategory(String categoryId);
}

class CategoryDB implements CategoryDbFunctions {
  CategoryDB._internal();
  static CategoryDB instance = CategoryDB._internal();
  factory CategoryDB() {
    return instance;
  }

  ValueNotifier<List<CategoryModel>> incomeCategoryListner = ValueNotifier([]);
  ValueNotifier<List<CategoryModel>> expenseCategoryListener =
      ValueNotifier([]);

  @override
  Future<void> inserCategory(CategoryModel value) async {
    final _categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    await _categoryDB.put(value.id, value);
    refreshUI();
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final _categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    return _categoryDB.values.toList();
  }

  Future<void> refreshUI() async {
    final _allCategories = await getCategories();
    incomeCategoryListner.value.clear();
    expenseCategoryListener.value.clear();
    await Future.forEach(
      _allCategories,
      (CategoryModel category) {
        if (category.type == CategoryType.income) {
          incomeCategoryListner.value.add(category);
        } else {
          expenseCategoryListener.value.add(category);
        }
      },
    );

    incomeCategoryListner.notifyListeners();
    expenseCategoryListener.notifyListeners();
  }

  @override
  Future<void> deleteCategory(String categoryId) async {
    final _categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    await _categoryDB.delete(categoryId);
    refreshUI();
  }
}
