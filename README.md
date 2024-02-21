# Food Flag

Welcome to the Food Flag app repository! Our Flutter-based mobile app aims to revolutionize the donation and delivery of high-quality meals. Whether you're an individual, institution, religious place, or event host (like Bob), or someone looking for a meal (like Jennie), this app brings the community together for a good cause.

## Team Members
- **Joby John**: [joby432john@gmail.com](mailto:joby432john@gmail.com)
- **Gijin**
- **Ajay**: [ajayanilsree@gmail.com](mailto:ajayanilsree@gmail.com)

## Bob (Donor)

Bob, as a donor, has the power to raise a "food flag" on the app when there's a meal available for donation. Here's how it works:

### Raise a Food Flag:

Bob, whether an institution, religious place, or individual, can raise a food flag on the app when there's food for donation.
The flag is broadcast to app users within a 5 km radius (or a distance specified by Bob - *In development stage*).
### Claiming a Meal:

App users within the radius can spot the food flag and contact Bob to claim the meal.
Meal is verified only if the code provided by Jennie matches the original code.
### Timer Mechanism: (*In development stage*)

The timer is set at the average travel time from Jennie's location to Bob's, plus an additional 10 minutes.
If Jennie fails to arrive within this timeframe, Bob can re-hoist the flag, nullifying Jennie's claim.

## Jennie (Claimant)

Jennie, as a claimant, has the opportunity to benefit from donated meals. Here's her journey with the Food Flag App:

### Spotting a Food Flag:

Jennie can explore the app's map, where various flags represent available meals in specific areas.
### Claiming a Meal:

After spotting a flag, Jennie can choose it, it is then removed from flag and moved to Jennie's caught flag section.
### Verification and Collection:

After confirmation, Jennie is provided with Bob's phone number, then she proceeds to collect her chosen meal at the given location.
### Real-time Tracking:

The app features real-time tracking for claimed meals, ensuring a smooth process.

## App Features

The Food Flag App boasts a user-friendly interface, built with the Flutter framework, Google Maps API, and Firebase. Here are the key features:

### Hamburger Menu:

Explore the app's options through the left-side hamburger menu.
### For Individuals:

Its a section divider that contains some feature reserved for Individuals only (Hoist, caught, SignUp), like wise contain other features common for restaurants as well, Dashboard can be used by both while in login/signup sinup is only for Individuals but restaurants and Individuals can use it for login.
### Hoist Flag:

Donors, like Bob, can hoist a flag to indicate available meals for donation. Just select veg or non-veg and press hoist its that simple flag will be hoisted at your current location.
### Under development feature:

For the majority who doesn't cook, can raise flags from a restaurant, just by entering the 5 character restaurant code and scanning the UPI code in the restaurant and paying the sum which you wish to donate for a meal, this raises a flag at that location with that specified amount, which any other needed person can redeem at that restaurant or shop. In this case phone number and such details are not shared, the details that are going to share will be about the restaurant only.
Only logged-in users can raise a flag.
### Dashboard:

For a personal user This displays his donated status, which is the number of meals he has donated till the moment. In here verification is also provided where a Donor can verify the code provided by the claimant. Also, displays other details like flying flags (flags still present on the map) and running flags (Flags caught but yet to claim).
### Caught Flag:

Any user can only have a single flag at his caught flag section, to catch more you have to either claim the previous flag or delete it from your account, allowing others to claim it, deleted flags in this section reappear on the map.
### Login/Signup:

Here users can log in or sign up while restaurants also log in here.
### For Restaurants:

All items below this section are for restaurants only.
### Restaurant Sign up:

here the restaurants fill in the relevant details like restaurant name, restaurant id, FSSAI number, PAN number, and phone number and signup. Restaurants Signup and registration are mandatory for any restaurant to be present in the platform, this prevents the user from raising random flags at unregistered restaurants, also donors can verify the authenticity of the flag by checking the location and name for a match.
### Verifier:

On the top there will be a text field where the restaurant account can enter the secret code presented by the claimant to verify its authenticity and details,
Also, Here the restaurants will have requests from the donators to verify the flag creation, so that no user can enter the restaurant id and scan a random UPI and perform fraud, only the
 verified flags will be hoisted in the map.
### Real-time Tracking:

The app features real-time tracking for claimed meals, ensuring a smooth process.
### The Map:

Map continuously updates markers using a refresh button and any signed-in "Individual" can claim a flag and on click on any marker it will reveal its properties like veg/ non-veg, amount etc.

## Installation

### Prerequisites

- Flutter installed
- Dart installed
- Android Studio
- Firebase project set up with Firestore and Authentication configured
- Google Maps API key

### Steps

1. Clone the repository:
   ```
   git clone https://github.com/Joby-John/Food-Flag.git
   ```
2. Navigate to the project directory:
   ```
   cd Food-Flag
   ```
3. Install dependencies:
   ```
   flutter pub get
   ```
4. Set up environment variables:
   - For environment variables like API key, you can contact.
   - Set local.properties file on the android folder with the Google Maps API key.
5. Run the app:
   ```
   flutter run
   ```

## License

This project is licensed under the [MIT License].