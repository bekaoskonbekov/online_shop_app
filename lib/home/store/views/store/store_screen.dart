import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_example_file/home/store/bloc/store/store_bloc.dart';
import 'package:my_example_file/home/store/bloc/store/store_event.dart';
import 'package:my_example_file/home/store/bloc/store/store_state.dart';
import 'package:my_example_file/home/store/models/store_model.dart';
import 'package:url_launcher/url_launcher.dart';

class StoreScreen extends StatelessWidget {
  final String userId;

  const StoreScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<StoreBloc>().add(GetStore(userId));

    return Scaffold(
      body: BlocBuilder<StoreBloc, StoreState>(
        builder: (context, state) {
          if (state is StoreLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is StoreLoaded) {
            return _buildStoreDetails(context, state.store);
          } else if (state is StoreError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return Center(child: Text('No store found.'));
        },
      ),
    );
  }

  Widget _buildStoreDetails(BuildContext context, StoreModel store) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 200.0,
          floating: false,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(store.storeName),
            background: store.storeBannerUrl != null
                ? Image.network(store.storeBannerUrl!, fit: BoxFit.cover)
                : Container(color: Colors.grey),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About Store',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: 8),
                  Text(store.storeDescription ?? 'No description available'),
                  SizedBox(height: 16),
                  _buildContactInfo(store),
                  SizedBox(height: 16),
                  _buildBusinessHours(store.businessHours),
                  SizedBox(height: 16),
                  _buildSocialMediaLinks(store.socialMediaLinks),
                ],
              ),
            ),
          ]),
        ),
      ],
    );
  }

  Widget _buildContactInfo(StoreModel store) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Contact Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        if (store.contactPhone != null)
          ListTile(
            leading: Icon(Icons.phone),
            title: Text(store.contactPhone!),
            onTap: () => _launchURL('tel:${store.contactPhone}'),
          ),
        if (store.address != null)
          ListTile(
            leading: Icon(Icons.location_on),
            title: Text(store.address!),
            onTap: () => _launchURL('https://maps.google.com/?q=${store.address}'),
          ),
      ],
    );
  }

  Widget _buildBusinessHours(Map<String, String>? businessHours) {
    if (businessHours == null || businessHours.isEmpty) return SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Business Hours', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        ...businessHours.entries.map((entry) => 
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(entry.key, style: TextStyle(fontWeight: FontWeight.bold)),
                Text(entry.value),
              ],
            ),
          )
        ).toList(),
      ],
    );
  }

  Widget _buildSocialMediaLinks(List<String>? socialMediaLinks) {
    if (socialMediaLinks == null || socialMediaLinks.isEmpty) return SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Social Media', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: socialMediaLinks.map((link) => 
            ElevatedButton.icon(
              icon: Icon(_getSocialMediaIcon(link)),
              label: Text(_getSocialMediaName(link)),
              onPressed: () => _launchURL(link),
            )
          ).toList(),
        ),
      ],
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