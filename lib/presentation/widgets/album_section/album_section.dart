import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:navatech/models/album_model.dart';
import 'package:navatech/models/photo_model.dart';
import 'package:navatech/presentation/widgets/album_section/album_section_controller.dart';
import 'package:provider/provider.dart';

class AlbumSection extends StatefulWidget {
  const AlbumSection({super.key, required this.album});
  final AlbumModel album;

  @override
  State<AlbumSection> createState() => _AlbumSectionState();
}

class _AlbumSectionState extends State<AlbumSection> {
  late AlbumSectionController albumSectionController;
  @override
  void initState() {
    albumSectionController = AlbumSectionController(widget.album.id!);
    albumSectionController.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => albumSectionController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              "Album ${widget.album.id}",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Consumer<AlbumSectionController>(
            builder: (context, value, child) => SizedBox(
              height: 200,
              child: value.photos.isEmpty
                  ? const Center(child: CircularProgressIndicator.adaptive())
                  : ListView.builder(
                      controller: value.sectionController,
                      scrollDirection: Axis.horizontal,
                      itemCount: value.photos.length,
                      itemBuilder: (ctx, i) => PhotoWidget(photo: value.photos[i]),
                    ),
            ),
          )
        ],
      ),
    );
  }
}

class PhotoWidget extends StatelessWidget {
  const PhotoWidget({super.key, required this.photo});

  final PhotoModel photo;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: 180,
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: CachedNetworkImageProvider(
            //thumnailUri is not working
            "https://dummyimage.com/400x400/9cc259/000/fff&text=Image+${photo.id}+for+Album${photo.albumId}",
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
