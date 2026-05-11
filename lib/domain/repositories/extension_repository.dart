import 'package:unyo/domain/entities/extension.dart';
import 'package:unyo/domain/entities/user.dart';

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
}
