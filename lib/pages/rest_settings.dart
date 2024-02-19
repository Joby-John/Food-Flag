import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_button/sign_in_button.dart';

import '../services/auth.dart';

class Restaurant_Settings extends StatefulWidget {
  const Restaurant_Settings({super.key});

  @override
  State<Restaurant_Settings> createState() => _Restaurant_SettingsState();
}

class _Restaurant_SettingsState extends State<Restaurant_Settings> {
  late TextEditingController _restaurantIdController;
  late TextEditingController _fssaiNumberController;
  late TextEditingController _panController;
  late TextEditingController _phoneController;
  late TextEditingController _nameController;

  bool _isNameSubmitted = false;
  bool _isRIDSubmitted = false;
  bool _isFSSAISubmitted = false;
  bool _isPANSubmitted = false;
  bool _isPhoneSubmitted = false;

  String name = '';

  final _formKey = GlobalKey<FormState>(); // Form key for validation

  @override
  void initState() {
    super.initState();
    _restaurantIdController = TextEditingController();
    _fssaiNumberController = TextEditingController();
    _panController = TextEditingController();
    _phoneController = TextEditingController();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _restaurantIdController.dispose();
    _fssaiNumberController.dispose();
    _panController.dispose();
    _phoneController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 236, 252, 252),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Restaurant Settings",
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
          User? user = authState?.currentUser;
          return Container(
            padding: const EdgeInsets.all(10),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  const SizedBox(height: 40),
                  if (!_isNameSubmitted && user?.email == null) ...[
                    _buildTextField("Name", _nameController),
                    _buildTextField("Restaurant ID", _restaurantIdController),
                    _buildTextField("FSSAI Number", _fssaiNumberController),
                    _buildTextField("PAN", _panController),
                    _buildTextField("Phone", _phoneController),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          String enteredName = _nameController.text.trim();
                          setState(() {
                            name = enteredName;
                            _isNameSubmitted = true;
                          });
                        }
                      },
                      child: Text('Submit Name and Sign In with Google'),
                    ),
                    const SizedBox(height: 120),
                    const Text(
                      "For restaurants, the name should match with the name in FSSAI licence",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                      ),
                    )
                  ],
                  if (user?.email != null || _isNameSubmitted) ...[
                    Row(
                      children: [
                        const Icon(Icons.person, color: Colors.blue, size: 37),
                        const Expanded(
                          child: Text(
                            "Individual: ",
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
                              : _IndividualSignInButton(context, name),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    _userInfo(user),
                    const SizedBox(height: 70),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Enter $label",
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter $label';
            }
            return null;
          },
        ),
      ],
    );
  }

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
    FirebaseFirestore.instance.collection('users').doc(user?.uid).get().then((DocumentSnapshot snapshot) {
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
        Text(name ?? ""),
      ],
    );
  }

  void signIn(BuildContext context, String name) {
    // Implement sign in logic here
  }
}
