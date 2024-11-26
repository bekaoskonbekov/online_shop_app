import 'package:flutter/material.dart';
import 'package:my_example_file/home/store/models/product/product_model.dart';
import 'package:my_example_file/home/store/models/color_model.dart';
import 'package:my_example_file/home/store/product/clothing/models/size_model.dart';
import 'package:my_example_file/home/store/product/electronics/models/OS_model.dart';
import 'package:my_example_file/home/store/views/product/screens/get_product/detail/operating_system_presenter.dart';
import 'package:my_example_file/home/store/views/product/screens/get_product/detail/size_presenter.dart';
class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailScreen({Key? key, required this.product}) : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _currentImageIndex = 0;
  bool _isDescriptionExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.params.name!),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageCarousel(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProductHeader(context),
                  SizedBox(height: 16),
                  _buildDescription(context),
                  SizedBox(height: 16),
                  _buildDetailsCard(context),
                  SizedBox(height: 16),
                  _buildSpecificationsCard(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCarousel() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: 250,
          child: PageView.builder(
            itemCount: widget.product.params.imageUrls!.length,
            onPageChanged: (index) {
              setState(() {
                _currentImageIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Image.network(
                widget.product.params.imageUrls![index],
                fit: BoxFit.cover,
              );
            },
          ),
        ),
        Positioned(
          bottom: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.product.params.imageUrls!.asMap().entries.map((entry) {
              return Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentImageIndex == entry.key
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildProductHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.product.params.name!,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${widget.product.params.price} сом',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.green),
            ),
            if (widget.product.params.promotion! > 0)
              Chip(
                label: Text('${widget.product.params.promotion}% жеңилдик'),
                backgroundColor: Colors.red,
                labelStyle: TextStyle(color: Colors.white),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedCrossFade(
          firstChild: Text(
            widget.product.params.description!,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          secondChild: Text(
            widget.product.params.description!,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          crossFadeState: _isDescriptionExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: Duration(milliseconds: 300),
        ),
        TextButton(
          child: Text(_isDescriptionExpanded ? 'Азыраак көрүү' : 'Көбүрөөк көрүү'),
          onPressed: () {
            setState(() {
              _isDescriptionExpanded = !_isDescriptionExpanded;
            });
          },
        ),
      ],
    );
  }

  Widget _buildDetailsCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Негизги маалыматтар', style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 8),
            _buildDetailRow('Бренд', widget.product.params.brand!.name),
            _buildDetailRow('Өндүрүүчү өлкө', widget.product.params.countryOfOrigin!.name),
            _buildDetailRow('Кайтаруу шарттары', widget.product.params.returnPolicy!),
            _buildDetailRow('Салмагы', widget.product.params.weight!),
            _buildColorOptions(context),
            _buildDetailRow('Саны', widget.product.params.stockQuantity.toString()),
            _buildDetailRow('Транзакция түрү', widget.product.params.transactionType!),
            _buildDetailRow('Категория', widget.product.params.category!.name),
          ],
        ),
      ),
    );
  }

  Widget _buildColorOptions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              'Түстөр:',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700]),
            ),
          ),
          Expanded(
            flex: 3,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.product.params.colorOptions!.map((color) {
                return GestureDetector(
                  onTap: () => _showColorDialog(context, color),
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Color(color.colorValue),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _showColorDialog(BuildContext context, ColorModel color) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(color.name),
          content: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Color(color.colorValue),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey),
            ),
          ),
          actions: [
            TextButton(
              child: Text('Жабуу'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

 Widget _buildSpecificationsCard(BuildContext context) {
  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Өзгөчөлүктөрү', style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: 16),
          // _buildSpecifications(widget.product.fields.specifications),
        ],
      ),
    ),
  );
}

Widget _buildSpecifications(Map<String, dynamic> specifications) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: specifications.entries.map((entry) {
      if (entry.key == 'operatingSystem') {
        final os = OperatingSystemModel.fromMap(entry.value,'');
        return OperatingSystemPresenter.buildDetailsWidget(context, os);
      } else if (entry.key == 'sizes') {
        final sizes = (entry.value as List).map((sizeMap) => SizeModel.fromMap(sizeMap)).toList();
        return SizePresenter.buildSizesList(context, sizes);
      } else if (entry.value is Map<String, dynamic>) {
        return _buildNestedMapDetails(entry.key, entry.value);
      } else {
        return _buildDetailRow(entry.key, entry.value.toString());
      }
    }).toList(),
  );
}

Widget _buildNestedMapDetails(String title, Map<String, dynamic> details) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      ...details.entries.map((entry) {
        if (entry.value is Map<String, dynamic>) {
          return _buildNestedMapDetails(entry.key, entry.value);
        } else {
          return _buildDetailRow(entry.key, entry.value.toString());
        }
      }).toList(),
    ],
  );
}

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$title:',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700]),
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
}