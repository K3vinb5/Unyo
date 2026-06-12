import 'package:unyo/generated/json/base/json_field.dart';
import 'package:unyo/generated/json/anime_popular_query_entity.g.dart';
import 'dart:convert';
export 'package:unyo/generated/json/anime_popular_query_entity.g.dart';

@JsonSerializable()
class AnimePopularQueryEntity {
	List<AnimePopularQueryAnimes> animes = [];

	AnimePopularQueryEntity();

	factory AnimePopularQueryEntity.fromJson(Map<String, dynamic> json) => $AnimePopularQueryEntityFromJson(json);

	Map<String, dynamic> toJson() => $AnimePopularQueryEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class AnimePopularQueryAnimes {
	String malId = '';
	String id = '';
	String english = '';
	String name = '';
	String russian = '';
	String japanese = '';
	late AnimePopularQueryAnimesPoster poster = AnimePopularQueryAnimesPoster();
	String description = '';
	int duration = 0;
	late AnimePopularQueryAnimesAiredOn airedOn = AnimePopularQueryAnimesAiredOn();
	late AnimePopularQueryAnimesReleasedOn releasedOn = AnimePopularQueryAnimesReleasedOn();
	int episodes = 0;
	String nextEpisodeAt = '';
	List<AnimePopularQueryAnimesGenres> genres = [];
	String kind = '';
	bool isCensored = false;
	double score = 0.0;
	String season = '';
	String status = '';

	AnimePopularQueryAnimes();

	factory AnimePopularQueryAnimes.fromJson(Map<String, dynamic> json) => $AnimePopularQueryAnimesFromJson(json);

	Map<String, dynamic> toJson() => $AnimePopularQueryAnimesToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class AnimePopularQueryAnimesPoster {
	String originalUrl = '';
	String mainAlt2xUrl = '';

	AnimePopularQueryAnimesPoster();

	factory AnimePopularQueryAnimesPoster.fromJson(Map<String, dynamic> json) => $AnimePopularQueryAnimesPosterFromJson(json);

	Map<String, dynamic> toJson() => $AnimePopularQueryAnimesPosterToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class AnimePopularQueryAnimesAiredOn {
	int day = 0;
	int month = 0;
	int year = 0;

	AnimePopularQueryAnimesAiredOn();

	factory AnimePopularQueryAnimesAiredOn.fromJson(Map<String, dynamic> json) => $AnimePopularQueryAnimesAiredOnFromJson(json);

	Map<String, dynamic> toJson() => $AnimePopularQueryAnimesAiredOnToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class AnimePopularQueryAnimesReleasedOn {
	int day = 0;
	int month = 0;
	int year = 0;

	AnimePopularQueryAnimesReleasedOn();

	factory AnimePopularQueryAnimesReleasedOn.fromJson(Map<String, dynamic> json) => $AnimePopularQueryAnimesReleasedOnFromJson(json);

	Map<String, dynamic> toJson() => $AnimePopularQueryAnimesReleasedOnToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class AnimePopularQueryAnimesGenres {
	String kind = '';
	String name = '';

	AnimePopularQueryAnimesGenres();

	factory AnimePopularQueryAnimesGenres.fromJson(Map<String, dynamic> json) => $AnimePopularQueryAnimesGenresFromJson(json);

	Map<String, dynamic> toJson() => $AnimePopularQueryAnimesGenresToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}