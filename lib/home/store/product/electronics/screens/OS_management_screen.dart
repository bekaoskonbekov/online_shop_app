import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_example_file/home/store/product/electronics/blocs/OS/OS_bloc.dart';
import 'package:my_example_file/home/store/product/electronics/blocs/OS/OS_event.dart';
class OSManagementScreen extends StatefulWidget {
  const OSManagementScreen({Key? key}) : super(key: key);

  @override
  _OSManagementScreenState createState() => _OSManagementScreenState();
}

class _OSManagementScreenState extends State<OSManagementScreen> {
  final Map<String, List<Map<String, dynamic>>> initialOSList = {
  'laptop': [
    {
      'name': 'Windows',
      'versions': ['11', '10', '8.1', '8', '7'],
      'releaseDateYear': [2021, 2015, 2013, 2012, 2009],
    },
    {
      'name': 'macOS',
      'versions': ['Monterey', 'Big Sur', 'Catalina'],
      'releaseDateYear': [2021, 2020, 2019],
    },
    {
      'name': 'Linux',
      'versions': ['Ubuntu 22.04', 'Fedora 35', 'Debian 11'],
      'releaseDateYear': [2022, 2021, 2021],
    },
  ],
  'phone': [
    {
      'name': 'Android',
      'versions': ['13', '12', '11', '10', '9', '8'],
      'releaseDateYear': [2022, 2021, 2020, 2019, 2018, 2017],
    },
    {
      'name': 'iOS',
      'versions': ['16', '15', '14'],
      'releaseDateYear': [2022, 2021, 2020],
    },
  ],
  'tablet': [
    {
      'name': 'iPadOS',
      'versions': ['16', '15', '14'],
      'releaseDateYear': [2022, 2021, 2020],
    },
    {
      'name': 'Android',
      'versions': ['13', '12', '11'],
      'releaseDateYear': [2022, 2021, 2020],
    },
  ],
};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _initializeOS(context),
        child: const Icon(Icons.playlist_add),
        tooltip: 'Бардык операциялык системаларды кошуу',
      ),
    );
  }
  void _initializeOS(BuildContext context) {
    context.read<OSBloc>().add(InitializeOS(initialOSList));
  }
}