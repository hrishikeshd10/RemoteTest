import 'dart:async';

import 'package:my_neighbourhood_online/Networking/response_status.dart';
import 'package:my_neighbourhood_online/Repository/categories_repository.dart';
import 'package:my_neighbourhood_online/api_response_model/categories_response.dart';

class ChuckCategoryBloc {
  CategoryResponseRepository _chuckRepository;
  StreamController _chuckListController;

  StreamSink<ResponseStatus<CategoriesResponse>> get chuckListSink =>
      _chuckListController.sink;

  Stream<ResponseStatus<CategoriesResponse>> get chuckListStream =>
      _chuckListController.stream;

  ChuckCategoryBloc() {
    _chuckListController =
        StreamController<ResponseStatus<CategoriesResponse>>();
    _chuckRepository = CategoryResponseRepository();
    fetchCategories();
  }

  fetchCategories() async {
    chuckListSink.add(ResponseStatus.loading('Getting Chuck Categories.'));
    try {
      CategoriesResponse chuckCats =
          await _chuckRepository.fetchChuckCategoryData();
      chuckListSink.add(ResponseStatus.completed(chuckCats));
    } catch (e) {
      chuckListSink.add(ResponseStatus.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _chuckListController?.close();
  }
}
