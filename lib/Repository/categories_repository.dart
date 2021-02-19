import 'dart:async';

import 'package:my_neighbourhood_online/Networking/api_provider.dart';
import 'package:my_neighbourhood_online/api_response_model/categories_response.dart';

class CategoryResponseRepository {
  ApiProvider _provider = ApiProvider();

  Future<CategoriesResponse> fetchChuckCategoryData() async {
    final response = await _provider.get("getcategory");
    return CategoriesResponse.fromJson(response);
  }
}
