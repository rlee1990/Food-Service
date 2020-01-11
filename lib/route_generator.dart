
import 'package:flutter/material.dart';
import 'package:food_dev/Pages/food_item_details.dart';
import 'package:food_dev/Pages/food_menu_overview.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => FoodMenuOverview());
      case '/foodItem':
        if (args is String) {
          return MaterialPageRoute(builder: (_) => FoodItemDetails());
        }
          return _errorRoute(settings.name);
      // case '/signup':
      //   return MaterialPageRoute(builder: (_) => SignUp());
      // case '/editProfile':
      //   if (args is User) {
      //     return MaterialPageRoute(builder: (_) => EditProfile(user: args,));
      //   }
      //   return _errorRoute(settings.name);
      // case '/editPhotos':
      //   if (args is String) {
      //     return MaterialPageRoute(builder: (_) => EditPhotos(uid: args,));
      //   }
      //   return _errorRoute(settings.name);
      // case '/makeDefaultPhoto':
      //   if (args is PhotoModel) {
      //     return MaterialPageRoute(builder: (_) => MakeProfilePhoto(imageModel: args,));
      //   }
      //   return _errorRoute(settings.name);
      // case '/viewImage':
      //   if (args is PhotoModel) {
      //     return MaterialPageRoute(builder: (_) => ViewImage(imageModel: args,));
      //   }
      //   return _errorRoute(settings.name);
      // case '/galleryView':
      //   if (args is List<PhotoModel>) {
      //     return MaterialPageRoute(builder: (_) => ImageGallery(photos: args,));
      //   }
      //   return _errorRoute(settings.name);
      default:
        return _errorRoute(settings.name);
    }
  }

  static Route<dynamic> _errorRoute(String name) {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('Error could not find $name'),
        ),
      );
    });
  }
}