import 'package:flutter/material.dart';
import 'package:my_example_file/home/store/product/electronics/models/OS_model.dart';
class OperatingSystemPresenter {
  static Widget buildDetailsWidget(BuildContext context, OperatingSystemModel os) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Операциялык система',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        _buildDetailRow(context, 'Аты', os.name),
        _buildVersionsDetail(context, os.versions),
      ],
    );
  }
  static Widget _buildDetailRow(BuildContext context, String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$title:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value.toString()),
          ),
        ],
      ),
    );
  }
  static Widget _buildVersionsDetail(BuildContext context, List<OSVersion> versions) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Версиялар:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Column(
            children: versions.map((version) {
              return Text(
                '${version.number} (${version.releaseDateYear})',
                style: TextStyle(fontSize: 14),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}