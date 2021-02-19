//TODO: Change the AppStatus to "V" to switch to PRod and "U" to switch to UAT

class AllUrls {
  String uatHost = "https://www.myneighbourhoodonline.com/uat/API2";
  String prodHost = "https://www.myneighbourhoodonline.com/API2";

  String host = '';

  //TODO: Change status to "U" to switch to UAT- "V" to switch to Prod
  final String appStatus = 'U';

  AllUrls() {
    switch (appStatus) {
      case 'U':
        host = uatHost;
        break;
      case 'V':
        host = prodHost;
        break;
      default:
        host = prodHost;
    }
  }

  String get registrationURL => "$host/Registration";
  String get otpVerificationURL => '$host/sendotp';
  String get setPasswordURL => '$host/setpassword';
  String get loginURL => '$host/Login';
  String get getCategoriesURL => '$host/getcategory';
  String get getUserURL => '$host/getuser';
  String get updateUserProfile => '$host/updateuser';
  String get getFavouritesURL => '$host/getfavourite';
  String get listBusinessURL => '$host/business/add';
  String get contactUsURL => '$host/contact_us';
  String get ratingFeedbackURL => '$host/rating_fb';
  String get getPropertiesURL => '$host/get_properties';
  String get addFavouriteURL => '$host/addfavourite';
  String get removeFavouriteURL => '$host/remove/favourites';
  String get forgotPasswordURL => '$host/emailchk';
  String get categoryWisePropertiesAPICall => '$host/get_category_properties';
  String get blogURL => '$host/getblog';
  String get getLocationURL => '$host/getlocation';
  String get setCountURl => '$host/setcount';
  String get socialReguserURL => '$host/google_login';
}
