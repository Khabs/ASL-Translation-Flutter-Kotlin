import 'package:flutter/material.dart';
import '../models/sign_model.dart';
import '../controllers/search_for_sign_logic.dart';
import '../config/style.dart';

class SearchForSignScreen extends StatefulWidget {
  @override
  _SearchForSignScreenState createState() => _SearchForSignScreenState();
}

class _SearchForSignScreenState extends State<SearchForSignScreen>  {
  final SearchForSignLogic _logic = SearchForSignLogic();
  final TextEditingController _searchController = TextEditingController();
  List<Sign> _searchResults = [];
  Map<String, List<Sign>> _categoryResults = {};
  bool _isSearching = false;
  final Styles styleObj = Styles();

  //List of categories.
  final List<String> categories = [
    'Daily Essentials',
    'General Inquiry & Assistance',
    'Health & Safety',
    'Leisure & Sports',
    'Professions'
  ];

  @override
  void initState() {
    super.initState();
    _loadCategoryData();
  }

  void _loadCategoryData() async {
    for (var category in categories) {
      try {
        var results = await _logic.searchSignsInCategory(category);
        setState(() {
          _categoryResults[category] = results;
        });
      } catch (e) {
        print('Error loading signs for $category: $e');
      }
    }
  }


  //Switch between states.
  void _search(String searchText) async {
    if (searchText.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults = [];
      });
    } else {
      _isSearching = true;
      try {
        var results = await _logic.searchSigns(searchText, []);
        setState(() {
          _searchResults = results;
        });
      } catch (e) {
        print('Error searching for $searchText: $e');
      }
    }
  }

// Displays the gif details in a popup
  void _showGifDetail(Sign sign) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppBar(
                automaticallyImplyLeading: false, // Removes the default back button
                title: Text(sign.name),
                actions: [
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              Image.network(
                sign.gif,
                width: styleObj.getGifContainerWidth(context),
                height: styleObj.getGifContainerHeight(context),
              ),
            ],
          ),
        );
      },
    );
  }




  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                // Adding a suffix icon only if the search bar is not empty
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _search(""); // Clear search results
                  },
                )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(styleObj.getRoundedCornersValue),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              onChanged: (value) {
                setState(() {}); // Update UI to show/hide 'X' icon
                _search(value);
              },
              onSubmitted: (value) => _search(value),
            ),
          ),
          Expanded(
            child: _isSearching || _searchResults.isNotEmpty
                ? Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'We have found ${_searchResults.length} Results Matching "${_searchController.text}"',
                    style: styleObj.getInfoMessageTextStyle,
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      var sign = _searchResults[index];
                      return ListTile(
                        leading: GestureDetector(
                          onTap: () => _showGifDetail(sign),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(styleObj.getRoundedCornersValue),
                            child: Image.network(sign.gif, width: styleObj.getGifWidth(context), height: styleObj.getGifHeight(context)),
                          ),
                        ),
                        title: Text(sign.name),
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(height: 10),
                  ),
                ),
              ],
            )
                : CustomScrollView(
              slivers: categories
                  .map((category) => _buildCategorySection(category))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(String category) {
    var categoryData = _categoryResults[category];

    if (categoryData == null) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      );
    }

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                //If category is clicked, search category with prefix cat
                String searchQuery = 'cat:$category';
                _searchController.text = searchQuery;
                _search(searchQuery);
              },
              child: Text(
                category,
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categoryData.length,
                itemBuilder: (context, index) {
                  var sign = categoryData[index];
                  return GestureDetector(
                    onTap: () => _showGifDetail(sign),
                    child: Container(
                      width: 120,
                      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          sign.gif,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
