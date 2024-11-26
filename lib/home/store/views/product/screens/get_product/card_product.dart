import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:my_example_file/home/store/models/product/product_model.dart';
import 'package:my_example_file/home/store/views/product/screens/get_product/detail_product_screen..dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onFavoritePressed;
  final double? width;
  final double? height;

  const ProductCard({
    Key? key,
    required this.product,
    this.onFavoritePressed,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = width ?? constraints.maxWidth;
        final cardHeight = height ?? (cardWidth * 1.5);
        final imageHeight = cardHeight * 0.6;

        return InkWell(
          onTap: () => _navigateToProductDetail(context),
          child: SizedBox(
            width: cardWidth,
            height: cardHeight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProductImageContainer(imageHeight),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: _buildProductInfo(context),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductImageContainer(double height) {
    return Container(
      height: 240,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: product.params.imageUrls!.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: product.params.imageUrls!.first,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  )
                : const Icon(Icons.image_not_supported, size: 50),
          ),
          if (product.params.promotion != 0)
            Positioned(
              top: 8,
              left: 8,
              child: _buildPromotionBadge(),
            ),
        ],
      ),
    );
  }

  Widget _buildProductInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(child: _buildProductName(context)),
        const SizedBox(height: 4),
        _buildPriceRow(context),
        const SizedBox(height: 4),
        _buildRatingAndFavorite(context),
      ],
    );
  }

  Widget _buildProductName(BuildContext context) {
    return Text(
      product.params.description!,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),
    );
  }

  Widget _buildPriceRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '${product.params.price!.toStringAsFixed(0)} ${product.params.transactionType}',
            overflow: TextOverflow.ellipsis,
            
          ),
        ),
      ],
    );
  }

  Widget _buildRatingAndFavorite(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            _buildIconWithCount(Icons.favorite, Colors.red, product.params.likes!.length),
            const SizedBox(width: 8),
            _buildIconWithCount(Icons.comment, Colors.amber, product.params.comments!.length),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.shopping_cart_checkout, color: Colors.blue),
          onPressed: () {}, // Add cart functionality here
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }

  Widget _buildIconWithCount(IconData icon, Color color, int count) {
    return Row(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(width: 4),
        Text(
          count.toString(),
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildPromotionBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '-${product.params.promotion!.toStringAsFixed(0)}%',
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }

  void _navigateToProductDetail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: product),
      ),
    );
  }
}