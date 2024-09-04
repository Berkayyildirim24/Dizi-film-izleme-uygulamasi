import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> _getUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
      return doc.data() as Map<String, dynamic>?;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Profile', style: TextStyle(color: Colors.white)),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error loading user data', style: TextStyle(color: Colors.white)));
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No user data found', style: TextStyle(color: Colors.white)));
          }

          var userData = snapshot.data!;
          return Container(
            color: Colors.black,
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/profile_picture.png'), // Profil resmi için yer tutucu
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${userData['name']} ${userData['surname']}',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        Text(
                          userData['email'],
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(height: 40, color: Colors.grey),
                ListTile(
                  title: Text('Account', style: TextStyle(color: Colors.white)),
                  subtitle: Text('Account setting', style: TextStyle(color: Colors.white60)),
                  onTap: () {
                    Navigator.of(context).pushNamed('/account_settings');  // Navigasyon yönlendirme
                  },
                ),
                ListTile(
                  title: Text('My favorite', style: TextStyle(color: Colors.white)),
                  subtitle: Text('Course favorite', style: TextStyle(color: Colors.white60)),
                  onTap: () {
                    // Favori kurslar sayfasına yönlendir
                  },
                ),
                ListTile(
                  title: Text('Language', style: TextStyle(color: Colors.white)),
                  subtitle: Text('English', style: TextStyle(color: Colors.white60)),
                  onTap: () {
                    // Dil ayarları sayfasına yönlendir
                  },
                ),
                ListTile(
                  title: Text('About', style: TextStyle(color: Colors.white)),
                  subtitle: Text('AboutUs', style: TextStyle(color: Colors.white60)),
                  onTap: () {
                    // Hakkında sayfasına yönlendir
                  },
                ),
                ListTile(
                  title: Text('Help', style: TextStyle(color: Colors.white)),
                  subtitle: Text('Contact Us', style: TextStyle(color: Colors.white60)),
                  onTap: () {
                    // İletişim sayfasına yönlendir
                  },
                ),
                Divider(height: 40, color: Colors.grey),
                ListTile(
                  title: Text('Logout', style: TextStyle(color: Colors.red)),
                  subtitle: Text('Sign out the account', style: TextStyle(color: Colors.red)),
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushReplacementNamed('/login');
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
