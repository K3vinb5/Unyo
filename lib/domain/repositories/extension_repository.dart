import 'package:unyo/domain/entities/extension/extension.dart';
import 'package:unyo/domain/entities/extension/preference_item.dart';
import 'package:unyo/domain/entities/user/user.dart';

abstract class ExtensionRepository {
  Future<Set<Extension>> getAvailableAnimeExtensions(User loggedUser);
  Future<Set<Extension>> getAvailableMangaExtensions(User loggedUser);
  Future<Set<Extension>> getInstalledAnimeExtensions(User loggedUser);
  Future<Set<Extension>> getInstalledMangaExtensions(User loggedUser);

  Future<Map<String, Extension>> getAnimeExtensionUpdates(User loggedUser);
  Future<Map<String, Extension>> getMangaExtensionUpdates(User loggedUser);

  Future<void> addExtension(Extension extension);
  Future<void> removeExtension(Extension extension);
  Future<void> updateExtension(Extension oldExtension, Extension newExtension);

  Future<List<PreferenceItem>> getExtensionPreferences(String pkg);
  Future<void> setExtensionPreferences(String pkg, Map<String, dynamic> values);
}
