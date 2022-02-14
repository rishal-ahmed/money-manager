import 'package:flutter/material.dart';
import 'package:money_manager/db/category/category_db.dart';
import 'package:money_manager/db/transactions/transaction_db.dart';
import 'package:money_manager/models/category/category_model.dart';
import 'package:money_manager/models/transactions/transaction_model.dart';

class ScreenAddTransaction extends StatefulWidget {
  static const routeName = 'add-transaction';
  const ScreenAddTransaction({Key? key}) : super(key: key);

  @override
  State<ScreenAddTransaction> createState() => _ScreenAddTransactionState();
}

class _ScreenAddTransactionState extends State<ScreenAddTransaction> {
  DateTime? _selecteDate;
  CategoryType? _selectedCategoryType;
  CategoryModel? _selectedCategoryModel;
  String? _categoryId;
  final _purposeTextEditingController = TextEditingController();
  final _amountTextEditingController = TextEditingController();

  @override
  void initState() {
    _selectedCategoryType = CategoryType.income;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 10),

            //Purpose
            TextFormField(
              controller: _purposeTextEditingController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text('Purpose'),
              ),
            ),

            const SizedBox(height: 10),

            //Amount
            TextFormField(
              controller: _amountTextEditingController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text('Amount'),
              ),
            ),

            const SizedBox(height: 10),

            //Calendar
            TextButton.icon(
              onPressed: () async {
                final _tempDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now().subtract(
                    const Duration(days: 30),
                  ),
                  lastDate: DateTime.now(),
                );
                if (_tempDate == null) {
                  return;
                } else {
                  print(_tempDate.toString());
                  setState(() {
                    _selecteDate = _tempDate;
                  });
                }
              },
              icon: const Icon(Icons.calendar_today),
              label: Text(
                _selecteDate == null ? 'Select Date' : _selecteDate.toString(),
              ),
            ),

            const SizedBox(height: 10),

            //CategoryType
            DropdownButton<String>(
              isExpanded: true,
              hint: const Text('Select Category'),
              value: _categoryId,
              items: (_selectedCategoryType == CategoryType.income
                      ? CategoryDB.instance.incomeCategoryListner
                      : CategoryDB.instance.expenseCategoryListener)
                  .value
                  .map(
                (e) {
                  return DropdownMenuItem(
                    child: Text(e.name),
                    value: e.id,
                    onTap: () {
                      _selectedCategoryModel = e;
                    },
                  );
                },
              ).toList(),
              onChanged: (selectedValue) {
                print('Selected CategoryId = $selectedValue');
                setState(
                  () {
                    _categoryId = selectedValue;
                  },
                );
              },
            ),

            const SizedBox(height: 10),

            //Category
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Radio(
                      value: CategoryType.income,
                      groupValue: _selectedCategoryType,
                      onChanged: (newValue) {
                        setState(
                          () {
                            _selectedCategoryType = CategoryType.income;
                            _categoryId = null;
                          },
                        );

                        print('newValue = $newValue');
                        print('_selectedCategoryType = $_selectedCategoryType');
                      },
                    ),
                    const Text('Income'),
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      value: CategoryType.expense,
                      groupValue: _selectedCategoryType,
                      onChanged: (newValue) {
                        setState(
                          () {
                            _selectedCategoryType = CategoryType.expense;
                            _categoryId = null;
                          },
                        );
                        print('newValue = $newValue');
                        print('_selectedCategoryType = $_selectedCategoryType');
                      },
                    ),
                    const Text('Expense'),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 10),

            //Sumbit
            ElevatedButton.icon(
              onPressed: () {
                addTransaction();
              },
              icon: const Icon(Icons.save),
              label: const Text('Submit'),
            )
          ],
        ),
      )),
    );
  }

  Future<void> addTransaction() async {
    final _purposeText = _purposeTextEditingController.text;
    final _amountText = _amountTextEditingController.text;

    if (_categoryId == null) {
      return;
    }
    if (_purposeText.isEmpty) {
      return;
    }
    if (_purposeText.isEmpty) {
      return;
    }
    if (_selecteDate == null) {
      return;
    }
    if (_selectedCategoryModel == null) {
      return;
    }

    final _amount = double.tryParse(_amountText);
    if (_amount == null) {
      return;
    }

    final _model = TransactionModel(
      purpose: _purposeText,
      amount: _amount,
      date: _selecteDate!,
      type: _selectedCategoryType!,
      categoryModel: _selectedCategoryModel!,
    );

    await TransactionDB.instance.addTransaction(_model);
    Navigator.of(context).pop();
    TransactionDB.instance.refreshUI();
  }
}
