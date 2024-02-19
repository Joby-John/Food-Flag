import 'package:FoodFlag/pages/user_settings.dart';
import 'package:FoodFlag/pages/caught_flag.dart';
import 'package:FoodFlag/pages/hoist_page.dart';
import 'package:FoodFlag/pages/home_page.dart';
import 'package:FoodFlag/pages/map_page.dart';
import 'package:FoodFlag/pages/rest_settings.dart';

var Approutes =
{
  '/settingspage': (context) =>Settings(),
  '/restsettings': (context)=> Restaurant_Settings(),
  '/hoistpage': (context)=>const Hoist(),
  '/caughtpage': (context)=>Caughtflag(),
  '/mappage': (context)=>MapPage(),
  '/home': (context)=>Home(),
};