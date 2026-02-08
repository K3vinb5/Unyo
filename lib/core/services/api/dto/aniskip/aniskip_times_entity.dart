import 'package:unyo/generated/json/base/json_field.dart';
import 'package:unyo/generated/json/aniskip_times_entity.g.dart';
import 'dart:convert';
export 'package:unyo/generated/json/aniskip_times_entity.g.dart';

@JsonSerializable()
class AniskipTimesEntity {
	bool found = false;
	List<AniskipTimesResults> results = [];
	String message = '';
	int statusCode = 0;

	AniskipTimesEntity();

	factory AniskipTimesEntity.fromJson(Map<String, dynamic> json) => $AniskipTimesEntityFromJson(json);

	Map<String, dynamic> toJson() => $AniskipTimesEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class AniskipTimesResults {
	AniskipTimesResultsInterval interval = AniskipTimesResultsInterval();
	String skipType = '';
	String skipId = '';
	double episodeLength = 0.0;

	AniskipTimesResults();

	factory AniskipTimesResults.fromJson(Map<String, dynamic> json) => $AniskipTimesResultsFromJson(json);

	Map<String, dynamic> toJson() => $AniskipTimesResultsToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class AniskipTimesResultsInterval {
	double startTime = -1.0;
	double endTime = -1.0;

	AniskipTimesResultsInterval();

	factory AniskipTimesResultsInterval.fromJson(Map<String, dynamic> json) => $AniskipTimesResultsIntervalFromJson(json);

	Map<String, dynamic> toJson() => $AniskipTimesResultsIntervalToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}