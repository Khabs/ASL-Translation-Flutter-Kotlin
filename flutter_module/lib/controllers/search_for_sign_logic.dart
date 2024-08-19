import 'package:flutter/material.dart';
import '../models/search_for_sign_model.dart';
import '../models/sign_model.dart';
import '../config/connections.dart';

class SearchForSignLogic {
  final SearchForSignModel _model = SearchForSignModel();

  Future<List<Sign>> searchSigns(
      String searchText, List<String> categories) async {
    print("Controller starting search for:' $searchText '");

    // Check if searchText starts with "cat:" and handle category search
    if (searchText.startsWith("cat:")) {
      String categoryName =
          searchText.substring(4); // Extract category name after "cat:"
      print("Controller starting search in category: $categoryName");
      return searchSignsInCategory(categoryName.toLowerCase());
    }

    //If no category is set, search through all categories.
    if (categories.isEmpty) {
      print("Controller: empty cat"); // Search in all categories
      return _model.searchInAllCategories(searchText.toLowerCase());
    } else {
      // Search with category filter
      print("Controller: not empty cat");

      return _model.searchWithCategories(searchText.toLowerCase(), categories);
    }
  }

//For the category cards.
  Future<List<Sign>> searchSignsInCategory(String category) async {
    print("Controller starting search in category: $category");
    return _model.searchInCategory(category.toLowerCase());
  }
}
