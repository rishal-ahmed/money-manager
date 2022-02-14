import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/db/category/category_db.dart';
import 'package:money_manager/db/transactions/transaction_db.dart';
import 'package:money_manager/models/transactions/transaction_model.dart';

class ScreenTransaction extends StatelessWidget {
  const ScreenTransaction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TransactionDB.instance.refreshUI();
    CategoryDB.instance.refreshUI();
    return ValueListenableBuilder(
      valueListenable: TransactionDB.instance.transactionListNotifier,
      builder: (BuildContext ctx, List<TransactionModel> newList, Widget? _) {
        return ListView.separated(
            padding: const EdgeInsets.all(10),
            itemBuilder: (ctx, index) {
              //value
              final _value = newList[index];
              print('amount == ${_value.amount}');
              print('id == ${_value.id}');

              return Slidable(
                endActionPane:
                    ActionPane(motion: const ScrollMotion(), children: [
                  SlidableAction(
                    onPressed: (ctx) {
                      showSncakBar(context);
                      TransactionDB.instance.deleteTransaction(_value.id!);
                    },
                    backgroundColor: Colors.red[700]!,
                    label: 'Delete',
                    icon: Icons.delete,
                  )
                ]),
                child: Card(
                  key: Key(_value.id!),
                  child: ListTile(
                    leading: Text(
                      parseDate(_value.date),
                    ),
                    title: Text('RS ${_value.amount}'),
                    subtitle: Text(_value.categoryModel.name),
                    // trailing: IconButton(
                    //   onPressed: () {},
                    //   icon: const Icon(Icons.delete),
                    // ),
                  ),
                ),
              );
            },
            separatorBuilder: (ctx, index) {
              return const SizedBox(
                height: 5,
              );
            },
            itemCount: newList.length);
      },
    );
  }

  String parseDate(DateTime dateTime) {
    final _date = DateFormat.MMMd().format(dateTime);
    final _splitDate = _date.split(' ');
    return '${_splitDate.last}\n${_splitDate.first}';
    //return '${dateTime.day}\n${dateTime.month}';
  }

  void showSncakBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Transaction has been Deleted!'),
        duration: Duration(seconds: 5),
        backgroundColor: Colors.black,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(10),
      ),
    );
  }
}
