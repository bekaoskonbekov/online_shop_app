import 'package:flutter/material.dart';
import 'package:my_example_file/home/posts/views/create_post/widgets/sub_locations_bottom_sheet.dart';
import 'package:my_example_file/home/posts/models/location_model.dart';

class SubLocationSelector extends StatelessWidget {
  final List<SubLocationModel> selectedSubLocations;
  final ValueChanged<SubLocationModel> onSubLocationSelected;
  final List<LocationModel> selectedLocations;

  const SubLocationSelector({
    Key? key,
    required this.selectedSubLocations,
    required this.onSubLocationSelected,
    required this.selectedLocations,
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
          selectedSubLocations.isEmpty
              ? 'Регион тандоо'
              : selectedSubLocations.map((s) => s.name).join(', '),
          style: const TextStyle(color: Colors.white),
        ),
        trailing: const Icon(Icons.arrow_drop_down, color: Colors.white),
        onTap: () {
          if (selectedLocations.isNotEmpty) {
            _showSubLocationBottomSheet(context, selectedLocations.first);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Алгач категория тандаңыз')),
            );
          }
        },
      ),
    );
  }

  void _showSubLocationBottomSheet(
    BuildContext context,
    LocationModel location,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return SubLocationBottomSheet(
          locationName: location.name,
          subLocations: location.subLocations,
          selectedSubLocations: selectedSubLocations,
          onSubLocationSelected: onSubLocationSelected,
        );
      },
    );
  }
}