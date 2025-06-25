import 'package:navatech/models/album_model.dart';
import 'package:navatech/models/photo_model.dart';

abstract class DBManager {
  Future<void> init();
  Future<void> saveAlbum(List<AlbumModel> albums);
  Future<List<AlbumModel>> getAlbums();
  Future<void> clearAlbums();
  Future<void> savePhotos(int albumId, List<PhotoModel> photos);
  List<PhotoModel> getPhotos(int albumId);
  Future<void> clearPhotos(int albumId);
  Future<void> clearAllPhotos();
}
