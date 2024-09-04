import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LikesPage extends StatefulWidget {
  @override
  _LikesPageState createState() => _LikesPageState();
}

class _LikesPageState extends State<LikesPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> _getLikedShows() async {
    User? user = _auth.currentUser;
    if (user != null) {
      QuerySnapshot snapshot = await _firestore.collection('users').doc(user.uid).collection('likes').get();
      return snapshot.docs.map((doc) => {
        'id': doc.id,
        'data': doc.data()
      }).toList();
    }
    return [];
  }

  Future<void> _deleteLikedShow(String id) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).collection('likes').doc(id).delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Beğeniler'),
        backgroundColor: Colors.black,
        titleTextStyle: TextStyle(color: Colors.white),
        iconTheme: IconThemeData(color: Colors.white), // Sol yönlü butonu beyaz yap
      ),
      backgroundColor: Colors.black, // Scaffold arka plan rengini siyah yap
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _getLikedShows(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Beğenilen gösteriler yüklenirken hata oluştu', style: TextStyle(color: Colors.white)));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Henüz beğeni yok!', style: TextStyle(color: Colors.white)));
          }

          var likedShows = snapshot.data!;
          return ListView.builder(
            itemCount: likedShows.length,
            itemBuilder: (context, index) {
              var show = likedShows[index]['data'];
              var showId = likedShows[index]['id'];
              return ListTile(
                leading: Image.asset(show['image'], width: 50, height: 50, fit: BoxFit.cover),
                title: Text(show['title'], style: TextStyle(color: Colors.white)),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    await _deleteLikedShow(showId);
                    setState(() {
                      likedShows.removeAt(index);
                    });
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
