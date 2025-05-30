import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:media_library/media_library.dart' hide MediaLibrary;
import 'package:provider/provider.dart';

import 'package:harmonoid/core/media_library.dart';
import 'package:harmonoid/core/media_player/media_player.dart';
import 'package:harmonoid/localization/localization.dart';
import 'package:harmonoid/mappers/track.dart';
import 'package:harmonoid/ui/media_library/albums/album_item.dart';
import 'package:harmonoid/ui/media_library/artists/artist_item.dart';
import 'package:harmonoid/ui/media_library/genres/genre_item.dart';
import 'package:harmonoid/ui/media_library/media_library_flags.dart';
import 'package:harmonoid/ui/media_library/search/search_banner.dart';
import 'package:harmonoid/ui/media_library/search/search_no_items_banner.dart';
import 'package:harmonoid/ui/media_library/tracks/track_item.dart';
import 'package:harmonoid/ui/router.dart';
import 'package:harmonoid/utils/constants.dart';
import 'package:harmonoid/utils/rendering.dart';
import 'package:harmonoid/utils/widgets.dart';

class SearchScreen extends StatefulWidget {
  final String query;

  const SearchScreen({super.key, required this.query});

  @override
  State<SearchScreen> createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  static const int _kLimit = 20;

  final List<Album> _albums = <Album>[];
  final List<Artist> _artists = <Artist>[];
  final List<Genre> _genres = <Genre>[];
  final List<Track> _tracks = <Track>[];

  void update(String query) {
    final result = context.read<MediaLibrary>().search(query, limit: _kLimit);
    if (context.mounted) {
      setState(() {
        _albums
          ..clear()
          ..addAll(result.whereType<Album>());
        _artists
          ..clear()
          ..addAll(result.whereType<Artist>());
        _genres
          ..clear()
          ..addAll(result.whereType<Genre>());
        _tracks
          ..clear()
          ..addAll(result.whereType<Track>());
      });
    }
  }

  @override
  void initState() {
    super.initState();
    update(widget.query);
  }

  @override
  void didUpdateWidget(covariant SearchScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.query != widget.query) {
      update(widget.query);
    }
  }

  @override
  Widget build(BuildContext context) {
    mediaLibrarySearchViewVisible = TickerMode.of(context);
    if (widget.query.isEmpty) {
      return const SearchBanner();
    }
    if (_albums.isEmpty && _artists.isEmpty && _genres.isEmpty && _tracks.isEmpty) {
      return const SearchNoItemsBanner();
    }
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        children: [
          if (_albums.isNotEmpty) ...[
            Row(
              children: [
                SubHeader(Localization.instance.ALBUMS),
                const Spacer(),
                if (_albums.length > _kLimit)
                  ShowAllButton(
                    onPressed: () {
                      context.push(
                        '/$kMediaLibraryPath/$kSearchItemsPath',
                        extra: SearchItemsPathExtra(
                          query: widget.query,
                          items: context.read<MediaLibrary>().search(widget.query).whereType<Album>().toList(),
                        ),
                      );
                    },
                  ),
                SizedBox(width: margin),
              ],
            ),
            Container(
              alignment: Alignment.centerLeft,
              height: albumTileHeight + margin,
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: _albums.length.clamp(0, _kLimit),
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(
                  left: margin,
                  right: margin,
                  bottom: margin,
                ),
                itemBuilder: (context, i) => AlbumItem(
                  album: _albums[i],
                  width: albumTileWidth,
                  height: albumTileHeight,
                ),
                separatorBuilder: (context, _) => SizedBox(width: margin),
              ),
            ),
          ],
          if (_artists.isNotEmpty) ...[
            Row(
              children: [
                SubHeader(Localization.instance.ARTISTS),
                const Spacer(),
                if (_artists.length > _kLimit)
                  ShowAllButton(
                    onPressed: () {
                      context.push(
                        '/$kMediaLibraryPath/$kSearchItemsPath',
                        extra: SearchItemsPathExtra(
                          query: widget.query,
                          items: context.read<MediaLibrary>().search(widget.query).whereType<Artist>().toList(),
                        ),
                      );
                    },
                  ),
                SizedBox(width: margin),
              ],
            ),
            Container(
              alignment: Alignment.centerLeft,
              height: kArtistTileHeight + margin,
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: _artists.length.clamp(0, _kLimit),
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(
                  left: margin,
                  right: margin,
                  bottom: margin,
                ),
                itemBuilder: (context, i) => ArtistItem(
                  artist: _artists[i],
                  width: kArtistTileWidth,
                  height: kArtistTileHeight,
                ),
                separatorBuilder: (context, _) => SizedBox(width: margin),
              ),
            ),
          ],
          if (_genres.isNotEmpty) ...[
            Row(
              children: [
                SubHeader(Localization.instance.GENRES),
                const Spacer(),
                if (_genres.length > _kLimit)
                  ShowAllButton(
                    onPressed: () {
                      context.push(
                        '/$kMediaLibraryPath/$kSearchItemsPath',
                        extra: SearchItemsPathExtra(
                          query: widget.query,
                          items: context.read<MediaLibrary>().search(widget.query).whereType<Genre>().toList(),
                        ),
                      );
                    },
                  ),
                SizedBox(width: margin),
              ],
            ),
            Container(
              alignment: Alignment.centerLeft,
              height: kGenreTileHeight + margin,
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: _genres.length.clamp(0, _kLimit),
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(
                  left: margin,
                  right: margin,
                  bottom: margin,
                ),
                itemBuilder: (context, i) => GenreItem(
                  genre: _genres[i],
                  width: kGenreTileWidth,
                  height: kGenreTileHeight,
                ),
                separatorBuilder: (context, _) => SizedBox(width: margin),
              ),
            ),
          ],
          if (_tracks.isNotEmpty) ...[
            Row(
              children: [
                SubHeader(Localization.instance.TRACKS),
                const Spacer(),
                if (_tracks.length > _kLimit)
                  ShowAllButton(
                    onPressed: () {
                      context.push(
                        '/$kMediaLibraryPath/$kSearchItemsPath',
                        extra: SearchItemsPathExtra(
                          query: widget.query,
                          items: context.read<MediaLibrary>().search(widget.query).whereType<Track>().toList(),
                        ),
                      );
                    },
                  ),
                SizedBox(width: margin),
              ],
            ),
            for (int i = 0; i < _tracks.length.clamp(0, _kLimit); i++) ...[
              TrackItem(
                track: _tracks[i],
                width: double.infinity,
                height: linearTileHeight,
                onTap: () {
                  MediaPlayer.instance.open(
                    _tracks.map((e) => e.toPlayable()).toList(),
                    index: i,
                  );
                },
              ),
            ],
          ],
        ],
      ),
    );
  }
}
