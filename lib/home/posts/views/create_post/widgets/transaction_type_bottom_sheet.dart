import 'package:flutter/material.dart';

class TransactionTypeBottomSheet extends StatelessWidget {
  final List<String> transactionTypeOptions;
  final ValueChanged<String> onTransactionTypeSelected;

  const TransactionTypeBottomSheet({
    Key? key,
    required this.transactionTypeOptions,
    required this.onTransactionTypeSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.2,
      maxChildSize: 0.95,
      builder: (_, controller) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              AppBar(
                title: const Text('Транзакция түрүн тандоо'),
                backgroundColor: Colors.transparent,
                elevation: 0,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  controller: controller,
                  itemCount: transactionTypeOptions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        transactionTypeOptions[index],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        onTransactionTypeSelected(transactionTypeOptions[index]);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}