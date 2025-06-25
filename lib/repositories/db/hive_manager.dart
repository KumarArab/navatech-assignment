import 'package:hive_flutter/hive_flutter.dart';
import 'package:navatech/models/album_model.dart';
import 'package:navatech/models/photo_model.dart';
import 'package:navatech/repositories/db/db_manager.dart';
import 'package:navatech/utils/logger.dart';

class HiveManager extends DBManager {
  late Box<AlbumModel> albumsBox;
  late Box<List<dynamic>> photosByAlbumBox;

  HiveManager._();

  static final HiveManager _instance = HiveManager._();

  factory HiveManager() {
    return _instance;
  }

  @override
  Future<void> init() async {
    // Initialize Hive for Flutter applications
    await Hive.initFlutter();

    Hive.registerAdapter(AlbumModelAdapter());
    Hive.registerAdapter(PhotoModelAdapter());

    albumsBox = await Hive.openBox<AlbumModel>('albums');

    photosByAlbumBox = await Hive.openBox<List<dynamic>>('photosByAlbum');
  }

  @override
  Future<void> saveAlbum(List<AlbumModel> albums) async {
    final Map<int?, AlbumModel> albumMap = {for (var album in albums) album.id: album};
    await albumsBox.putAll(albumMap);
    Logger.info('Saved ${albums.length} albums to Hive.');
  }

  @override
  Future<List<AlbumModel>> getAlbums() async {
    return albumsBox.values.toList();
  }

  @override
  Future<void> clearAlbums() async {
    await albumsBox.clear();
    Logger.info('Cleared all albums from Hive.');
  }

  @override
  Future<void> savePhotos(int albumId, List<PhotoModel> photos) async {
    await photosByAlbumBox.put(albumId, photos);
    Logger.info('Saved ${photos.length} photos for album $albumId to Hive.');
  }

  @override
  List<PhotoModel> getPhotos(int albumId) {
    return List<PhotoModel>.from(photosByAlbumBox.get(albumId, defaultValue: [])!);
  }

  @override
  Future<void> clearPhotos(int albumId) async {
    await photosByAlbumBox.delete(albumId);
    Logger.info('Cleared photos for album $albumId from Hive.');
  }

  @override
  Future<void> clearAllPhotos() async {
    await photosByAlbumBox.clear();
    Logger.info('Cleared photos from Hive.');
  }
}
