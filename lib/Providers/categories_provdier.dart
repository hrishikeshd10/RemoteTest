import 'package:flutter/cupertino.dart';
import 'package:my_neighbourhood_online/Networking/api_provider.dart';
import 'package:my_neighbourhood_online/api_response_model/categories_response.dart';

class CategoriesProvider extends ChangeNotifier {
  CategoriesResponse categoriesResponse;
  String categoryResponseBody;

  String get categoriesResponseBody {
    return categoriesResponseBody;
  }

  CategoriesStatus fetchCategoryStatus = CategoriesStatus.NONE;

  void getCategoeiesApicall(BuildContext context) async {
    String url = "getcategory";
    //TODO: Set connection to loading
    setCategoriesStatus(CategoriesStatus.LOADING);
    try {
      var response = await ApiProvider().get(url);
      print(response.body.toString());
      String responseString = response.toString();
      //TOdo: SET the response for categories
      if (responseString.contains("InternetConnectionError")) {
        setCategoriesStatus(CategoriesStatus.INTERNET_ERROR);
      } else if (responseString.contains("Error ")) {
        setCategoriesStatus(CategoriesStatus.UNKOWN_ERROR);
      } else {
        setCategoriesStatus(CategoriesStatus.DONE);
        setCategoriesResponseBody(response.body);
        setCategoriesListResponse(response.body);
      }
    } catch (e) {}
  }

  //TODO: make functions to set all th processes;

  void setCategoriesStatus(CategoriesStatus catStatus) {
    fetchCategoryStatus = catStatus;
    notifyListeners();
  }

  void setCategoriesResponseBody(String body) {
    categoryResponseBody = body;
    notifyListeners();
  }

  void setCategoriesListResponse(String body) {
    categoriesResponse = categoriesResponseFromJson(body);
    notifyListeners();
  }
}

enum CategoriesStatus {
  LOADING,
  INTERNET_ERROR,
  DONE,
  NONE,
  UNKOWN_ERROR,
}
