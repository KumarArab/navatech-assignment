import 'package:flutter/material.dart';
import 'package:navatech/main.dart';
import 'package:navatech/models/album_model.dart';
import 'package:navatech/models/photo_model.dart';
import 'package:navatech/repositories/album_repo.dart';
import 'package:navatech/utils/logger.dart';

class AlbumService {
  final AlbumRepository albumRepository;
  AlbumService._() : albumRepository = AlbumRepository();
  static final AlbumService _instance = AlbumService._();
  factory AlbumService() {
    return _instance;
  }

  Future<List<AlbumModel>> getAlbums() async {
    try {
      List<AlbumModel>? albums = await albumRepository.getAlbums();
      return albums;
    } catch (e) {
      _handleError(e);
      return [];
    }
  }

  Future<List<PhotoModel>> getPhotos({required int albumId}) async {
    try {
      List<PhotoModel>? photos = await albumRepository.getPhotos(albumId: albumId);
      return photos;
    } catch (e) {
      _handleError(e);
      return [];
    }
  }

  _handleError(Object e) {
    Logger.info(e.toString());
    ScaffoldMessenger.of(App.navigationContext)
        .showSnackBar(const SnackBar(content: Text("Something went wrong, please try again")));
  }
}
