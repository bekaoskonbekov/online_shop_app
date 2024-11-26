import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:my_example_file/home/store/bloc/product_bloc/product_bloc.dart';
import 'package:my_example_file/home/store/bloc/product_bloc/product_event.dart';
import 'package:my_example_file/home/store/bloc/product_bloc/product_state.dart';
import 'package:my_example_file/home/store/models/product/product_model.dart';
import 'package:shimmer/shimmer.dart';

class NewProductListView extends StatefulWidget {
  const NewProductListView({Key? key}) : super(key: key);

  @override
  _NewProductListViewState createState() => _NewProductListViewState();
}

class _NewProductListViewState extends State<NewProductListView> {
  @override
  void initState() {
    super.initState();
    _loadNewProducts();
  }

  void _loadNewProducts() {
    context.read<ProductBloc>().add(GetNewProducts());
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => _loadNewProducts(),
      child: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return _buildShimmerLoading();
          } else if (state is ProductsLoaded) {
            final sortedProducts = _sortProductsByCreatedAt(state.products);
            return sortedProducts.isEmpty
                ? _buildEmptyState()
                : _buildProductList(sortedProducts);
          } else if (state is ProductError) {
            return _buildErrorState(state.message);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  List<ProductModel> _sortProductsByCreatedAt(List<ProductModel> products) {
    return List<ProductModel>.from(products)
      ..sort((a, b) => b.params.createdAt!.compareTo(a.params.createdAt!));
  }

  Widget _buildShimmerLoading() {
    return SizedBox(
      height: 200,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (_, __) => Container(
            width: 140,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          itemCount: 5,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const SizedBox(
      height: 200,
      child: Center(
        child: Text(
          'Жаңы продукттар жок',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return SizedBox(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductList(List<ProductModel> products) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        itemBuilder: (context, index) {
          return NewProductCard(product: products[index]);
        },
      ),
    );
  }
}

class NewProductCard extends StatelessWidget {
  final ProductModel product;

  const NewProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                child: _buildProductImage(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.params.name!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${product.params.price} сом',
                    style: const TextStyle(color: Colors.green),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    return product.params.imageUrls!.isNotEmpty
        ? CachedNetworkImage(
            imageUrl: product.params.imageUrls!.first,
            fit: BoxFit.cover,
            placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          )
        : const Center(child: Icon(Icons.image_not_supported));
  }
}