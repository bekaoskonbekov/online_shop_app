import 'package:flutter/material.dart';
import 'package:my_example_file/home/posts/models/location_model.dart';

class LocationBottomSheet extends StatelessWidget {
  final List<LocationModel> locations;
  final List<LocationModel> selectedLocations;
  final ValueChanged<LocationModel> onLocationSelected;

  const LocationBottomSheet({
    Key? key,
    required this.locations,
    required this.selectedLocations,
    required this.onLocationSelected,
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
                title: const Text('Локация тандоо'),
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
                  itemCount: locations.length,
                  itemBuilder: (context, index) {
                    final location = locations[index];
                    final isSelected = selectedLocations.contains(location);
                    return ListTile(
                      title: Text(
                        location.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check, color: Colors.green)
                          : null,
                      onTap: () {
                        onLocationSelected(location);
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