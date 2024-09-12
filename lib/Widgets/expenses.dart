import 'package:expense_tracker/Widgets/newexpense.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/Models/expense.dart';
import 'package:expense_tracker/Widgets/expenseList.dart';
import 'package:expense_tracker/Widgets/chart/chart.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});
  @override
  State<Expenses> createState() {
    return _ExpenseState();
  }
}

class _ExpenseState extends State<Expenses> {
  void newexpenseAdded() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return NewExpense(onSavedExpense: addExpense);
        });
  }

  final List<Expense> registerList = [
    Expense(
        tittle: 'Flutter course',
        amount: 19.99,
        date: DateTime.now(),
        category: Category.work),
  ];

  void addExpense(Expense newExpense) {
    setState(() {
      registerList.add(newExpense);
    });
  }

  void removeExpense(Expense expense) {
    final int expenseIndex = registerList.indexOf(expense);
    setState(() {
      registerList.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text(' Expense is removed'),
        action: SnackBarAction(
            label: 'undo',
            onPressed: () {
              setState(() {
                registerList.insert(expenseIndex, expense); // Undo the removal
              });
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget mainWidget =
        const Center(child: Text('No expense added try add some expense'));
    if (registerList.isNotEmpty) {
      mainWidget = expenseList(
        userExpense: registerList,
        onremoveExpense: removeExpense,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker App'),
        actions: [
          IconButton(onPressed: newexpenseAdded, icon: const Icon(Icons.add))
        ],
      ),
      body: Column(
        children: [
          Chart(expenses: registerList),
          Expanded(child: mainWidget),
        ],
      ),
    );
  }
}
