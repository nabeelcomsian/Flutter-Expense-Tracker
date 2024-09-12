import 'package:flutter/material.dart';
import 'package:expense_tracker/Models/expense.dart';
import 'package:expense_tracker/Widgets/expenseItem.dart';

class expenseList extends StatelessWidget {
  const expenseList(
      {super.key, required this.userExpense, required this.onremoveExpense});
  final List<Expense> userExpense;
  final void Function(Expense expense) onremoveExpense;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: userExpense.length,
        itemBuilder: (context, index) {
          return Dismissible(
              key: ValueKey(userExpense[index]),
              background: Container(
                color: Theme.of(context).colorScheme.error.withOpacity(0.75),
                margin: EdgeInsets.symmetric(
                  horizontal: Theme.of(context).cardTheme.margin!.horizontal,
                ),
              ),
              onDismissed: (direction) {
                onremoveExpense(userExpense[index]);
              },
              child: ExpenseItem(expences: userExpense[index]));
        });
  }
}
