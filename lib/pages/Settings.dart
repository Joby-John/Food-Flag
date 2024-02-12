import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:FoodFlag/services/auth.dart';
import 'package:FoodFlag/services/createdoc.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

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
                          : _IndividualSignInButton(context), // Pass context here
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                _userInfo(user),
                const SizedBox(height: 70,),
                Row(
                  children: [
                    const Icon(Icons.restaurant, color: Colors.blue, size: 37),
                    const Expanded(
                      child: Text(
                        "Restaurant                  ",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    Expanded(
                      child: _RestaurantSignInButton(),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Sign in with Google and create user document
  Future<void> signIn(context) async {
    await Provider.of<AuthState>(context, listen: false).googleSignIn();
    await UserService.signInAndCreateUserDocument(context);
  }

  // Widget for individual sign-in button
  Widget _IndividualSignInButton(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 33,
        width: 120,
        child: SignInButton(
          Buttons.google,
          text: "Google",
          onPressed: () {
            signIn(context);
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
            Provider.of<AuthState>(context, listen: false).signOut();
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  // Widget for restaurant sign-in button
  Widget _RestaurantSignInButton() {
    return Center(
      child: SizedBox(
        height: 33,
        width: 120,
        child: SignInButton(
          Buttons.anonymous,
          text: "Sign in",
          onPressed: () {},
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  // Widget to display user information
  Widget _userInfo(User? user) {
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
        Text(user?.displayName ?? ""),
      ],
    );
  }
}