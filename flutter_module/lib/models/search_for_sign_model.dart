import 'package:cloud_firestore/cloud_firestore.dart';
import 'sign_model.dart';
import '../config/connections.dart';

class SearchForSignModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Connections _connections = Connections();

  Future<List<Sign>> searchInAllCategories(String searchText) async {
    // Initial search in the nameField
    QuerySnapshot querySnapshot = await _firestore
        .collection(_connections.mainCollection)
        .where(_connections.getNameField, isEqualTo: searchText)
        .get();

    print("Model searching in nameField");

    // Check if any documents were found
    if (querySnapshot.docs.isEmpty) {
      print("No results found in nameField, searching in tags");

      // Search in the tags array field
      querySnapshot = await _firestore
          .collection(_connections.mainCollection)
          .where(_connections.getTagField, arrayContains: searchText)
          .get();
    }

    // Convert the results to a List of Sign
    return querySnapshot.docs
        .map((doc) => Sign.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

// Search in the specified category
  Future<List<Sign>> searchInCategory(String category) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection(_connections.mainCollection)
        .where(_connections.getCategoryField, isEqualTo: category)
        .get();

    print("Model searching in category: $category");

    // Convert the results to a List of Sign
    return querySnapshot.docs
        .map((doc) => Sign.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  //searchWithCategories
  Future<List<Sign>> searchWithCategories(
      String searchText, List<String> categories) async {
    //TODO: Might need to remove this. Redundant.
    if (categories.isEmpty) {
      // If the category list is empty, call the searchInAllCategories method
      return searchInAllCategories(searchText);
    }

    // Start with an initial query that searches in the name field
    Query query = _firestore
        .collection(_connections.mainCollection)
        .where(_connections.getNameField, isEqualTo: searchText);

    // Filter the query by the provided categories
    query = query.where(_connections.getCategoryField, whereIn: categories);

    // Execute the query
    QuerySnapshot querySnapshot = await query.get();
    print("Model searching with categories");

    // If no documents found in nameField and category filters, search in tags
    if (querySnapshot.docs.isEmpty) {
      print("No results found in nameField with categories, searching in tags");
      // Update the query to search in the tags array field
      query = _firestore
          .collection(_connections.mainCollection)
          .where(_connections.getTagField, arrayContains: searchText)
          .where(_connections.getCategoryField, whereIn: categories);

      // Execute the updated query
      querySnapshot = await query.get();
    }
    // Convert the results to a List of Sign
    return querySnapshot.docs
        .map((doc) => Sign.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }
}
