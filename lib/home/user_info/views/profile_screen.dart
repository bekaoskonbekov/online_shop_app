import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_example_file/blocs/post/post_bloc.dart';
import 'package:my_example_file/blocs/post/post_event.dart';
import 'package:my_example_file/blocs/post/post_state.dart';
import 'package:my_example_file/blocs/profile/profile_bloc.dart';
import 'package:my_example_file/blocs/profile/profile_event.dart';
import 'package:my_example_file/blocs/profile/profile_state.dart';
import 'package:my_example_file/home/store/bloc/store/store_bloc.dart';
import 'package:my_example_file/home/store/bloc/store/store_event.dart';
import 'package:my_example_file/home/store/bloc/store/store_state.dart';
import 'package:my_example_file/home/store/models/store_model.dart';
import 'package:my_example_file/home/store/views/store/create_store_screen.dart';
import 'package:my_example_file/home/user_info/views/edit_profile_screen.dart';
import 'package:url_launcher/url_launcher.dart';


class ProfileTabScreen extends StatefulWidget {
  final String uid;

  const ProfileTabScreen({Key? key, required this.uid}) : super(key: key);

  @override
  _ProfileTabScreenState createState() => _ProfileTabScreenState();
}

class _ProfileTabScreenState extends State<ProfileTabScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
    context.read<EditProfileBloc>().add(GetProfileRequested(uid: widget.uid));
    context.read<PostBloc>().add(GetPosts());
    context.read<StoreBloc>().add(GetStore(widget.uid));
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
             
                background: _buildFlexibleSpaceBackground(),
              ),
              bottom: TabBar(
                controller: _tabController,
                tabs: [
                  Tab(text: 'Профиль'),
                  Tab(text: 'Дүкөн'),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildProfileTab(),
            _buildStoreTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildFlexibleSpaceBackground() {
    if (_tabController.index == 0) {
      return BlocBuilder<EditProfileBloc, EditProfileState>(
        builder: (context, state) {
          if (state is ProfileLoaded && state.profileData.photoUrl != null) {
            return Image.network(
              state.profileData.photoUrl,
              fit: BoxFit.cover,
            );
          }
          return Container(color: Theme.of(context).primaryColor);
        },
      );
    } else {
      return BlocBuilder<StoreBloc, StoreState>(
        builder: (context, state) {
          if (state is StoreLoaded && state.store.storeBannerUrl != null) {
            return Image.network(
              state.store.storeBannerUrl!,
              fit: BoxFit.cover,
            );
          }
          return Container(color: Theme.of(context).primaryColor);
        },
      );
    }
  }

  Widget _buildProfileTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<EditProfileBloc, EditProfileState>(
            builder: (context, state) {
              if (state is ProfileLoaded) {
                return Column(
                  children: [
                    _buildProfileInfo(state),
                    _buildEditProfileButton(),
                  ],
                );
              } else if (state is EditProfileLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is EditProfileFailure) {
                return Center(child: Text('Профилди жүктөө оңунан чыкпады: ${state.error}'));
              } else {
                return const Center(child: Text('Профиль маалыматтары жок'));
              }
            },
          ),
          _buildPostsSection(),
        ],
      ),
    );
  }

  Widget _buildStoreTab() {
    return BlocBuilder<StoreBloc, StoreState>(
      builder: (context, state) {
        if (state is StoreLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is StoreLoaded) {
          return _buildStoreDetails(context, state.store);
        } else if (state is StoreError) {
          return _buildCreateStorePrompt();
        } else if (state is StoreError) {
          return Center(child: Text('Ката: ${state.message}'));
        }
        return Center(child: Text('Белгисиз абал'));
      },
    );
  }

  Widget _buildCreateStorePrompt() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Сизде азырынча дүкөн жок'),
          SizedBox(height: 20),
          ElevatedButton(
            child: Text('Дүкөн түзүү'),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CreateStoreScreen(uid: widget.uid),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStoreDetails(BuildContext context, StoreModel store) {
    // Дүкөн маалыматтарын көрсөтүү логикасы (мурунку кодуңуздан)
    return ListView(
      padding: EdgeInsets.all(16.0),
      children: [
        Card(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Дүкөн жөнүндө',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                SizedBox(height: 8),
                Text(store.storeDescription ?? 'Сүрөттөмө жок'),
              ],
            ),
          ),
        ),
        SizedBox(height: 16),
        _buildContactInfo(store),
        SizedBox(height: 16),
        _buildBusinessHours(store.businessHours),
        SizedBox(height: 16),
        _buildSocialMediaLinks(store.socialMediaLinks),
      ],
    );
  }

  Widget _buildProfileInfo(ProfileLoaded state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            state.profileData.username,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(height: 8),
          Text(
            state.profileData.bio,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(height: 8),
          InkWell(
            onTap: () => _launchURL(state.profileData.url),
            child: Text(
              state.profileData.url,
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditProfileButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EditProfileScreen(uid: widget.uid),
          ));
        },
        icon: Icon(Icons.edit),
        label: Text('Профилди өзгөртүү'),
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 50),
        ),
      ),
    );
  }

  Widget _buildPostsSection() {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        if (state is PostLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is PostsLoaded) {
          final userPosts = state.posts.where((post) => post.userId == widget.uid).toList();
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatColumn('Посттор', userPosts.length.toString()),
                  ],
                ),
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                ),
                itemCount: userPosts.length,
                itemBuilder: (context, index) {
                  final post = userPosts[index];
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    child: Image.network(
                      post.imageUrls[0],
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                    ),
                  );
                },
              ),
            ],
          );
        } else if (state is PostError) {
          return Center(child: Text('Посттордо ката бар: ${state.error}'));
        }
        return const Center(child: Text('Посттор жок'));
      },
    );
  }

  Widget _buildStatColumn(String label, String count) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          count,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }





  Widget _buildContactInfo(StoreModel store) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text('Байланыш маалыматы', style: Theme.of(context).textTheme.titleLarge),
          ),
          if (store.contactPhone != null)
            ListTile(
              leading: Icon(Icons.phone, color: Theme.of(context).primaryColor),
              title: Text(store.contactPhone!),
              onTap: () => _launchURL('tel:${store.contactPhone}'),
            ),
          if (store.address != null)
            ListTile(
              leading: Icon(Icons.location_on, color: Theme.of(context).primaryColor),
              title: Text(store.address!),
              onTap: () => _launchURL('https://maps.google.com/?q=${store.address}'),
            ),
        ],
      ),
    );
  }

  Widget _buildBusinessHours(Map<String, String>? businessHours) {
    if (businessHours == null || businessHours.isEmpty) return SizedBox.shrink();
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text('Иш убактысы', style: Theme.of(context).textTheme.titleLarge),
          ),
          ...businessHours.entries.map((entry) => 
            ListTile(
              title: Text(entry.key),
              trailing: Text(entry.value),
            )
          ).toList(),
        ],
      ),
    );
  }

  Widget _buildSocialMediaLinks(List<String>? socialMediaLinks) {
    if (socialMediaLinks == null || socialMediaLinks.isEmpty) return SizedBox.shrink();
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text('Социалдык тармактар', style: Theme.of(context).textTheme.titleLarge),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: socialMediaLinks.map((link) => 
                ElevatedButton.icon(
                  icon: Icon(_getSocialMediaIcon(link)),
                  label: Text(_getSocialMediaName(link)),
                  onPressed: () => _launchURL(link),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                )
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getSocialMediaIcon(String link) {
    if (link.contains('facebook')) return Icons.facebook;
    if (link.contains('instagram')) return Icons.camera_alt;
    if (link.contains('twitter')) return Icons.whatshot_sharp;
    return Icons.link;
  }

  String _getSocialMediaName(String link) {
    if (link.contains('facebook')) return 'Facebook';
    if (link.contains('instagram')) return 'Instagram';
    if (link.contains('twitter')) return 'Twitter';
    return 'Website';
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}