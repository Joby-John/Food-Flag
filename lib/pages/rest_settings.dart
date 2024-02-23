import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_button/sign_in_button.dart';

import '../services/auth.dart';
import '../services/createuserdoc.dart';

class Restaurant_Settings extends StatefulWidget {
  const Restaurant_Settings({super.key});

  @override
  State<Restaurant_Settings> createState() => _Restaurant_SettingsState();
}

class _Restaurant_SettingsState extends State<Restaurant_Settings> {
  late TextEditingController _upiIdController;
  late TextEditingController _fssaiNumberController;
  late TextEditingController _panController;
  late TextEditingController _phoneController;
  late TextEditingController _nameController;
  bool _areFieldsValid = false;


  String UPIid = '';
  String fssai = '';
  String pan = '';
  String phone = '';
  String name = '';

  final _formKey = GlobalKey<FormState>(); // Form key for validation


  @override
  void initState() {
    super.initState();
    _upiIdController = TextEditingController();
    _fssaiNumberController = TextEditingController();
    _panController = TextEditingController();
    _phoneController = TextEditingController();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _upiIdController.dispose();
    _fssaiNumberController.dispose();
    _panController.dispose();
    _phoneController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 55, 135, 112),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Restaurant Sign Up",
          style: GoogleFonts.marcellus(
              textStyle: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54)),
        ),
        backgroundColor: Color.fromARGB(255, 46, 204, 113),
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
                  if (user?.email == null&&!_areFieldsValid) ...[
                    _buildTextField("Name", _nameController),
                    _buildTextField("UPI ID", _upiIdController),
                    _buildTextField("FSSAI Number", _fssaiNumberController),
                    _buildTextField("PAN", _panController),
                    _buildTextField("Phone", _phoneController),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _areFieldsValid = true;
                          });
                          // Request focus to the sign-in button
                        }
                      },
                      child: Text('Submit and Sign Up with Google'),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      "The name should match with the name in FSSAI licence",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                      ),
                    )
                  ],

                  if (user?.email != null || _areFieldsValid ) ...[
                    SizedBox(height: 70,),
                    Row(
                      children: [
                        const Icon(Icons.restaurant, color: Colors.blue, size: 37),
                        const Expanded(
                          child: Text(
                            "Restaurant: ",
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
          style : GoogleFonts.marcellus(
            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white70,
                shadows:[Shadow(blurRadius: 5.0, color: Colors.black, offset: Offset(0,0))]
            ),
          ),
          ),
        TextFormField(
          style: TextStyle(color: Colors.white),
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),

            ),
            hintText: "Enter $label",
            hintStyle: TextStyle(color: Colors.white)
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter $label';
            }
            // Validate that the restaurant ID is less than 6 characters alphanumeric
            if (label == "UPI ID") {
              if (value.isEmpty) {
                return 'UPI ID is required';
              }
              if (value.length > 50) {
                return 'UPI ID must be less than 50 characters';
              }
              if (!RegExp(r'^[a-zA-Z0-9@.-_]+$').hasMatch(value)) {
                return 'UPI ID must contain only alphanumeric characters and special characters (@, ., - and _)';
              }
            }


            // Validate FSSAI Number
            if (label == "FSSAI Number") {
              if (value.length != 14) {
                return 'FSSAI Number must be a 14-digit number';
              }
              if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                return 'FSSAI Number must contain only digits';
              }
            }
            // Validate Phone Number
            if (label == "Phone") {
              if (value.length != 10) {
                return 'Phone number must be a 10-digit number';
              }
              if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                return 'Phone number must contain only digits';
              }
            }

            return null;
          },
          onChanged: (value) {
            // Update the respective variable based on the text field
            switch (label) {
              case "UPI ID":
                UPIid = value;
                break;
              case "FSSAI Number":
                fssai = value;
                break;
              case "PAN":
                pan = value;
                break;
              case "Phone":
                phone = value;
                break;
              case "Name":
                name = value;
                break;
              default:
                break;
            }
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
    FirebaseFirestore.instance.collection('restaurants').doc(user?.uid).get().then((DocumentSnapshot snapshot) {
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

    const SizedBox(height: 160),
    const Text(
    "Not your Restaurant account! hmm. You might want to logout from your individual account first",)
      ],
    );
  }



  Future<void> signIn(context, String name) async {
    await Provider.of<AuthState>(context, listen: false).googleSignIn(context);
    print('$name, $UPIid, $fssai, $pan, $phone');

    // Check if the user's UID exists in the "users" collection
    final authState = Provider.of<AuthState>(context, listen: false);
    final user = authState.currentUser;
    bool userExists = await UserService.checkUserExists(user?.uid);

    if (userExists) {
      // User already exists, prompt to log in with a different account
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Account already in use for individual'),
            content: Text('Please log in with a different account.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // User does not exist, proceed with creating the user document
      await RestaurantService.signInAndCreateRestaurantDocument(context, name, UPIid, fssai, pan, phone);
    }
  }

}
