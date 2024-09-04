import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AccountSettingsPage extends StatefulWidget {
  @override
  _AccountSettingsPageState createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  Future<void> _updateProfile() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        // Firestore'da kullanıcı bilgilerini güncelle
        await _firestore.collection('users').doc(user.uid).update({
          'name': _nameController.text,
          'surname': _surnameController.text,
          'email': _emailController.text,
        });

        // Firebase Authentication'da e-posta güncelle
        if (_emailController.text != user.email) {
          try {
            await user.updateEmail(_emailController.text);
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error updating email: $e')),
            );
            return; // E-posta güncellemesi başarısızsa işlemi durdur
          }
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile: $e')),
        );
      }
    }
  }

  Future<void> _changePassword() async {
    User? user = _auth.currentUser;
    if (user != null && _newPasswordController.text == _confirmPasswordController.text) {
      // Kullanıcının mevcut şifresini doğrulama
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: _currentPasswordController.text,
      );

      try {
        await user.reauthenticateWithCredential(credential);
        await user.updatePassword(_newPasswordController.text);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password changed successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('New passwords do not match')),
      );
    }
  }

  Future<void> _getUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
      var userData = doc.data() as Map<String, dynamic>;

      setState(() {
        _nameController.text = userData['name'];
        _surnameController.text = userData['surname'];
        _emailController.text = userData['email'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Hesap Ayarları', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(
          color: Colors.white, // Geri butonunu beyaz yapmak için
        ),
      ),
      body: Container(
        color: Colors.black,
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SizedBox(height: 40),
            Text('Şifreyi Değiştir', style: TextStyle(fontSize: 20, color: Colors.white)),
            TextField(
              controller: _currentPasswordController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Mevcut Şifre',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              obscureText: true,
            ),
            TextField(
              controller: _newPasswordController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Yeni Şifre',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              obscureText: true,
            ),
            TextField(
              controller: _confirmPasswordController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Yeni Şifreyi Onayla',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _changePassword,
              child: Text('Şifreyi Değiştir'),
            ),
          ],
        ),
      ),
    );
  }
}
