import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_example_file/home/store/bloc/product_bloc/product_bloc.dart';
import 'package:my_example_file/home/store/bloc/product_bloc/product_event.dart';
import 'package:my_example_file/home/store/bloc/product_bloc/product_state.dart';
import 'package:my_example_file/home/store/models/product_category.dart';
import 'package:my_example_file/home/store/models/product/product_model.dart';
import 'package:my_example_file/home/store/views/product/screens/get_product/card_product.dart';
import 'package:shimmer/shimmer.dart';

class ProductListView extends StatefulWidget {
  final ProductCategoryModel? selectedCategory;

  const ProductListView({
    Key? key,
    required this.selectedCategory,
  }) : super(key: key);

  @override
  _ProductListViewState createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  final ScrollController _scrollController = ScrollController();
  static const int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<ProductBloc>().add(LoadMoreProducts());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading && state.isFirstFetch) {
          return SliverToBoxAdapter(child: _buildShimmerLoading());
        } else if (state is ProductsLoaded) {
          return state.products.isEmpty
              ? SliverToBoxAdapter(child: _buildEmptyState())
              : _buildProductGrid(state.products, state.hasReachedMax);
        } else if (state is ProductError) {
          return SliverToBoxAdapter(child: Center(child: Text(state.message)));
        }
        return SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }

  Widget _buildProductGrid(List<ProductModel> products, bool hasReachedMax) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.54,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index >= products.length) {
            if (!hasReachedMax) {
              return const Center(child: CircularProgressIndicator());
            }
            return null;
          }
          return ProductCard(product: products[index]);
        },
        childCount: hasReachedMax ? products.length : products.length + 1,
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.6,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (_, __) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        itemCount: _pageSize,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Продукттар табылган жок',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Бул категорияда азырынча продукттар жок',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}