import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:halfdot/models/api/common.dart';
import 'package:intl/intl.dart';

abstract class ApiRequest {
  Uri getRequestUrl();
  Future<ApiModel> doRequest();
}

enum GroupingUnit {
  hour('hour'),
  day('day'),
  month('month'),
  year('year');

  const GroupingUnit(this.value);
  final String value;
}

DateTime initialDateTime = DateTime(2010, 01, 01);

class DateTimeInterval {
  DateTimeInterval(this.startAt, this.endAt);

  DateTime startAt;
  DateTime endAt;

  @override
  String toString() {
    return 'start_at=${startAt.millisecondsSinceEpoch}&end_at=${endAt.millisecondsSinceEpoch}';
  }

  String getPretty(String? locale) {
    return '${getPrettyStart(locale)} — ${getPrettyEnd(locale)}';
  }

  String getPrettyStart(String? locale) {
    if (locale == null) {
      return '${startAt.year}/${startAt.month}/${startAt.day}';
    }
    DateTime dateTime = DateTime(startAt.year, startAt.month, startAt.day);
    return DateFormat.yMd(locale).format(dateTime);
  }

  String getPrettyEnd(String? locale) {
    if (locale == null) {
      return '${endAt.year}/${endAt.month}/${endAt.day}';
    }
    DateTime dateTime = DateTime(endAt.year, endAt.month, endAt.day);
    return DateFormat.yMd(locale).format(dateTime);
  }

  int getNumDays() {
    return endAt.difference(startAt).inDays + 1;
  }

  Map<String, String> toMap() {
    return <String, String>{
      'start_at': startAt.millisecondsSinceEpoch.toString(),
      'end_at': endAt.millisecondsSinceEpoch.toString(),
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
  TimestampedEntry(this.dateTime, this.number);

  TimestampedEntry.fromJson(Map<String, dynamic> json)
      : dateTime = DateTime.parse(json['t']),
        number = json['y'];

  final DateTime dateTime;
  final int number;

  toMap() {
    return <String, dynamic>{'t': dateTime.toString(), 'y': number};
  }

  @override
  String toString() {
    return toMap().toString();
  }
}

Map<String, String> makeAccessTokenHeader(String accessToken) {
  return <String, String>{'Authorization': 'Bearer $accessToken'};
}

bool isResponseOk(Response response) {
  return response.statusCode == 200 || response.statusCode == 201;
}

Exception getApiException(int statusCode, String msg) {
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
      return GenericApiException('http error: $statusCode');
  }
}

abstract class ApiException implements Exception {
  String getFriendlyErrorString(AppLocalizations loc);
}

class NotFoundException implements ApiException {
  NotFoundException(this.msg);
  String msg;

  @override
  String getFriendlyErrorString(AppLocalizations loc) {
    return loc.errNotFound;
  }
}

class BadRequestException implements ApiException {
  BadRequestException(this.msg);
  String msg;

  @override
  String getFriendlyErrorString(AppLocalizations loc) {
    return loc.errBadRequest;
  }
}

class InternalServerErrorException implements ApiException {
  InternalServerErrorException(this.msg);
  String msg;

  @override
  String getFriendlyErrorString(AppLocalizations loc) {
    return loc.errInternalServerError;
  }
}

class UnauthorizedException implements ApiException {
  UnauthorizedException(this.msg);
  String msg;

  @override
  String getFriendlyErrorString(AppLocalizations loc) {
    return loc.errUnauthorized;
  }
}

class ForbiddenException implements ApiException {
  ForbiddenException(this.msg);
  String msg;

  @override
  String getFriendlyErrorString(AppLocalizations loc) {
    return loc.errForbidden;
  }
}

class GenericApiException implements ApiException {
  GenericApiException(this.msg);
  String msg;

  @override
  String getFriendlyErrorString(AppLocalizations loc) {
    return msg;
  }
}

String handleSnapshotError(BuildContext context, Object? error) {
  switch (error.runtimeType) {
    case ApiException:
      return (error as ApiException).getFriendlyErrorString(
        AppLocalizations.of(context)!,
      );
    case TimeoutException:
      return AppLocalizations.of(context)!.errTimeout;
  }
  return 'Error';
}
