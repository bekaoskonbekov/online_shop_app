import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_example_file/auth/repository/auth_repository.dart';
import 'package:my_example_file/auth/views/login_page.dart';
import 'package:my_example_file/blocs/app/app_bloc.dart';
import 'package:my_example_file/blocs/app/app_event.dart';
import 'package:my_example_file/blocs/app/app_state.dart';
import 'package:my_example_file/blocs/auth/auth_bloc.dart';
import 'package:my_example_file/blocs/auth/auth_event.dart';
import 'package:my_example_file/blocs/auth/auth_state.dart';
import 'package:my_example_file/blocs/chat/chat_bloc.dart';
import 'package:my_example_file/blocs/post/post_bloc.dart';
import 'package:my_example_file/core/helpers/chace_helper.dart';
import 'package:my_example_file/core/views/main_screen.dart';
import 'package:my_example_file/firebase_options.dart';
import 'package:my_example_file/core/utils/styles/app_theme.dart';
import 'package:my_example_file/blocs/profile/profile_bloc.dart';
import 'package:my_example_file/home/chat/repositories/chat_repository.dart';
import 'package:my_example_file/home/store/bloc/brand/brand_bloc.dart';
import 'package:my_example_file/home/store/bloc/material/material_bloc.dart';
import 'package:my_example_file/home/store/bloc/product_bloc/product_bloc.dart';
import 'package:my_example_file/home/store/bloc/product_category/product_category_bloc.dart';
import 'package:my_example_file/home/store/bloc/store/store_bloc.dart';
import 'package:my_example_file/home/store/product/clothing/blocs/clothing/clothing_bloc.dart';
import 'package:my_example_file/home/store/product/clothing/blocs/sizes/size_bloc.dart';
import 'package:my_example_file/home/store/product/clothing/repositories/clothing_repository.dart';
import 'package:my_example_file/home/store/product/clothing/repositories/size_repository.dart';
import 'package:my_example_file/home/store/product/electronics/blocs/OS/OS_bloc.dart';
import 'package:my_example_file/home/store/product/electronics/blocs/electronics_bloc.dart';
import 'package:my_example_file/home/store/product/electronics/repositories/OS_repository.dart';
import 'package:my_example_file/home/store/product/electronics/repositories/electronic_repository.dart';
import 'package:my_example_file/home/store/repositories/brand_repository.dart';
import 'package:my_example_file/home/store/repositories/category_repository.dart';
import 'package:my_example_file/home/store/repositories/color_repository.dart';
import 'package:my_example_file/home/store/repositories/country_of_origin_repository.dart';
import 'package:my_example_file/home/store/repositories/material_repository.dart';
import 'package:my_example_file/home/store/repositories/product_repository.dart';
import 'package:my_example_file/home/store/repositories/product_services.dart';
import 'package:my_example_file/home/store/repositories/store_repository.dart';
import 'package:my_example_file/home/store/views/product/screens/create_product/product_creation.dart';
import 'package:my_example_file/home/user_info/repositoris/user_info_repository.dart';
import 'package:my_example_file/home/posts/repositories/post_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
  );

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en', 'EN'),
        Locale('ru', 'RU'),
        Locale('ky', 'KG'),
      ],
      path: 'assets/translations',
      fallbackLocale: Locale('en', 'EN'),
      saveLocale: true,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final AuthRepository authRepository = AuthRepository();
    final EditProfileRepository editProfileRepository = EditProfileRepository();
    final PostRepository postRepository = PostRepository();
    final StoreRepository storeRepository = StoreRepository();
    final ProductRepository productRepository = ProductRepository(firestore);
    final CategoryRepository categoryRepository = CategoryRepository(firestore);
    final BrandRepository brandRepository = BrandRepository();
    final ColorRepository colorRepository = ColorRepository();
    final CountryOfOriginRepository countryOfOriginRepository =
        CountryOfOriginRepository();
    final MaterialRepository materialRepository = MaterialRepository();
    final ClothingRepository clothingRepository = ClothingRepository();
    final SizeRepository sizeRepository = SizeRepository();
    final ElectronicsRepository electronicsRepository = ElectronicsRepository(firestore);
    final OSRepository osRepository = OSRepository(firestore);
    final ProductService productService = ProductService(firestore);

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(create: (context) => authRepository),
        RepositoryProvider<EditProfileRepository>(
            create: (context) => editProfileRepository),
        RepositoryProvider<PostRepository>(create: (context) => postRepository),
        RepositoryProvider<ProductRepository>(
            create: (context) => productRepository),
        RepositoryProvider<CategoryRepository>(
            create: (context) => categoryRepository),
        RepositoryProvider<BrandRepository>(
            create: (context) => brandRepository),
        RepositoryProvider<ColorRepository>(
            create: (context) => colorRepository),
        RepositoryProvider<CountryOfOriginRepository>(
            create: (context) => countryOfOriginRepository),
        RepositoryProvider<MaterialRepository>(
            create: (context) => materialRepository),
        RepositoryProvider<ClothingRepository>(
            create: (context) => clothingRepository),
        RepositoryProvider<SizeRepository>(create: (context) => sizeRepository),
        RepositoryProvider<ElectronicsRepository>(
            create: (context) => electronicsRepository),
        RepositoryProvider<OSRepository>(create: (context) => osRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => AppStateBloc()..add(LoadAppState())),
          BlocProvider(
              create: (context) => AuthBloc(authRepository: authRepository)
                ..add(CheckAuthStatus())),
          BlocProvider(
            create: (context) =>
                EditProfileBloc(editrepository: editProfileRepository),
          ),
          BlocProvider(
            create: (context) => PostBloc(postRepository: postRepository),
          ),
          BlocProvider(
            create: (context) => ChatBloc(chatRepository: ChatRepository()),
          ),
          BlocProvider(
            create: (context) => StoreBloc(storeRepository: storeRepository),
          ),
          BlocProvider(
            create: (context) =>
                ProductBloc(productService: productService),
          ),
          BlocProvider(
            create: (context) =>
                CategoryBloc(categoryRepository: categoryRepository),
          ),
          BlocProvider(
            create: (context) =>
                ClothingBloc(clothingRepository: clothingRepository),
          ),
          BlocProvider(
            create: (context) => SizeBloc(sizeRepository: sizeRepository),
          ),
          BlocProvider(
            create: (context) => ElectronicsBloc(
                productService: productService),
          ),
          BlocProvider(
            create: (context) => OSBloc(osRepository: osRepository),
          ),
          BlocProvider(
            create: (context) => MaterialBloc(materialRepository: materialRepository),
          ),
          BlocProvider(
            create: (context) => ProductCreationBloc(
              productRepository: productRepository,
              brandRepository: brandRepository,
              materialRepository: materialRepository,
              countryOfOriginRepository: countryOfOriginRepository,
              colorRepository: colorRepository,
              categoryRepository: categoryRepository,
            ),
          ),
        ],
        child: BlocBuilder<AppStateBloc, AppState>(
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: LightTheme.lightTheme,
              darkTheme: DarkTheme.darkTheme,
              themeMode: state.themeMode,
              locale: state.locale,
              supportedLocales: context.supportedLocales,
              localizationsDelegates: context.localizationDelegates,
              home: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, authState) {
                  if (authState is Authenticated) {
                    return MainScreen();
                  }
                  return LoginPage();
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
