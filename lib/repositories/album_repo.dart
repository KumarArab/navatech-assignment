import 'package:navatech/models/album_model.dart';
import 'package:navatech/models/photo_model.dart';
import 'package:navatech/repositories/db/db_manager.dart';
import 'package:navatech/repositories/db/hive_manager.dart';
import 'package:navatech/repositories/network/dio_manager.dart';
import 'package:navatech/repositories/network/network_manger.dart';

class AlbumRepository {
  final NetworkManager _networkManager = DioManager();
  final DBManager _hiveManager = HiveManager();
  Future<List<AlbumModel>> getAlbums() async {
    try {
      //search locally first
      final localResponse = await _hiveManager.getAlbums();
      if (localResponse.isNotEmpty) {
        return localResponse;
      }
      final remoteResponse = await _networkManager.get("/albums");
      //consuming only first 5 albums
      final List<AlbumModel> albums =
          ((remoteResponse.data) as List).map((e) => AlbumModel.fromJson(e)).toList().sublist(0, 5);
      await _hiveManager.saveAlbum(albums);
      return albums;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<PhotoModel>> getPhotos({required int albumId}) async {
    try {
      //search locally first
      final localResponse = _hiveManager.getPhotos(albumId);
      if (localResponse.isNotEmpty) {
        return localResponse;
      }
      final response = await _networkManager.get("/photos", queryParameters: {"albumId": albumId.toString()});
      //consuming only first 10 photos
      final List<PhotoModel> photos =
          ((response.data) as List).map((e) => PhotoModel.fromJson(e)).toList().sublist(0, 10);
      _hiveManager.savePhotos(albumId, photos);
      return photos;
    } catch (e) {
      rethrow;
    }
  }
}
