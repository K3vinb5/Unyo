import 'package:d4rt/d4rt.dart';

import 'document.dart';
import 'element.dart';
import 'filter.dart';
import 'http.dart';
import 'm_chapter.dart';
import 'm_manga.dart';
import 'm_pages.dart';
import 'm_provider.dart';
import 'm_source.dart';
import 'm_status.dart';
import 'm_track.dart';
import 'm_video.dart';
import 'source_preference.dart';

class RegistrerBridge {
  static void registerBridge(D4rt interpreter) {
    MDocumentBridge().registerBridgedClasses(interpreter);
    MElementBridge().registerBridgedClasses(interpreter);
    FilterBridge().registerBridgedClasses(interpreter);
    HttpBridge().registerBridgedClasses(interpreter);
    MMangaBridge().registerBridgedClasses(interpreter);
    MChapterBridge().registerBridgedClasses(interpreter);
    MPagesBridge().registerBridgedClasses(interpreter);
    MProviderBridged().registerBridgedClasses(interpreter);
    MSourceBridge().registerBridgedClasses(interpreter);
    MStatusBridge().registerBridgedEnum(interpreter);
    MTrackBridge().registerBridgedClasses(interpreter);
    MVideoBridge().registerBridgedClasses(interpreter);
    SourcePreferenceBridge().registerBridgedClasses(interpreter);
  }
}
