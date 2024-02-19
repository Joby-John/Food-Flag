import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:FoodFlag/services/auth.dart';
import 'package:FoodFlag/services/createuserdoc.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final TextEditingController _nameController = TextEditingController();
  String name = ''; // Initialize the name variable
  bool _isNameSubmitted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 236, 252, 252),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Settings",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Consumer<AuthState>(
        builder: (context, authState, child) {
          User? user = authState.currentUser;
          return Container(
            padding: const EdgeInsets.all(10),
            child: ListView(
              children: [
                const SizedBox(height: 40),
                if (!_isNameSubmitted&&user?.email==null) ...[
                  _buildNameField(),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      String enteredName = _nameController.text.trim();
                      if (enteredName.isNotEmpty) {
                        setState(() {
                          name = enteredName; // Update the value of name
                          _isNameSubmitted = true;
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please enter your name')),
                        );
                      }
                    },
                    child: Text('Submit Name and Sign In with Google'),
                  ),
                ],

                if (user?.email!=null||_isNameSubmitted) ...[
                  Row(
                    children: [
                      const Icon(Icons.person, color: Colors.blue, size: 37),
                      const Expanded(
                        child: Text(
                          "Sign Up/ Log In: ",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      Expanded(
                        child: user != null
                            ? _IndividualSignOutButton(context)
                            : _IndividualSignInButton(context, name), // Pass context here
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  _userInfo(user),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNameField() {
    return TextField(
      controller: _nameController,
      decoration: const InputDecoration(
        hintText: 'Once set, you wont be able to change this',
        labelText: 'Name',
      ),
    );
  }


  // Sign in with Google and create user document
  Future<void> signIn(context, String name) async {
    await Provider.of<AuthState>(context, listen: false).googleSignIn(context);
    await UserService.signInAndCreateUserDocument(context, name);
  }

  // Widget for individual sign-in button
  Widget _IndividualSignInButton(BuildContext context, String name) {
    return Center(
      child: SizedBox(
        height: 33,
        width: 120,
        child: SignInButton(
          Buttons.google,
          text: "Google",
          onPressed: () {
            signIn(context, name);
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  // Widget for individual sign-out button
  Widget _IndividualSignOutButton(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 33,
        width: 120,
        child: SignInButton(
          Buttons.googleDark,
          text: "Sign Out",
          onPressed: () {
            Provider.of<AuthState>(context, listen: false).signOut(context);
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  // Widget to display user information
  Widget _userInfo(User? user) {
    FirebaseFirestore.instance.collection('users').doc(user?.uid).get().then((DocumentSnapshot snapshot){
      if (snapshot.exists) {
        // Access the 'name' field from the document snapshot
        String userName = snapshot['name'];

        // Now you can use userName variable to display the name
        setState(() {
          name = userName;
        });
      } else {
        print('Document does not exist on the database');
      }
    }).catchError((error) {
      print('Error getting document: $error');
    });
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (user != null)
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(user.photoURL ?? ""),
              ),
            ),
          ),

        Text(user?.email ?? "Not Signed In"),
        Text(name?? ""),

        const SizedBox(height: 200),
        const Text(
          "Restaurants Should Create account in Restaurant Sign Up Section before trying to log in",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.redAccent,
          ),
        )
      ],
    );
  }
}
