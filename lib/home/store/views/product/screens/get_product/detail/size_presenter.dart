import 'package:flutter/material.dart';
import 'package:my_example_file/home/store/product/clothing/models/size_model.dart';
class SizePresenter {
  static Widget buildDetailsWidget(BuildContext context, SizeModel size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Өлчөм маалыматтары',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        _buildDetailRow(context, 'Өлчөм', size.name),
        if (size.measurements != null) ...[
          _buildDetailRow(context, 'Көкүрөк', size.measurements!['chest']?.toString() ?? 'Жок'),
          _buildDetailRow(context, 'Бел', size.measurements!['waist']?.toString() ?? 'Жок'),
          _buildDetailRow(context, 'Жамбаш', size.measurements!['hips']?.toString() ?? 'Жок'),
        ],
      ],
    );
  }
  static Widget _buildDetailRow(BuildContext context, String title, String value) {
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
            child: Text(value),
          ),
        ],
      ),
    );
  }
  static Widget buildSizesList(BuildContext context, List<SizeModel> sizes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...sizes.map((size) => buildDetailsWidget(context, size)),
      ],
    );
  }
}