import 'package:flutter/material.dart';
import 'package:my_example_file/home/posts/models/location_model.dart';

class SubLocationBottomSheet extends StatelessWidget {
  final String locationName;
  final List<SubLocationModel> subLocations;
  final List<SubLocationModel> selectedSubLocations;
  final ValueChanged<SubLocationModel> onSubLocationSelected;

  const SubLocationBottomSheet({
    Key? key,
    required this.locationName,
    required this.subLocations,
    required this.selectedSubLocations,
    required this.onSubLocationSelected,
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
                title: Text('Регион тандоо: $locationName'),
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
                  itemCount: subLocations.length,
                  itemBuilder: (context, index) {
                    final subLocation = subLocations[index];
                    final isSelected = selectedSubLocations.contains(subLocation);
                    return ListTile(
                      title: Text(
                        subLocation.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check, color: Colors.green)
                          : null,
                      onTap: () {
                        onSubLocationSelected(subLocation);
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