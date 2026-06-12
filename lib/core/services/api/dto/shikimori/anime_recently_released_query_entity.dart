import 'package:unyo/generated/json/base/json_field.dart';
import 'package:unyo/generated/json/anime_recently_released_query_entity.g.dart';
import 'dart:convert';
export 'package:unyo/generated/json/anime_recently_released_query_entity.g.dart';

@JsonSerializable()
class AnimeRecentlyReleasedQueryEntity {
	List<AnimeRecentlyReleasedQueryAnimes> animes = [];

	AnimeRecentlyReleasedQueryEntity();

	factory AnimeRecentlyReleasedQueryEntity.fromJson(Map<String, dynamic> json) => $AnimeRecentlyReleasedQueryEntityFromJson(json);

	Map<String, dynamic> toJson() => $AnimeRecentlyReleasedQueryEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class AnimeRecentlyReleasedQueryAnimes {
	String malId = '';
	String id = '';
	String english = '';
	String name = '';
	String russian = '';
	String japanese = '';
	late AnimeRecentlyReleasedQueryAnimesPoster poster = AnimeRecentlyReleasedQueryAnimesPoster();
	String description = '';
	int duration = 0;
	late AnimeRecentlyReleasedQueryAnimesAiredOn airedOn = AnimeRecentlyReleasedQueryAnimesAiredOn();
	late AnimeRecentlyReleasedQueryAnimesReleasedOn releasedOn = AnimeRecentlyReleasedQueryAnimesReleasedOn();
	int episodes = 0;
	dynamic nextEpisodeAt;
	List<AnimeRecentlyReleasedQueryAnimesGenres> genres = [];
	String kind = '';
	bool isCensored = false;
	double score = 0.0;
	String season = '';
	String status = '';

	AnimeRecentlyReleasedQueryAnimes();

	factory AnimeRecentlyReleasedQueryAnimes.fromJson(Map<String, dynamic> json) => $AnimeRecentlyReleasedQueryAnimesFromJson(json);

	Map<String, dynamic> toJson() => $AnimeRecentlyReleasedQueryAnimesToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class AnimeRecentlyReleasedQueryAnimesPoster {
	String originalUrl = '';
	String mainAlt2xUrl = '';

	AnimeRecentlyReleasedQueryAnimesPoster();

	factory AnimeRecentlyReleasedQueryAnimesPoster.fromJson(Map<String, dynamic> json) => $AnimeRecentlyReleasedQueryAnimesPosterFromJson(json);

	Map<String, dynamic> toJson() => $AnimeRecentlyReleasedQueryAnimesPosterToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class AnimeRecentlyReleasedQueryAnimesAiredOn {
	int day = 0;
	int month = 0;
	int year = 0;

	AnimeRecentlyReleasedQueryAnimesAiredOn();

	factory AnimeRecentlyReleasedQueryAnimesAiredOn.fromJson(Map<String, dynamic> json) => $AnimeRecentlyReleasedQueryAnimesAiredOnFromJson(json);

	Map<String, dynamic> toJson() => $AnimeRecentlyReleasedQueryAnimesAiredOnToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class AnimeRecentlyReleasedQueryAnimesReleasedOn {
	int day = 0;
	int month = 0;
	int year = 0;

	AnimeRecentlyReleasedQueryAnimesReleasedOn();

	factory AnimeRecentlyReleasedQueryAnimesReleasedOn.fromJson(Map<String, dynamic> json) => $AnimeRecentlyReleasedQueryAnimesReleasedOnFromJson(json);

	Map<String, dynamic> toJson() => $AnimeRecentlyReleasedQueryAnimesReleasedOnToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class AnimeRecentlyReleasedQueryAnimesGenres {
	String kind = '';
	String name = '';

	AnimeRecentlyReleasedQueryAnimesGenres();

	factory AnimeRecentlyReleasedQueryAnimesGenres.fromJson(Map<String, dynamic> json) => $AnimeRecentlyReleasedQueryAnimesGenresFromJson(json);

	Map<String, dynamic> toJson() => $AnimeRecentlyReleasedQueryAnimesGenresToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}