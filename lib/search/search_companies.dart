import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vhr_project/widgets/bottom_nav_bar.dart';

import '../widgets/all_companies_widget.dart';

class AllWorkersScreen extends StatefulWidget {
  @override
  State<AllWorkersScreen> createState() => _AllWorkersScreenState();
}

class _AllWorkersScreenState extends State<AllWorkersScreen> {
  final TextEditingController _searchQueryController = TextEditingController();
  String searchQuery = 'Search query';

  Widget _buildSeachField() {
    return TextField(
      controller: _searchQueryController,
      autocorrect: true,
      decoration: const InputDecoration(
        hintText: 'Search for company or user...',
        border: InputBorder.none,
        hintStyle: TextStyle(
          color: Colors.white54,
        ),
      ),
      style: const TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  List<Widget> _buildActions() {
    return <Widget>[
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          _clearSearchQuery();
        },
      ),
    ];
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQueryController.clear();
      updateSearchQuery('');
    });
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
      print(searchQuery);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueAccent.shade200, Colors.blueAccent.shade200],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: const [0.2, 0.9],
        ),
      ),
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBarForApp(indexNum: 1),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          // title: const Text('All Workers Screen'),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueAccent.shade200, Colors.blueAccent.shade200],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: const [0.2, 0.9],
              ),
            ),
          ),
          automaticallyImplyLeading: false,
          title: _buildSeachField(),
          actions: _buildActions(),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where('name', isGreaterThanOrEqualTo: searchQuery)
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.data!.docs.isNotEmpty) {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return AllWorkersWidget(
                      userID: snapshot.data!.docs[index]['id'],
                      userName: snapshot.data!.docs[index]['name'],
                      userEmail: snapshot.data!.docs[index]['email'],
                      phoneNumber: snapshot.data!.docs[index]['phoneNumber'],
                      userImageUrl: snapshot.data?.docs[index]['userImage'],
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text('There is no company or user'),
                );
              }
            }
            return const Center(
              child: Text(
                'Something went wrong',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
