import 'package:FoodFlag/pages/Settings.dart';
import 'package:FoodFlag/pages/caught_flag.dart';
import 'package:FoodFlag/pages/hoist_page.dart';
import 'package:FoodFlag/pages/home_page.dart';
import 'package:FoodFlag/pages/map_page.dart';
import 'package:FoodFlag/pages/scan.dart';

var Approutes =
{
  '/settingspage': (context) =>Settings(),
  '/scanpage': (context)=> Scan(),
  '/hoistpage': (context)=>const Hoist(),
  '/caughtpage': (context)=>Caughtflag(),
  '/mappage': (context)=>MapPage(),
  '/home': (context)=>Home(),
};