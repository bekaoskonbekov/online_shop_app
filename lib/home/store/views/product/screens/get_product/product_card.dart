import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_example_file/home/store/bloc/product_bloc/product_bloc.dart';
import 'package:my_example_file/home/store/bloc/product_bloc/product_event.dart';
import 'package:my_example_file/home/store/bloc/product_bloc/product_state.dart';
import 'package:my_example_file/home/store/bloc/product_category/product_category_bloc.dart';
import 'package:my_example_file/home/store/bloc/product_category/product_category_event.dart';
import 'package:my_example_file/home/store/bloc/product_category/product_category_state.dart';
import 'package:my_example_file/home/store/models/product_category.dart';
import 'package:my_example_file/home/store/views/product/screens/get_product/category_path.dart';
import 'package:my_example_file/home/store/views/product/screens/get_product/filter/chep_product_listview.dart';
import 'package:my_example_file/home/store/views/product/screens/get_product/filter/new_product_litview.dart';
import 'package:my_example_file/home/store/views/product/screens/get_product/list_view_category_product.dart';
import 'package:my_example_file/home/store/views/product/screens/get_product/list_view_product.dart';

class ProductListScreen extends StatefulWidget {
  final ProductCategoryModel? category;
  final List<String> categoryPath;

  const ProductListScreen({
    Key? key,
    this.category,
    this.categoryPath = const [],
  }) : super(key: key);

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ScrollController _scrollController = ScrollController();
  String _sortBy = 'popular';
  ProductCategoryModel? _selectedCategory;
  bool _showNewProducts = false;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.category;
    _loadInitialData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    _loadCategories();
    _loadProducts();
    _loadNewProducts();
    
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _showNewProducts = true;
        });
      }
    });
  }

  void _loadCategories() {
    context.read<CategoryBloc>().add(GetCategories(parentCategoryId: _selectedCategory?.id ?? ''));
    
  }

  void _loadProducts() {
    if (_selectedCategory != null) {
      context.read<ProductBloc>().add(GetProductsByCategory(_selectedCategory!.id, sortBy: _sortBy));
    } else {
      context.read<ProductBloc>().add(GetAllProducts(sortBy: _sortBy));
    }
  }

  void _loadNewProducts() {
    context.read<ProductBloc>().add(GetNewProducts());
  }

  void _onScroll() {
    if (_isScrolledToBottom) {
      context.read<ProductBloc>().add(LoadMoreProducts());
    }
  }

  bool get _isScrolledToBottom {
    return _scrollController.offset >= _scrollController.position.maxScrollExtent - 200 &&
        !_scrollController.position.outOfRange;
  }

  void _onCategorySelected(ProductCategoryModel category) {
    setState(() {
      _selectedCategory = category;
      _showNewProducts = false;
    });
    _loadProducts();
    _loadCategories();
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: _loadInitialData,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            if (widget.categoryPath.isNotEmpty)
              SliverToBoxAdapter(child: CategoryPathWidget(path: widget.categoryPath)),
            _buildCategoriesSection(),
            if (_showNewProducts) ...[
              SliverToBoxAdapter(
                child: _buildSectionTitle('Жаңы жүктөлгөн товарлар'),
              ),
              const SliverToBoxAdapter(
                child: NewProductListView(),
              ),
            ],
            SliverToBoxAdapter(
              child: _buildSectionTitle('Эң арзан товарлар'),
            ),
            const SliverToBoxAdapter(
              child: CheapProductListView(),
            ),
            SliverToBoxAdapter(
              child: _buildSectionTitle('Бардык товарлар'),
            ),
            _buildProductListView(),
          ],
        ),
      ),
    );
  }


  Widget _buildCategoriesSection() {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoading) {
          return const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()));
        } else if (state is CategoriesLoaded) {
          return SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Категориялар'),
                SizedBox(
                  height: 120,
                  child: CategoryListView(
                    categoryPath: widget.categoryPath,
                    onCategorySelected: _onCategorySelected,
                  ),
                ),
              ],
            ),
          );
        } else if (state is CategoryError) {
          return SliverToBoxAdapter(child: Center(child: Text(state.message)));
        }
        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }

  Widget _buildProductListView() {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()));
        } else if (state is ProductsLoaded) {
          return ProductListView(selectedCategory: _selectedCategory);
        } else if (state is ProductError) {
          return SliverToBoxAdapter(child: Center(child: Text(state.message)));
        }
        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.amber),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(_selectedCategory?.name ?? 'Бардык продукттар'),
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(Icons.sort),
          onSelected: (String value) {
            setState(() => _sortBy = value);
            _loadProducts();
          },
          itemBuilder: (BuildContext context) => const [
            PopupMenuItem(value: 'popular', child: Text('Популярдуулук боюнча')),
            PopupMenuItem(value: 'price_asc', child: Text('Баасы боюнча (өсүү)')),
            PopupMenuItem(value: 'price_desc', child: Text('Баасы боюнча (кемүү)')),
            PopupMenuItem(value: 'new', child: Text('Жаңылар')),
          ],
        ),
      ],
    );
  }
}