import 'package:unyo/generated/json/base/json_field.dart';
import 'package:unyo/generated/json/anime_details_query_entity.g.dart';
import 'dart:convert';
export 'package:unyo/generated/json/anime_details_query_entity.g.dart';

@JsonSerializable()
class AnimeDetailsQueryEntity {
	List<AnimeDetailsQueryAnimes> animes = [];

	AnimeDetailsQueryEntity();

	factory AnimeDetailsQueryEntity.fromJson(Map<String, dynamic> json) => $AnimeDetailsQueryEntityFromJson(json);

	Map<String, dynamic> toJson() => $AnimeDetailsQueryEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class AnimeDetailsQueryAnimes {
	late AnimeDetailsQueryAnimesUserRate userRate = AnimeDetailsQueryAnimesUserRate();
	List<AnimeDetailsQueryAnimesCharacterRoles> characterRoles = [];
	List<AnimeDetailsQueryAnimesRelated> related = [];

	AnimeDetailsQueryAnimes();

	factory AnimeDetailsQueryAnimes.fromJson(Map<String, dynamic> json) => $AnimeDetailsQueryAnimesFromJson(json);

	Map<String, dynamic> toJson() => $AnimeDetailsQueryAnimesToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class AnimeDetailsQueryAnimesUserRate {
	int episodes = 0;
	int score = 0;
	int rewatches = 0;
	String status = '';
	String createdAt = '';
	String updatedAt = '';

	AnimeDetailsQueryAnimesUserRate();

	factory AnimeDetailsQueryAnimesUserRate.fromJson(Map<String, dynamic> json) => $AnimeDetailsQueryAnimesUserRateFromJson(json);

	Map<String, dynamic> toJson() => $AnimeDetailsQueryAnimesUserRateToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class AnimeDetailsQueryAnimesCharacterRoles {
	late AnimeDetailsQueryAnimesCharacterRolesCharacter character = AnimeDetailsQueryAnimesCharacterRolesCharacter();

	AnimeDetailsQueryAnimesCharacterRoles();

	factory AnimeDetailsQueryAnimesCharacterRoles.fromJson(Map<String, dynamic> json) => $AnimeDetailsQueryAnimesCharacterRolesFromJson(json);

	Map<String, dynamic> toJson() => $AnimeDetailsQueryAnimesCharacterRolesToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class AnimeDetailsQueryAnimesCharacterRolesCharacter {
	String id = '';
	late AnimeDetailsQueryAnimesCharacterRolesCharacterPoster poster = AnimeDetailsQueryAnimesCharacterRolesCharacterPoster();
	String name = '';

	AnimeDetailsQueryAnimesCharacterRolesCharacter();

	factory AnimeDetailsQueryAnimesCharacterRolesCharacter.fromJson(Map<String, dynamic> json) => $AnimeDetailsQueryAnimesCharacterRolesCharacterFromJson(json);

	Map<String, dynamic> toJson() => $AnimeDetailsQueryAnimesCharacterRolesCharacterToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class AnimeDetailsQueryAnimesCharacterRolesCharacterPoster {
	String originalUrl = '';

	AnimeDetailsQueryAnimesCharacterRolesCharacterPoster();

	factory AnimeDetailsQueryAnimesCharacterRolesCharacterPoster.fromJson(Map<String, dynamic> json) => $AnimeDetailsQueryAnimesCharacterRolesCharacterPosterFromJson(json);

	Map<String, dynamic> toJson() => $AnimeDetailsQueryAnimesCharacterRolesCharacterPosterToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class AnimeDetailsQueryAnimesRelated {
	String relationKind = '';
	late AnimeDetailsQueryAnimesRelatedAnime anime = AnimeDetailsQueryAnimesRelatedAnime();

	AnimeDetailsQueryAnimesRelated();

	factory AnimeDetailsQueryAnimesRelated.fromJson(Map<String, dynamic> json) => $AnimeDetailsQueryAnimesRelatedFromJson(json);

	Map<String, dynamic> toJson() => $AnimeDetailsQueryAnimesRelatedToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class AnimeDetailsQueryAnimesRelatedAnime {
	String malId = '';
	String id = '';
	String english = '';
	String name = '';
	String russian = '';
	String japanese = '';
	late AnimeDetailsQueryAnimesRelatedAnimePoster poster = AnimeDetailsQueryAnimesRelatedAnimePoster();
	String description = '';
	int duration = 0;
	late AnimeDetailsQueryAnimesRelatedAnimeAiredOn airedOn = AnimeDetailsQueryAnimesRelatedAnimeAiredOn();
	late AnimeDetailsQueryAnimesRelatedAnimeReleasedOn releasedOn = AnimeDetailsQueryAnimesRelatedAnimeReleasedOn();
	int episodes = 0;
	dynamic nextEpisodeAt;
	List<AnimeDetailsQueryAnimesRelatedAnimeGenres> genres = [];
	String kind = '';
	bool isCensored = false;
	double score = 0.0;
	String season = '';
	String status = '';

	AnimeDetailsQueryAnimesRelatedAnime();

	factory AnimeDetailsQueryAnimesRelatedAnime.fromJson(Map<String, dynamic> json) => $AnimeDetailsQueryAnimesRelatedAnimeFromJson(json);

	Map<String, dynamic> toJson() => $AnimeDetailsQueryAnimesRelatedAnimeToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class AnimeDetailsQueryAnimesRelatedAnimePoster {
	String originalUrl = '';
	String mainAlt2xUrl = '';

	AnimeDetailsQueryAnimesRelatedAnimePoster();

	factory AnimeDetailsQueryAnimesRelatedAnimePoster.fromJson(Map<String, dynamic> json) => $AnimeDetailsQueryAnimesRelatedAnimePosterFromJson(json);

	Map<String, dynamic> toJson() => $AnimeDetailsQueryAnimesRelatedAnimePosterToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class AnimeDetailsQueryAnimesRelatedAnimeAiredOn {
	int day = 0;
	int month = 0;
	int year = 0;

	AnimeDetailsQueryAnimesRelatedAnimeAiredOn();

	factory AnimeDetailsQueryAnimesRelatedAnimeAiredOn.fromJson(Map<String, dynamic> json) => $AnimeDetailsQueryAnimesRelatedAnimeAiredOnFromJson(json);

	Map<String, dynamic> toJson() => $AnimeDetailsQueryAnimesRelatedAnimeAiredOnToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class AnimeDetailsQueryAnimesRelatedAnimeReleasedOn {
	int day = 0;
	int month = 0;
	int year = 0;

	AnimeDetailsQueryAnimesRelatedAnimeReleasedOn();

	factory AnimeDetailsQueryAnimesRelatedAnimeReleasedOn.fromJson(Map<String, dynamic> json) => $AnimeDetailsQueryAnimesRelatedAnimeReleasedOnFromJson(json);

	Map<String, dynamic> toJson() => $AnimeDetailsQueryAnimesRelatedAnimeReleasedOnToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class AnimeDetailsQueryAnimesRelatedAnimeGenres {
	String kind = '';
	String name = '';

	AnimeDetailsQueryAnimesRelatedAnimeGenres();

	factory AnimeDetailsQueryAnimesRelatedAnimeGenres.fromJson(Map<String, dynamic> json) => $AnimeDetailsQueryAnimesRelatedAnimeGenresFromJson(json);

	Map<String, dynamic> toJson() => $AnimeDetailsQueryAnimesRelatedAnimeGenresToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}