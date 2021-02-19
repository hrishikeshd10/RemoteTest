import 'package:my_neighbourhood_online/api_response_model/get_properties_response.dart';

class SPKeys {
  static const String userID = 'userID';
  static const String firstName = 'firstName';
  static const String lastName = "lastName";
  static const String userEmail = 'userEmail';
  static const String userContact = "userContact";
  static const String profileImageURL = "profileImageURL";
  static const String location = "lcoation";
  static const String loginMethod = "LoginMethod";
  static const String gender = "gender";
  static const String notificationList = 'notificationList';
}

class GlobalUserDetails {
  static int userID;
  static String userName = 'userName';
  static String userEmail = 'userEmail';
  static int userContact;
  static String profileImageURL = "profileImageURL";
  static bool newNotification = false;
}

class AllProperties {
  static List<Data> allProperties = [];
  static List searchMatchList = [];
  static List<int> favouritePropertiesID = [];

  static bool checkFavouritesAvailability(int propertyID) =>
      favouritePropertiesID.contains(propertyID);
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

enum LoginMethod { API_LOGIN, GOOGLE_LOGIN, FACEBOOK_LOGIN }
