import 'package:flutter/material.dart';
import 'package:expense_tracker/Models/expense.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onSavedExpense});
  final void Function(Expense expense) onSavedExpense;
  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _textController = TextEditingController();
  final _amountController = TextEditingController();
  late String enteredtitle = _textController.text;

  DateTime? selectDate;
  Category selectedCategory = Category.leisure;
  @override
  void dispose() {
    // Dispose of the controller to free up resources
    _textController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  _selectedDate() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: now);
    setState(() {
      selectDate = pickedDate;
    });
  }

  void savedExenses() {
    final selectedamount = double.tryParse(_amountController.text);
    final isValidAmount = selectedamount == null || selectedamount <= 0;
    if (enteredtitle.trim().isEmpty || isValidAmount || selectDate == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid Input'),
          content: const Text(
              'Please make sure all fields are filled out correctly.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop(); // Close the dialog
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );

      return;
    }
    widget.onSavedExpense(Expense(
        tittle: enteredtitle,
        amount: selectedamount,
        date: selectDate!,
        category: selectedCategory));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
      child: Column(
        children: [
          TextField(
            controller: _textController,
            maxLength: 50,
            decoration: const InputDecoration(
              labelText: 'Title', // Fixed the label text typo
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    prefixText: '\$ ',
                    labelText: 'Amount', // Fixed the label text typo
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      selectDate == null
                          ? 'No Date Selected'
                          : formatDate.format(selectDate!),
                      //overflow: TextOverflow.ellipsis,
                    ),
                    IconButton(
                      icon: const Icon(Icons.calendar_view_month),
                      onPressed: _selectedDate,
                    ),
                  ],
                ),
              )
            ],
          ),

          // const SizedBox(
          //   height: 2,
          // ),
          Row(
            children: [
              DropdownButton<Category>(
                value: selectedCategory,
                //hint: const Text('Select Category'),
                items: Category.values.map((Category category) {
                  return DropdownMenuItem<Category>(
                    value: category,
                    child:
                        Text(category.name.toUpperCase()), // Display enum name
                  );
                }).toList(),
                onChanged: (Category? newValue) {
                  setState(() {
                    selectedCategory = newValue!;
                  });
                },
              ),
              const Spacer(),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              ElevatedButton(
                onPressed: savedExenses,
                child: const Text('Save Expense'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
