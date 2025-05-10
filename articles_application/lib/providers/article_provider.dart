import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/article.dart';
import '../services/article_service.dart';

class ArticleProvider extends ChangeNotifier {
  final ArticleService _articleService = ArticleService();
  final SharedPreferences? _prefs;

  List<Article> _articles = [];
  List<Article> _filteredArticles = [];
  bool _isLoading = false;
  String _error = '';
  String _searchQuery = '';
  Set<int> _favoriteIds = {};

  ArticleProvider({SharedPreferences? prefs}) : _prefs = prefs {
    _loadFavorites();
  }

  List<Article> get articles => _filteredArticles;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> _loadFavorites() async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    final favoritesList = prefs.getStringList('favorites') ?? [];
    _favoriteIds = favoritesList.map((id) => int.parse(id)).toSet();
  }

  Future<void> _saveFavorites() async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    final favoritesStringList =
        _favoriteIds.map((id) => id.toString()).toList();
    await prefs.setStringList('favorites', favoritesStringList);
  }

  Future<void> fetchArticles() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _articles = await _articleService.getArticles();
      // Apply favorites from saved preferences
      for (var article in _articles) {
        article.isFavorite = _favoriteIds.contains(article.id);
      }
      _applySearch();
      _error = '';
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchArticles(String query) {
    _searchQuery = query;
    _applySearch();
    notifyListeners();
  }

  void _applySearch() {
    if (_searchQuery.isEmpty) {
      _filteredArticles = _articles;
    } else {
      _filteredArticles =
          _articles
              .where(
                (article) => article.title.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ),
              )
              .toList();
    }
  }

  void toggleFavorite(int articleId) {
    final index = _articles.indexWhere((article) => article.id == articleId);
    if (index != -1) {
      _articles[index].isFavorite = !_articles[index].isFavorite;

      if (_articles[index].isFavorite) {
        _favoriteIds.add(articleId);
      } else {
        _favoriteIds.remove(articleId);
      }

      _saveFavorites();
      _applySearch(); // Update filtered articles
      notifyListeners();
    }
  }

  List<Article> get favoriteArticles =>
      _articles.where((article) => article.isFavorite).toList();
}
