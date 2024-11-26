import 'package:flutter/material.dart';
import 'package:my_example_file/home/posts/views/create_post/widgets/location_bottom_sheet.dart';
import 'package:my_example_file/home/posts/models/location_model.dart';

class LocationSelector extends StatelessWidget {
  final List<LocationModel> selectedLocations;
  final ValueChanged<LocationModel> onLocationSelected;
  final List<LocationModel> locations; // Жаңы кошулган параметр

  const LocationSelector({
    Key? key,
    required this.selectedLocations,
    required this.onLocationSelected,
    required this.locations, // Жаңы кошулган параметр
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 26, 26, 27),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        title: Text(
          selectedLocations.isEmpty
              ? 'Локация тандоо'
              : selectedLocations.map((c) => c.name).join(', '),
          style: const TextStyle(color: Colors.white),
        ),
        trailing: const Icon(Icons.arrow_drop_down, color: Colors.white),
        onTap: () => _showCategoryBottomSheet(context),
      ),
    );
  }

  void _showCategoryBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return LocationBottomSheet(
          locations: locations, selectedLocations: selectedLocations, onLocationSelected: onLocationSelected, // Жаңы кошулган параметр колдонулду
        );
      },
    );
  }
}