import 'package:unyo/core/enums/episode_service.dart';

class EpisodeMediaServiceFactory {
  static EpisodeMediaService getEpisodeMediaService(EpisodeService service) {
    switch (service) {
      case EpisodeService.anizip:
        return AnizipEpisodeMediaService();
      case EpisodeService.kitsu:
        return KitsuEpisodeMediaService();
    }
  }

  static EpisodeService getEnumEpisodeService(String? serviceName) {
    switch (serviceName?.toLowerCase()) {
      case 'anizip':
        return EpisodeService.anizip;
      case 'kitsu':
        return EpisodeService.kitsu;
      default:
        return EpisodeService.anizip;
    }
  }
}

abstract class EpisodeMediaService {
  EpisodeService get service;
  List<String> get titleLanguages;
}

class AnizipEpisodeMediaService extends EpisodeMediaService {
  
  @override
  EpisodeService get service => EpisodeService.anizip;

  @override
  List<String> get titleLanguages => ['Native', 'English'];

}

class KitsuEpisodeMediaService extends EpisodeMediaService {

  @override
  EpisodeService get service => EpisodeService.kitsu;

  @override
  List<String> get titleLanguages => [];
}