import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ContentPage extends StatefulWidget {
  @override
  _ContentPageState createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  bool _isLiked = false;
  late YoutubePlayerController _controller;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: 'A5aiTaaev5w', //Youtube video ID'si
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
    _checkIfLiked();
  }

  void _checkIfLiked() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('likes')
          .doc('ARROW')
          .get();
      setState(() {
        _isLiked = doc.exists;
      });
    }
  }

  void _toggleLike() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentReference likeRef = _firestore.collection('users').doc(user.uid).collection('likes').doc('ARROW');
      if (_isLiked) {
        await likeRef.delete();
      } else {
        await likeRef.set({
          'title': 'ARROW',
          'image': 'assets/images/arrow.jpg',
        });
      }
      setState(() {
        _isLiked = !_isLiked;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ARROW',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(
          color: Colors.white, // Sol yönlü okun beyaz olması için yaptım
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 315,
              child: YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
              ),
            ),
            SizedBox(height: 8),
            IconButton(
              icon: Icon(
                _isLiked ? Icons.favorite : Icons.favorite_border,
                color: _isLiked ? Colors.red : Colors.white,
              ),
              onPressed: _toggleLike,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ExpansionTile(
                title: Text(
                  'Sezonlar',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                children: <Widget>[
                  ListTile(
                    title: Text('1. Sezon', style: TextStyle(color: Colors.white)),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text('2. Sezon', style: TextStyle(color: Colors.white)),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text('3. Sezon', style: TextStyle(color: Colors.white)),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text('4. Sezon', style: TextStyle(color: Colors.white)),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text('5. Sezon', style: TextStyle(color: Colors.white)),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ExpansionTile(
                title: Text(
                  'Bölümler',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                children: <Widget>[
                  ListTile(
                    title: Text('1. Bölüm', style: TextStyle(color: Colors.white)),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text('2. Bölüm', style: TextStyle(color: Colors.white)),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text('3. Bölüm', style: TextStyle(color: Colors.white)),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text('4. Bölüm', style: TextStyle(color: Colors.white)),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text('5. Bölüm', style: TextStyle(color: Colors.white)),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text('6. Bölüm', style: TextStyle(color: Colors.white)),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text('7. Bölüm', style: TextStyle(color: Colors.white)),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text('8. Bölüm', style: TextStyle(color: Colors.white)),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text('9. Bölüm', style: TextStyle(color: Colors.white)),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text('10. Bölüm', style: TextStyle(color: Colors.white)),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Arrow, DC Comics karakteri Green Arrow\'a dayanan bir Amerikan süper kahraman televizyon dizisidir. Şehirdeki suçla savaşan zengin bir playboy olan Oliver Queen\'in maceralarını takip eder.',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}
