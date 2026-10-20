import 'dart:convert';
import '../data/dummy_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/anime.dart';

class AppStateProvider extends ChangeNotifier{
  //Data yang ingin disimpan di sini
  List<Anime> _favorites = [];

  static const String _storageKey = 'favorite_anime_list';

  AppStateProvider(){
    _loadFavorites();
  }

  // getters
  List<Anime> get favorites => _favorites;

  //STATE BARU
  String _selectedGenre = "All";

  String get selectedGenre => _selectedGenre;

  void setSelectedGenre(String genre) {
    _selectedGenre = genre;
    notifyListeners();
  }

  //helper functions untuk tahu apakah anime sudah ada di favorite atau belum
  bool isFavorite(String id) {
    return _favorites.any((anime) => anime.id == id);
  }

  void toggleFavorite (Anime anime){
    if (isFavorite(anime.id)){
      removeFavorite(anime);
    } else {
      addFavorite(anime);
    }
  }

  // fungsi untuk menambahkan dan menghapus anime dari daftar favorit
  void removeFavorite(Anime anime){
    _favorites.removeWhere((anime) => anime.id == anime.id);
    _saveFavorites();
    notifyListeners();
  }

  void addFavorite(Anime anime){
    if(!isFavorite(anime.id)){
      _favorites.add(anime);
      _saveFavorites();
      notifyListeners();
    }
  }

  Future<void> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      //List Anime
      final List<Map<String, dynamic>> favoritesJson = _favorites.map((anime) =>
          anime.toJson()).toList();

      //List Map di encode ke JSON string
      await prefs.setString(_storageKey, jsonEncode(favoritesJson));
    } catch (e) {
      debugPrint('Error saving favorites: $e');
    }
  }

  Future<void> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final String? favoritesJson = prefs.getString(_storageKey);

      if (favoritesJson != null) {
        final List<dynamic> decoded = jsonDecode(favoritesJson);

        _favorites = decoded
            .map((item) => Anime.fromJson(item as Map<String, dynamic>))
            .toList();

        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading favorites: $e');
    }
  }

  List<Anime> getFilteredAnimeForHome() {
    List<Anime> result = DummyData.animeList;

    if (_selectedGenre != "All") {
      result = result.where((anime) {
        final genres = anime.genre.split(',').map((g) => g.trim()).toList();
        return genres.contains(_selectedGenre);
      }).toList();
    }
    return result;
  }
}