import 'package:flutter/material.dart';
import 'package:navatech/models/album_model.dart';
import 'package:navatech/services/album_service.dart';

class AlbumScreenController extends ChangeNotifier {
  late AlbumService albumService;
  late ScrollController albumController;
  List<AlbumModel> albums = [];

  void init() async {
    albumService = AlbumService();
    await fetchAlbums();
    albumController = ScrollController();
    albumController.addListener(_onScroll);
  }

  Future<void> fetchAlbums() async {
    final responseAlbums = await albumService.getAlbums();
     albums.addAll(responseAlbums);
    notifyListeners();
  }

  void _onScroll() {
    if (_isEnd) {
      fetchAlbums();
    }
  }

  bool get _isEnd {
    if (!albumController.hasClients) return false;
    final maxScroll = albumController.position.maxScrollExtent;
    final currentScroll = albumController.offset;
    // Trigger fetch when 80% scrolled (adjust threshold as needed)
    return currentScroll.toInt() == maxScroll;
  }
}
