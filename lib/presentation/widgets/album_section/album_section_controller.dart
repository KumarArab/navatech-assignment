import 'package:flutter/material.dart';
import 'package:navatech/models/photo_model.dart';
import 'package:navatech/services/album_service.dart';

class AlbumSectionController extends ChangeNotifier {
  late AlbumService albumService;
  late ScrollController sectionController;
  List<PhotoModel> photos = [];
  final int _albumId;

  AlbumSectionController(
    this._albumId,
  ): albumService = AlbumService();

  void init() async {
    await fetchPhotos(albumId: _albumId);
    sectionController = ScrollController();
    sectionController.addListener(_onScroll);
  }

  Future<void> fetchPhotos({required int albumId}) async {
    final responsePhotos = await albumService.getPhotos(albumId: albumId);
    photos.addAll(responsePhotos);
    notifyListeners();
  }

  void _onScroll() {
    if (_isEnd) {
      fetchPhotos(albumId: _albumId);
    }
  }

  bool get _isEnd {
    if (!sectionController.hasClients) return false;
    final maxScroll = sectionController.position.maxScrollExtent;
    final currentScroll = sectionController.offset;
    return currentScroll.toInt() == maxScroll.toInt();
    //can be done on 80% too
  }
}
