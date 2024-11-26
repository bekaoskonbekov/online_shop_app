import 'package:flutter/material.dart';

class CurrencyBottomSheet extends StatelessWidget {
  final List<String> currencyOptions;
  final ValueChanged<String> onCurrencySelected;

  const CurrencyBottomSheet({
    Key? key,
    required this.currencyOptions,
    required this.onCurrencySelected,
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
                title: const Text('Валютаны тандоо'),
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
                  itemCount: currencyOptions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        currencyOptions[index],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        onCurrencySelected(currencyOptions[index]);
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