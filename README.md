# Food Flag

<div style="display: flex; justify-content: center;">
  <img src="https://i.imgur.com/3ouvD7f.png" alt="Food Flag Logo" width="200" height="200">
</div>

Food Flag is an app that aims to connect between Food Donors and receivers. Here someone willing to
Donate a meal can hoist a flag at his location, this flag is broadcast in the app and any one in the app can
claim that meal by clicking on that marker. This reserves the meal for him, he can then go to the location
of the marker or call the flags owner for any updated location and collect the meal.

## Team Members
- **Joby John**: [joby432john@gmail.com](mailto:joby432john@gmail.com)
- **Gijin**: [gtg8783@gmail.com](mailto:gtg8783@gmail.com)
- **Ajay**: [ajayanilsree@gmail.com](mailto:ajayanilsree@gmail.com)

## Initial Survey and Problem Statement

The inspiration came from real life situation where I noticed a father in dilemma to either buy his daughter's medicine or to eat that day with remaining 100 rupees in his hand. In an initial survey we conducted we were able to find out that almost 7 out of 10 people were ready to donate a meal for hungry people. Another 15% were interested in only donating during special occasions like marriages and birthdays. But they all reported the difficulty in finding people who are hungry. Likewise in a survey conducted among daily wage workers and other people, they also faced a similar question of whom to ask, also somewhere not willing to ask because of self-esteem. The Food Flag here mitigates the big who question of both sides by connecting both groups through its easy-to-use interface.

### Public Opinion

In an in-person review with multiple people they pointed out one major feature of the current app which is in the development phase, that was currently the app only focused on homemade meal, not everyone cooks, so there should be a feature for those who don't cook also. Based on that suggestion we came up with restaurant donations, in which a person can hoist a fixed priced meal at a restaurant which others can claim anything from that restaurant for that amount.

## Features

### 📱 Hoisting a Flag

#### Donors
Donors can hoist a flag by selecting the type of meal they want to donate and clicking on the "Raise a Flag" button. For homemade meals, it's a two-click process, while for restaurant flags, the user can ask any registered restaurant to initialize a flag for a certain amount after paying the restaurant. After initializing a flag, the restaurant side will show a generated QR code which the user can then scan to raise the flag at that location.

#### Receivers
Receivers can claim a flag by clicking on the marker displayed on the map. If it's a self-raised flag, it shows "Delete", if not then shows "Confirm".

#### Restaurants
Restaurants can participate in the Food Flag program by initializing flags for fixed priced meals.

### 📍 Markers

Markers are clickable to only the signed-in users, denied for restaurants. If it's a self-raised flag, it shows "Delete", if not then shows "Confirm".

### 📊 Dashboard

Here a user can verify the code of the presented to verify its authenticity, also dashboard displays other statistics like Total donated, flying flags, and Running Flags.

### 📝 Signing Up

For signup, one must provide their name and phone number. For restaurant signup, we ask for details like FSSAI, PAN, restaurant name, and phone number.

### 🔄 Caught Flag

Caught flag shows information of the caught flag including the code, it also has buttons like delete, directions, and call, whose functions are self-explanatory.

## How to Use

### For Donors

1. Sign up with your name and phone number.
2. Hoist a flag by selecting the type of meal you want to donate and clicking on the "Raise a Flag" button.
3. For homemade meals, it's a two-click process, while for restaurant flags, ask any registered restaurant to initialize a flag for a certain amount after paying the restaurant.
4. Wait for a receiver to claim your flag.

### For Receivers

1. Sign up with your name and phone number.
2. Look for available flags on the map.
3. Click on a marker to claim a flag.
4. If it's a self-raised flag, you'll see options to delete or confirm.

### For Restaurants

1. Sign up with your restaurant details including FSSAI, PAN, name, and phone number.
2. Initialize flags for fixed priced meals.
3. Wait for users to claim your flags.

## Prerequisites

Before you start, make sure you have installed the following on your system:

- Flutter SDK
- VS Code
- Dart and Flutter extensions for VS Code
- Android emulator or physical device

You may want a Google Maps API key if using maps in your IDE. For environment variables, contact [joby432john@gmail.com](mailto:joby432john@gmail.com).

## Installation

1. Clone the Food Flag repository from GitHub: https://github.com/Joby-John/Food-Flag.git

2. Open the project folder in VS Code.

3. In VS Code, open the command palette (View > Command Palette) and type "Flutter: Run Flutter Doctor". This will check your system to make sure everything is set up correctly.

4. In VS Code, open the main.dart file and click the "Run" button. This will launch the app in the emulator or on your physical device.

## Contributing

If you would like to contribute to the Food Flag project, please fork the project on GitHub and submit a pull request.

## License

Food Flag is licensed under the MIT license. See [LICENSE.txt](LICENSE.txt) for more information.
