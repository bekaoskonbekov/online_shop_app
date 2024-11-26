import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_example_file/blocs/post/post_bloc.dart';
import 'package:my_example_file/blocs/post/post_event.dart';
import 'package:my_example_file/blocs/post/post_state.dart';
import 'package:my_example_file/blocs/profile/profile_bloc.dart';
import 'package:my_example_file/blocs/profile/profile_state.dart';
import 'package:my_example_file/home/posts/repositories/post_repository.dart';
import 'package:my_example_file/home/posts/views/post/views/dynaic_post_card.dart';
import 'package:my_example_file/home/posts/models/category_model.dart';
import 'package:my_example_file/home/posts/models/location_model.dart';
import 'package:my_example_file/home/posts/models/post_model.dart';
import 'package:my_example_file/home/store/bloc/product_bloc/product_bloc.dart';
import 'package:my_example_file/home/store/bloc/product_bloc/product_state.dart';
import 'package:my_example_file/home/store/models/product_category.dart';
import 'package:my_example_file/home/store/views/product/screens/get_product/product_card.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isGridView = true;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  bool _isVisible = true;
  CategoryModel? _selectedCategory;
  SubCategoryModel? _selectedSubCategory;
  LocationModel? _selectedLocation;
  ProductCategoryModel? _categoryModel;
  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_isVisible) {
          setState(() {
            _isVisible = false;
          });
        }
      } else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!_isVisible) {
          setState(() {
            _isVisible = true;
          });
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostBloc(
        postRepository: RepositoryProvider.of<PostRepository>(context),
      )..add(GetPosts()),
      child: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          if (state is PostsLoaded) {
            final uniqueCategories = state.posts
                .expand((post) => post.category)
                .fold<Map<String, CategoryModel>>({}, (map, category) {
                  map[category.id] = category;
                  return map;
                })
                .values
                .toList();

            final uniqueLocations = state.posts
                .expand((post) => post.location)
                .fold<Map<String, LocationModel>>({}, (map, location) {
                  map[location.id] = location;
                  return map;
                })
                .values
                .toList();

            return DefaultTabController(
              length: 2,
              child: Scaffold(
                endDrawer:
                    _buildCategoryDrawer(uniqueCategories, uniqueLocations),
                key: _scaffoldKey,
                body: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: NestedScrollView(
                    controller: _scrollController,
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return [
                        SliverAppBar(
                          floating: true,
                          scrolledUnderElevation: 0,
                          elevation: 0,
                          snap: true,
                          stretch: false,
                          surfaceTintColor: Colors.transparent,
                          expandedHeight: 110.0,
                          flexibleSpace: FlexibleSpaceBar(
                            background: Column(
                              children: [
                                _isVisible
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            left: 25.0, top: 36, bottom: 15),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: AnimatedContainer(
                                                duration: const Duration(
                                                    milliseconds: 300),
                                                curve: Curves.easeInOut,
                                                height: 38,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  border: Border.all(
                                                      color: Colors.grey),
                                                ),
                                                child: Row(
                                                  children: [
                                                    IconButton(
                                                      icon: const Icon(
                                                          Icons.search),
                                                      onPressed: () {
                                                        setState(() {
                                                          _isSearching =
                                                              !_isSearching;
                                                          if (!_isSearching) {
                                                            _searchController
                                                                .clear();
                                                          }
                                                        });
                                                      },
                                                    ),
                                                    Expanded(
                                                      child: AnimatedOpacity(
                                                        opacity: _isSearching
                                                            ? 1.0
                                                            : 0.0,
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    300),
                                                        child: TextField(
                                                          controller:
                                                              _searchController,
                                                          decoration:
                                                              const InputDecoration(
                                                            hintText: 'Search',
                                                            border: InputBorder
                                                                .none,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                  Icons.favorite_outline),
                                              onPressed: () {},
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                _buildCategoryDrawer(
                                                    uniqueCategories,
                                                    uniqueLocations);
                                                _scaffoldKey.currentState!
                                                    .openEndDrawer();
                                              },
                                              icon: const Icon(Icons.list),
                                            ),
                                          ],
                                        ),
                                      )
                                    : const SizedBox(),
                                _isVisible
                                    ? const TabBar(dividerHeight: 0, tabs: [
                                        Text("ЖАРНАМА"),
                                        Text("STORE"),
                                      ])
                                    : const SizedBox.shrink()
                              ],
                            ),
                          ),
                        ),
                      ];
                    },
                    body: TabBarView(
                      children: [
                        _selectedCategory != null
                            ? _buildCategoryPosts(
                                state.posts, _selectedCategory!)
                            : _selectedLocation != null
                                ? _buildLocationPosts(
                                    state.posts, _selectedLocation!)
                                : _buildAllPosts(state.posts),
                       Text("Color")
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else if (state is PostLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PostError) {
            return Center(
              child: Text('Ката: ${state.error}',
                  style: const TextStyle(color: Colors.red)),
            );
          } else {
            return const Center(child: Text('Жүктөлүүдө...'));
          }
        },
      ),
    );
  }

  Widget _buildCategoryPosts(List<PostModel> allPosts, CategoryModel category) {
    final categoryPosts = allPosts
        .where((post) => post.category.any((cat) => cat.id == category.id))
        .where((post) =>
            _selectedSubCategory == null ||
            post.category.any((sub) => sub.id == _selectedSubCategory!.id))
        .toList();

    if (categoryPosts.isEmpty) {
      return const Center(
        child: Text(
          'Бул категорияда посттор жок',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      );
    }

    return BlocBuilder<EditProfileBloc, EditProfileState>(
      builder: (context, userState) {
        if (userState is ProfileLoaded) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<PostBloc>().add(GetPosts());
            },
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Column(
                children: [
                  _isGridView
                      ? _buildGridView(categoryPosts, userState)
                      : _buildListView(categoryPosts, userState),
                ],
              ),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildLocationPosts(List<PostModel> allPosts, LocationModel location) {
    final locationPosts = allPosts
        .where((post) => post.location.any((loc) => loc.id == location.id))
        .toList();

    if (locationPosts.isEmpty) {
      return const Center(
        child: Text(
          'Бул жайгашкан жер боюнча посттор жок',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      );
    }

    return BlocBuilder<EditProfileBloc, EditProfileState>(
      builder: (context, userState) {
        if (userState is ProfileLoaded) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<PostBloc>().add(GetPosts());
            },
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Column(
                children: [
                  _isGridView
                      ? _buildGridView(locationPosts, userState)
                      : _buildListView(locationPosts, userState),
                ],
              ),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildListView(List<PostModel> posts, ProfileLoaded userState) {
    return Expanded(
      child: ListView.builder(
        key: const ValueKey('list_view'), // Unique key for AnimatedSwitcher
        itemCount: posts.length,
        itemBuilder: (BuildContext context, int index) {
          return DynamicPostCard(
            post: posts[index],
            currentUser: userState.profileData,
            isListView: true,
          );
        },
      ),
    );
  }

  Widget _buildGridView(List<PostModel> posts, ProfileLoaded userState) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: GridView.builder(
          key: const ValueKey('grid_view'),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: posts.length,
          itemBuilder: (context, index) {
            return _buildProductCard(posts[index]);
          },
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
        ),
      ),
    );
  }

  Widget _buildProductCard(PostModel post) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isGridView = false;
                });
              },
              child: Container(
                width: double.infinity,
                height: 150,
                child: Image.network(
                  post.imageUrls.first,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Text(
                      post.price.toString(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      post.currency,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllPosts(List<PostModel> allPosts) {
    if (allPosts.isEmpty) {
      return const Center(
        child: Text(
          'Посттор жок',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      );
    }
    return BlocBuilder<EditProfileBloc, EditProfileState>(
      builder: (context, userState) {
        if (userState is ProfileLoaded) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<PostBloc>().add(GetPosts());
            },
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Column(
                children: [
                  _isGridView
                      ? _buildGridView(allPosts, userState)
                      : _buildListView(allPosts, userState),
                ],
              ),
            ),
          );
        } else if (userState is EditProfileLoading) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return const Center(child: Text('Каттоо профили жеткиликтүү эмес'));
        }
      },
    );
  }

  Widget _buildCategoryDrawer(
      List<CategoryModel> categories, List<LocationModel> locations) {
    return Drawer(
      width: 400,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: const Text('Көрүнүштү тандоо',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Row(
                      children: [
                        Expanded(
                          child: RadioListTile<bool>(
                            title: const Text('Тизмек'),
                            value: false, // тизмектелген көрүнүш үчүн
                            groupValue: _isGridView,
                            onChanged: (bool? value) {
                              setState(() {
                                _isGridView = value!;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<bool>(
                            title: const Text('Торчо'),
                            value: true, // торчо көрүнүш үчүн
                            groupValue: _isGridView,
                            onChanged: (bool? value) {
                              setState(() {
                                _isGridView = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(height: 0.1),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Категория тандоо',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return ListTile(
                      title: Text(category.name),
                      trailing: const Icon(Icons.arrow_drop_down),
                      onTap: () => _showCategoryBottomSheet(context, category),
                      onLongPress: () {
                        Navigator.pop(context);
                        setState(() {
                          _selectedCategory = category;
                          _selectedSubCategory = null; // Субкатегорияны тазалоо
                        });
                        print('Тандалган категория: ${category.name}');
                      },
                    );
                  },
                ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Жайгашкан жерди тандоо',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: locations.length,
                  itemBuilder: (context, index) {
                    final location = locations[index];
                    return ListTile(
                      title: Text(location.name),
                      trailing: const Icon(Icons.arrow_drop_down),
                      onTap: () => _showLocationBottomSheet(context, location),
                      onLongPress: () {
                        Navigator.pop(context);
                        setState(() {
                          _selectedLocation = location;
                        });
                        print('Тандалган жайгашкан жер: ${location.name}');
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLocationBottomSheet(BuildContext context, LocationModel location) {
    SubLocationModel? _selectedSubLocation;
    bool showAllLocations = false;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text(
                    'Жайгашкан жерди тандаңыз: ${location.name}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                RadioListTile<bool>(
                  title: const Text('Бардык постторду көрсөтүү'),
                  value: true,
                  groupValue: showAllLocations,
                  onChanged: (bool? value) {
                    setState(() {
                      showAllLocations = value!;
                      _selectedSubLocation = null;
                    });
                    Navigator.pop(context, null); // Бардык постторду көрсөтүү
                  },
                ),
                ...location.subLocations.map((subLocation) {
                  return RadioListTile<SubLocationModel>(
                    title: Text(subLocation.name),
                    value: subLocation,
                    groupValue: _selectedSubLocation,
                    onChanged: (SubLocationModel? value) {
                      setState(() {
                        _selectedSubLocation = value;
                        showAllLocations = false;
                      });
                      Navigator.pop(context,
                          _selectedSubLocation); // Тандалган субжайгашкан жерди кайтаруу
                    },
                  );
                }).toList(),
              ],
            );
          },
        );
      },
    ).then((selectedSubLocation) {
      if (selectedSubLocation != null || showAllLocations) {
        setState(() {
          _selectedSubLocation = selectedSubLocation;
          _selectedLocation = location;
          // Handle showing all posts or filtered posts here
          if (showAllLocations) {
            print('Бардык постторду көрсөтүү');
          } else if (_selectedSubLocation != null) {
            print('Тандалган суб-жайгашкан жер: ${_selectedSubLocation!.name}');
          }
        });
      }
    });
  }

  void _showCategoryBottomSheet(BuildContext context, CategoryModel category) {
    SubCategoryModel? _selectedSubCategory;
    bool showAllCategories = false;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text(
                    'Тандаңыз: ${category.name}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                RadioListTile<bool>(
                  title: Text('Бардык ${category.name} постторун көрсөтүү'),
                  value: true,
                  groupValue: showAllCategories,
                  onChanged: (bool? value) {
                    setState(() {
                      showAllCategories = value!;
                      _selectedSubCategory = null;
                    });
                    Navigator.pop(
                        context, null); // Бардык категория постторун көрсөтүү
                  },
                ),
                ...category.subcategories.map((subCategory) {
                  return RadioListTile<SubCategoryModel>(
                    title: Text(subCategory.name),
                    value: subCategory,
                    groupValue: _selectedSubCategory,
                    onChanged: (SubCategoryModel? value) {
                      setState(() {
                        _selectedSubCategory = value;
                        showAllCategories = false;
                      });
                      Navigator.pop(context,
                          _selectedSubCategory); // Тандалган субкатегорияны кайтаруу
                    },
                  );
                }).toList(),
              ],
            );
          },
        );
      },
    ).then((selectedSubCategory) {
      if (selectedSubCategory != null || showAllCategories) {
        setState(() {
          _selectedSubCategory = selectedSubCategory;
          _selectedCategory = category;
          // Handle showing all posts or filtered posts here
          if (showAllCategories) {
            print('Бардык категория постторун көрсөтүү');
          } else if (_selectedSubCategory != null) {
            print('Тандалган субкатегория: ${_selectedSubCategory!.name}');
          }
        });
      }
    });
  }
}
