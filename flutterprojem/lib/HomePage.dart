import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutterprojem/likes.dart';
import 'package:flutterprojem/profile.dart';
import 'package:flutterprojem/content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'account_settings.dart';



class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    HomeContent(),
    LibraryPage(),
    Profile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          children: <Widget>[
            Image.asset(
              'assets/images/cinema.png',
              fit: BoxFit.contain,
              height: 32,
            ),
            SizedBox(width: 8),
            Text(
              'Dizitent',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app, color: Colors.white), // Çıkış ikonu ekleniyor
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.white),
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_movies, color: Colors.white),
            label: 'İzle',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.white),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'HOŞGELDİNİZ',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          CarouselSlider(
            options: CarouselOptions(
              height: 200,
              enlargeCenterPage: true,
              autoPlay: true,
              aspectRatio: 16 / 9,
              autoPlayCurve: Curves.fastOutSlowIn,
              enableInfiniteScroll: true,
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              viewportFraction: 0.8,
            ),
            items: [
              'assets/images/himym.jpg',
              'assets/images/gameofthrones.jpg',
              'assets/images/strangerthings.jpg',
            ].map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(color: Colors.amber),
                    child: Image.asset(i, fit: BoxFit.cover),
                  );
                },
              );
            }).toList(),
          ),
          SizedBox(height: 8),
          SectionWidget(
            title: 'Diziler',
            items: [
              'assets/images/arrow.jpg',
              'assets/images/breakingbad.jpg',
              'assets/images/theboys.jpg',
              'assets/images/theflash.jpg',
            ],
            names: [
              'Arrow',
              'Breaking Bad',
              'The Boys',
              'The Flash',
            ],
          ),
          SizedBox(height: 8),
          SectionWidget(
            title: 'Filmler',
            items: [
              'assets/images/batmandarkknight.jpg',
              'assets/images/fightclub.jpg',
              'assets/images/harrypotter.jpg',
              'assets/images/maske.jpg',
            ],
            names: [
              'Batman: Dark Knight',
              'Fight Club',
              'Harry Potter',
              'Maske',
            ],
          ),
          SizedBox(height: 8),
          SectionWidget(
            title: 'Animeler',
            items: [
              'assets/images/onepunchman.jpg',
              'assets/images/beyblade.jpg',
              'assets/images/pokemon.jpg',
              'assets/images/yugioh.jpg',
            ],
            names: [
              'One Punch Man',
              'Beyblade',
              'Pokemon',
              'Yu-Gi-Oh!',
            ],
          ),
        ],
      ),
    );
  }
}

class SectionWidget extends StatelessWidget {
  final String title;
  final List<String> items;
  final List<String> names;

  SectionWidget({required this.title, required this.items, required this.names});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
        Column(
          children: List.generate((items.length / 2).ceil(), (index) {
            int firstIndex = index * 2;
            int secondIndex = firstIndex + 1;
            return Row(
              children: <Widget>[
                Expanded(
                  child: CardWidget(
                    imagePath: items[firstIndex],
                    title: names[firstIndex],
                    onTap: () {
                      if (names[firstIndex] == 'Arrow') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ContentPage()),
                        );
                      }
                    },
                  ),
                ),
                if (secondIndex < items.length)
                  Expanded(
                    child: CardWidget(
                      imagePath: items[secondIndex],
                      title: names[secondIndex],
                      onTap: () {
                        if (names[secondIndex] == 'Arrow') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ContentPage()),
                          );
                        }
                      },
                    ),
                  ),
              ],
            );
          }),
        ),
      ],
    );
  }
}

class CardWidget extends StatelessWidget {
  final String imagePath;
  final String title;
  final VoidCallback? onTap; // Tıklama işlevi ekledim

  CardWidget({required this.imagePath, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: <Widget>[
            Card(
              color: Colors.black,
              elevation: 0,
              margin: EdgeInsets.zero,
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 140,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LibraryPage extends StatefulWidget {
  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  String selectedCategory = 'Diziler';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'iyi seyirler :)',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
        actions: [
          DropdownButton<String>(
            value: selectedCategory,
            icon: Icon(Icons.arrow_downward, color: Colors.white),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.white),
            dropdownColor: Colors.black,
            underline: Container(
              height: 2,
              color: Colors.white,
            ),
            onChanged: (String? newValue) {
              setState(() {
                selectedCategory = newValue!;
              });
            },
            items: <String>['Diziler', 'Filmler', 'Animeler']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 2.0,
          mainAxisSpacing: 2.0,
          childAspectRatio: 0.7,
          children: _buildGridItems(selectedCategory),
        ),
      ),
    );
  }

  List<Widget> _buildGridItems(String category) {
    List<String> items = [];
    List<String> names = [];

    switch (category) {
      case 'Diziler':
        items = [
          'assets/images/arrow.jpg',
          'assets/images/breakingbad.jpg',
          'assets/images/theboys.jpg',
          'assets/images/theflash.jpg',
          'assets/images/twd.jpg',
          'assets/images/friends.jpg',
          'assets/images/gibi.jpg',
          'assets/images/himym.jpg',
          'assets/images/supernatural.jpg',
          'assets/images/gameofthrones.jpg',
          'assets/images/leylailemecnun.jpg',
          'assets/images/prens.jpg',
          'assets/images/punisher.jpg',
          'assets/images/strangerthings.jpg',
          'assets/images/vikings.jpg',
        ];
        names = [
          'Arrow',
          'Breaking Bad',
          'The Boys',
          'The Flash',
          'The Walking Dead',
          'Friends',
          'Gibi',
          'How I Met Your Mother',
          'Supernatural',
          'Game of Thrones',
          'Leyla ile Mecnun',
          'Prens',
          'Punisher',
          'Stranger Things',
          'Vikings',
          'Breaking Bad',
          'The Boys',
        ];
        break;
      case 'Filmler':
        items = [
          'assets/images/batmandarkknight.jpg',
          'assets/images/fightclub.jpg',
          'assets/images/harrypotter.jpg',
          'assets/images/maske.jpg',
          'assets/images/forestgump.jpg',
          'assets/images/g.jpg',
          'assets/images/godfather.jpg',
          'assets/images/interstellar.jpg',
          'assets/images/ironman.jpg',
          'assets/images/matrix.jpg',
          'assets/images/memento.jpg',
          'assets/images/pianist.jpg',
          'assets/images/spiderman.jpg',
          'assets/images/ye.jpg',
          'assets/images/yesilyol.jpg',
        ];
        names = [
          'Batman: Dark Knight',
          'Fight Club',
          'Harry Potter',
          'Maske',
          'forestgump',
          'Gladyatör',
          'God Father',
          'Intersteller',
          'Ironmam',
          'Matrix',
          'Memento',
          'Pianist',
          'Spiderman',
          'Yüzüklerin Efendisi',
          'Yeşil Yol',
        ];
        break;
      case 'Animeler':
        items = [
          'assets/images/onepunchman.jpg',
          'assets/images/beyblade.jpg',
          'assets/images/pokemon.jpg',
          'assets/images/yugioh.jpg',
          'assets/images/91day.jpg',
          'assets/images/avatar.jpg',
          'assets/images/barakamon.jpg',
          'assets/images/cowboybebob.jpg',
          'assets/images/deathnote.jpg',
          'assets/images/deathparade.jpg',
          'assets/images/goku.jpg',
          'assets/images/naruto.jpg',
          'assets/images/onepiece.jpg',
          'assets/images/steinsgate.jpg',
          'assets/images/forestofpiano.jpg',
        ];
        names = [
          'One Punch Man',
          'Beyblade',
          'Pokemon',
          'Yu-Gi-Oh!',
          '91 Day',
          'Avatar',
          'Barakamon',
          'Cowboy Bebob',
          'Death Note',
          'Death Parade',
          'Goku',
          'Naruto',
          'One Piece',
          'Steinsgate',
          'Forest of Piano',
        ];
        break;
    }

    return List.generate(items.length, (index) {
      return GestureDetector(
        onTap: () {
          if (index == 0) { // İlk karta tıklanma kontrolü
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ContentPage()),
            );
          }
        },
        child: CardWidget(
          imagePath: items[index],
          title: names[index],
        ),
      );
    });
  }
}


class Profile extends StatelessWidget {
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
        title: Text('Profil', style: TextStyle(color: Colors.white)),
        // Profile sayfasındaki çıkış ikonunu kaldırdık
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
                  title: Text('Şifeyi Değiştir', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.of(context).pushNamed('/account_settings');  // Navigasyon yönlendirme
                  },
                ),
                ListTile(
                  title: Text('Beğenilerler ❤️', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LikesPage()),
                    );
                  },
                ),
                ListTile(
                  title: Text('Çıkış Yap', style: TextStyle(color: Colors.red)),
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
