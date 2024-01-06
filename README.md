# Food Flag

Welcome to the Food Flag app repository! Our Flutter-based mobile app aims to revolutionize the donation and delivery of high-quality meals.
Whether you're an individual, institution, religious place, or event host (like Bob), or someone looking for a meal (like Jennie), this app brings the community together for a good cause.

## Bob (Donor)

Bob, as a donor, has the power to raise a "food flag" on the app when there's a meal available for donation. Here's how it works:

1. **Raise a Food Flag:**
   - Bob, whether an institution, religious place, or individual, can raise a food flag on the app when there's food for donation.
   - The flag is broadcasted to app users within a 5 km radius (or a distance specified by Bob).

2. **Claiming a Meal:**
   - App users within the radius can spot the food flag and contact Bob to claim the meal.
   - After successful verification through a call, a timer begins for the claimant (Jennie).

3. **Timer Mechanism:**
   - The timer is set at the average travel time from Jennie's location to Bob's, plus an additional 10 minutes.
   - If Jennie fails to arrive within this timeframe, Bob can re-hoist the flag, nullifying Jennie's claim.

## Jennie (Claimant)

Jennie, as a claimant, has the opportunity to benefit from donated meals. Here's her journey with the Food Flag App:

1. **Spotting a Food Flag:**
   - Jennie can explore the app's map, where various flags represent available meals in specific areas.

2. **Claiming a Meal:**
   - After spotting a flag, Jennie can choose it, specifying the type and quantity of meals she wishes to claim.

3. **Verification and Collection:**
   - After confirmation, Jennie contacts the donor (Bob) for verification and proceeds to collect her chosen meal.

4. **Real-time Tracking:**
   - The app features real-time tracking for claimed meals, ensuring a smooth process.

## App Features

The Food Flag App boasts a user-friendly interface, built with the Flutter framework, Google Maps API, and Firebase. Here are the key features:

- **Hamburger Menu:**
  - Explore the app's options through the left-side hamburger menu.

- **Flag Hoisting:**
  - Donors, like Bob, can hoist a flag to indicate available meals for donation.

- **Search for Flags:**
  - Users can search for flags on the map, each representing a donation in a specific area.

- **Meal Selection:**
  - Users can choose any flag, specify the type and quantity of meals they wish to claim, and proceed to contact the donor for verification.

- **Real-time Tracking:**
  - The app features real-time tracking for claimed meals, ensuring a smooth process.

## Installation

### Prerequisites

- Flutter installed
- Firebase project set up with Firestore and Authentication configured
- Google Maps API key

### Steps

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/food-flag.git
   ```

2. **Navigate to the project directory:**
   ```bash
   cd food-flag
   ```

3. **Install dependencies:**
   ```bash
   flutter pub get
   ```

4. **Set up environment variables:**
   - Create a .env file with your Google Maps API key.

5. **Run the app:**
   ```bash
   flutter run
   ```
## License

This project is licensed under the [MIT License](LICENSE).

