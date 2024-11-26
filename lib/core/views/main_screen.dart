import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_example_file/blocs/app/app_bloc.dart';
import 'package:my_example_file/blocs/app/app_event.dart';
import 'package:my_example_file/blocs/app/app_state.dart';
import 'package:my_example_file/blocs/auth/auth_bloc.dart';
import 'package:my_example_file/blocs/auth/auth_state.dart';
import 'package:my_example_file/core/views/home_screen.dart';
import 'package:my_example_file/home/chat/views/chat_list_screen.dart';
import 'package:my_example_file/home/posts/views/post/views/post_screen.dart';
import 'package:my_example_file/home/store/bloc/store/store_bloc.dart';
import 'package:my_example_file/home/store/bloc/store/store_state.dart';
import 'package:my_example_file/home/store/product/clothing/screens/size_managment_screen.dart';
import 'package:my_example_file/home/store/product/electronics/screens/OS_management_screen.dart';
import 'package:my_example_file/home/store/views/category/brand_management_screen.dart';
import 'package:my_example_file/home/store/views/category/category_management_screen.dart';
import 'package:my_example_file/home/store/views/category/color_management_screen.dart';
import 'package:my_example_file/home/store/views/category/country_of_origin_management_screen.dart';
import 'package:my_example_file/home/store/views/category/material_management_screen.dart';
import 'package:my_example_file/home/store/views/product/screens/get_product/product_card.dart';
import 'package:my_example_file/home/store/views/product/screens/create_product/category_list_screen.dart';
import 'package:my_example_file/home/user_info/views/profile_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        return BlocBuilder<AppStateBloc, AppState>(
          builder: (context, appState) {
            return Scaffold(
              body: _buildBody(appState.lastOpenedPage, authState, context),
              bottomNavigationBar:
                  _buildBottomNavigationBar(context, appState.lastOpenedPage),
            );
          },
        );
      },
    );
  }

  Widget _buildBody(String page, AuthState authState, BuildContext context) {
    switch (page) {
      case 'store':
        return const ProductListScreen();
      case 'home':
        return const PostScreen();
      case 'add':
        return _buildAddScreen(authState);
      case 'chat':
        return _buildChatScreen(authState);
      case 'profile':
        return _buildProfileScreen(authState);
      default:
        return const HomeScreen();
    }
  }

  Widget _buildAddScreen(AuthState authState) {
    if (authState is Authenticated) {
      return BlocBuilder<StoreBloc, StoreState>(
        builder: (context, state) {
          if (state is StoreLoaded) {
            return CategoryListScreen(storeId: state.store.storeId);
            // return OSManagementScreen();
            // return SizeManagementScreen();
            return MaterialManagementScreen();
            // return CountryOfOriginManagementScreen();
            // return ColorManagementScreen();
            return BrandManagementScreen();
            return CategoryManagementScreen();
          }
          return const Center(child: CircularProgressIndicator());
        },
      );
    }
    return const Center(child: Text('Сиз системага кирген жоксуз'));
  }

  Widget _buildChatScreen(AuthState authState) {
    if (authState is Authenticated) {
      return ChatListScreen(currentUser: authState.user);
    }
    return const Center(child: Text('Сиз система кирген жоксуз'));
  }

  Widget _buildProfileScreen(AuthState authState) {
    if (authState is Authenticated) {
      return ProfileTabScreen(uid: authState.user.uid);
    }
    return const Center(child: Text('Сиз система кирген жоксуз'));
  }

  Widget _buildBottomNavigationBar(BuildContext context, String currentPage) {
    return BottomNavigationBar(
      currentIndex: _getSelectedIndex(currentPage),
      onTap: (index) => _onItemTapped(context, index),
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Iconsax.shopping_cart), label: 'магазин'),
        BottomNavigationBarItem(icon: Icon(Iconsax.home), label: 'Башкы'),
        BottomNavigationBarItem(icon: Icon(Iconsax.add_square), label: 'Add'),
        BottomNavigationBarItem(icon: Icon(Iconsax.messages_2), label: 'Чат'),
        BottomNavigationBarItem(
            icon: Icon(Iconsax.user_edit), label: 'Профиль'),
      ],
    );
  }

  int _getSelectedIndex(String page) {
    final pageIndex = {
      'store': 0,
      'home': 1,
      'add': 2,
      'chat': 3,
      'profile': 4
    };
    return pageIndex[page] ?? 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    final pages = ['store', 'home', 'add', 'chat', 'profile'];
    context.read<AppStateBloc>().add(UpdateLastOpenedPage(pages[index]));
  }
}
