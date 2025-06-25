import 'package:flutter/material.dart';
import 'package:navatech/presentation/screens/album_screen/album_screen_controller.dart';
import 'package:navatech/presentation/widgets/album_section/album_section.dart';
import 'package:navatech/repositories/db/hive_manager.dart';
import 'package:provider/provider.dart';

class AlbumScreen extends StatefulWidget {
  const AlbumScreen({super.key});

  @override
  State<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AlbumScreenController>(context, listen: false).init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Albums",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: false,
        actions: [
          TextButton.icon(
              onPressed: () async {
                await HiveManager().clearAlbums();
                await HiveManager().clearAllPhotos();
              },
              label: const Text("Clear Cache"),
              icon: const Icon(Icons.clear))
        ],
      ),
      body: Consumer<AlbumScreenController>(
        builder: (BuildContext context, value, Widget? child) {
          // handle loading failure success states
          return value.albums.isNotEmpty
              ? ListView.builder(
                  controller: value.albumController,
                  itemCount: value.albums.length,
                  itemBuilder: (ctx, i) => AlbumSection(album: value.albums[i]),
                )
              : const Center(child: CircularProgressIndicator.adaptive());
        },
      ),
    );
  }
}
