

import 'package:FoodFlag/pages/upi.dart';
import 'package:FoodFlag/pages/login_signup.dart';
import 'package:FoodFlag/pages/caught_flag.dart';
import 'package:FoodFlag/pages/hoist_page.dart';
import 'package:FoodFlag/pages/home_page.dart';
import 'package:FoodFlag/pages/map_page.dart';
import 'package:FoodFlag/pages/rest_settings.dart';
import 'package:FoodFlag/pages/pay.dart';
import 'package:FoodFlag/pages/userQr.dart';
import 'package:FoodFlag/pages/rest_qr_scan_page.dart';
import 'package:FoodFlag/pages/user_signup.dart';

var Approutes =
{
  '/LoginSignupPage': (context) =>LoginSignup(),
  '/restsettings': (context)=> Restaurant_Settings(),
  '/hoistpage': (context)=>const Hoist(),
  '/caughtpage': (context)=>Caughtflag(),
  '/mappage': (context)=>MapPage(),
  '/home': (context)=>Home(),
  '/payNraise':(context)=> const PayNRaise(),
  '/displayUserQr':(context) => const DisplayQr(),
  '/scanQr':(context) => const QrScan(),
  '/userSignupPage':(context) => UserSignUp(),
};