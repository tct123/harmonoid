import 'package:flutter/material.dart';
import 'package:media_library/media_library.dart';

import 'package:harmonoid/core/configuration/configuration.dart';
import 'package:harmonoid/extensions/date_time.dart';
import 'package:harmonoid/extensions/string.dart';
import 'package:harmonoid/utils/constants.dart';

/// Extensions for [Track].
extension TrackExtensions on Track {
  /// Display title.
  String get displayTitle => title;

  /// Display subtitle.
  String get displaySubtitle => [
        if (artists.isNotEmpty) artists.join(', '),
        if (album.isNotEmpty) album,
        if (year != 0) year.toString(),
      ].where((e) => e.isNotEmpty).join(' • ');

  /// Share subject.
  String get shareSubject => [
        title,
        artists.join(', '),
        if (album.isNotEmpty) album,
        if (year != 0) year.toString(),
      ].where((e) => e.isNotEmpty).join(' • ');

  /// [ValueKey] for [ScrollViewBuilder].
  ValueKey<String> get scrollViewBuilderKey {
    switch (Configuration.instance.mediaLibraryTrackSortType) {
      case TrackSortType.title:
        return ValueKey(
          title[0].uppercase(),
        );
      case TrackSortType.timestamp:
        return ValueKey(
          timestamp.label,
        );
      case TrackSortType.year:
        return ValueKey(
          year == 0 ? kDefaultYear : year.toString(),
        );
    }
  }
}
