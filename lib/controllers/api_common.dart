import 'package:http/http.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

abstract class APIRequest {
  Uri getRequestURL();
  Future doRequest();
}

enum GroupingUnit {
  hour("hour"),
  day("day"),
  month("month"),
  year("year");

  final String value;
  const GroupingUnit(this.value);
}

class DateTimeInterval {
  DateTime startAt;
  DateTime endAt;

  DateTimeInterval(this.startAt, this.endAt);

  @override
  String toString() {
    return "start_at=${startAt.millisecondsSinceEpoch}&end_at=${endAt.millisecondsSinceEpoch}";
  }

  String getPretty() {
    return "${getPrettyStart()} — ${getPrettyEnd()}";
  }

  String getPrettyStart() {
    return "${startAt.year}/${startAt.month}/${startAt.day}";
  }

  String getPrettyEnd() {
    return "${endAt.year}/${endAt.month}/${endAt.day}";
  }

  Map<String, String> toMap() {
    return {
      "start_at": startAt.millisecondsSinceEpoch.toString(),
      "end_at": endAt.millisecondsSinceEpoch.toString(),
    };
  }

  static DateTimeInterval getLast24Hours() {
    return DateTimeInterval(
      DateTime.now().subtract(
        const Duration(hours: 24),
      ),
      DateTime.now(),
    );
  }

  static DateTimeInterval getLast7Days() {
    return DateTimeInterval(
      DateTime.now().subtract(
        const Duration(days: 7),
      ),
      DateTime.now(),
    );
  }
}

class TimestampedEntry {
  final DateTime dateTime;
  final int number;

  TimestampedEntry(this.dateTime, this.number);

  TimestampedEntry.fromJSON(Map<String, dynamic> json)
      : dateTime = DateTime.parse(json["t"]),
        number = json["y"];

  toMap() {
    return {"t": dateTime.toString(), "y": number};
  }

  @override
  String toString() {
    return toMap().toString();
  }
}

Map<String, String> makeAccessTokenHeader(String accessToken) {
  return {"Authorization": "Bearer $accessToken"};
}

bool isResponseOK(Response response) {
  return response.statusCode == 200 || response.statusCode == 201;
}

Exception getAPIException(int statusCode, String msg) {
  switch (statusCode) {
    case 400:
      return BadRequestException(msg);
    case 401:
      return UnauthorizedException(msg);
    case 403:
      return ForbiddenException(msg);
    case 404:
      return NotFoundException(msg);
    case 500:
      return InternalServerErrorException(msg);
    default:
      return GenericAPIException("http error: $statusCode");
  }
}

abstract class APIException implements Exception {
  String getFriendlyErrorString(AppLocalizations loc);
}

class NotFoundException implements APIException {
  String msg;
  NotFoundException(this.msg);

  @override
  String getFriendlyErrorString(AppLocalizations loc) {
    return loc.errNotFound;
  }
}

class BadRequestException implements APIException {
  String msg;
  BadRequestException(this.msg);

  @override
  String getFriendlyErrorString(AppLocalizations loc) {
    return loc.errBadRequest;
  }
}

class InternalServerErrorException implements APIException {
  String msg;
  InternalServerErrorException(this.msg);

  @override
  String getFriendlyErrorString(AppLocalizations loc) {
    return loc.errInternalServerError;
  }
}

class UnauthorizedException implements APIException {
  String msg;
  UnauthorizedException(this.msg);

  @override
  String getFriendlyErrorString(AppLocalizations loc) {
    return loc.errUnauthorized;
  }
}

class ForbiddenException implements APIException {
  String msg;
  ForbiddenException(this.msg);

  @override
  String getFriendlyErrorString(AppLocalizations loc) {
    return loc.errForbidden;
  }
}

class GenericAPIException implements APIException {
  String msg;
  GenericAPIException(this.msg);

  @override
  String getFriendlyErrorString(AppLocalizations loc) {
    return msg;
  }
}
