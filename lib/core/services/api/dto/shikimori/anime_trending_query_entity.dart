import 'package:unyo/generated/json/base/json_field.dart';
import 'package:unyo/generated/json/anime_trending_query_entity.g.dart';
import 'dart:convert';
export 'package:unyo/generated/json/anime_trending_query_entity.g.dart';

@JsonSerializable()
class AnimeTrendingQueryEntity {
	List<AnimeTrendingQueryAnimes> animes = [];

	AnimeTrendingQueryEntity();

	factory AnimeTrendingQueryEntity.fromJson(Map<String, dynamic> json) => $AnimeTrendingQueryEntityFromJson(json);

	Map<String, dynamic> toJson() => $AnimeTrendingQueryEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class AnimeTrendingQueryAnimes {
	String malId = '';
	String id = '';
	String english = '';
	String name = '';
	String russian = '';
	String japanese = '';
	late AnimeTrendingQueryAnimesPoster poster = AnimeTrendingQueryAnimesPoster();
	String description = '';
	int duration = 0;
	late AnimeTrendingQueryAnimesAiredOn airedOn = AnimeTrendingQueryAnimesAiredOn();
	late AnimeTrendingQueryAnimesReleasedOn releasedOn = AnimeTrendingQueryAnimesReleasedOn();
	int episodes = 0;
	String nextEpisodeAt = '';
	List<AnimeTrendingQueryAnimesGenres> genres = [];
	String kind = '';
	bool isCensored = false;
	double score = 0.0;
	String season = '';
	String status = '';

	AnimeTrendingQueryAnimes();

	factory AnimeTrendingQueryAnimes.fromJson(Map<String, dynamic> json) => $AnimeTrendingQueryAnimesFromJson(json);

	Map<String, dynamic> toJson() => $AnimeTrendingQueryAnimesToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class AnimeTrendingQueryAnimesPoster {
	String originalUrl = '';
	String mainAlt2xUrl = '';

	AnimeTrendingQueryAnimesPoster();

	factory AnimeTrendingQueryAnimesPoster.fromJson(Map<String, dynamic> json) => $AnimeTrendingQueryAnimesPosterFromJson(json);

	Map<String, dynamic> toJson() => $AnimeTrendingQueryAnimesPosterToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class AnimeTrendingQueryAnimesAiredOn {
	int day = 0;
	int month = 0;
	int year = 0;

	AnimeTrendingQueryAnimesAiredOn();

	factory AnimeTrendingQueryAnimesAiredOn.fromJson(Map<String, dynamic> json) => $AnimeTrendingQueryAnimesAiredOnFromJson(json);

	Map<String, dynamic> toJson() => $AnimeTrendingQueryAnimesAiredOnToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class AnimeTrendingQueryAnimesReleasedOn {
	int day = 0;
	int month = 0;
	int year = 0;

	AnimeTrendingQueryAnimesReleasedOn();

	factory AnimeTrendingQueryAnimesReleasedOn.fromJson(Map<String, dynamic> json) => $AnimeTrendingQueryAnimesReleasedOnFromJson(json);

	Map<String, dynamic> toJson() => $AnimeTrendingQueryAnimesReleasedOnToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class AnimeTrendingQueryAnimesGenres {
	String kind = '';
	String name = '';

	AnimeTrendingQueryAnimesGenres();

	factory AnimeTrendingQueryAnimesGenres.fromJson(Map<String, dynamic> json) => $AnimeTrendingQueryAnimesGenresFromJson(json);

	Map<String, dynamic> toJson() => $AnimeTrendingQueryAnimesGenresToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}