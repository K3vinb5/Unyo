import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:http/io_client.dart';
import 'package:http_interceptor/http_interceptor.dart';
import '../Eval/dart/model/m_source.dart';

class MClient {
  MClient();

  static final CookieJar cookieJar = CookieJar();

  static InterceptedClient init({
    MSource? source,
    Map<String, dynamic>? reqcopyWith,
  }) {
    return InterceptedClient.build(
      client: IOClient(HttpClient()),
      interceptors: [MCookieManager(reqcopyWith), LoggerInterceptor()],
    );
  }

  static Future<Map<String, String>> getCookiesPref(String url) async {
    final uri = Uri.parse(url);
    final cookies = await cookieJar.loadForRequest(uri);

    if (cookies.isEmpty) return {};

    final cookieString = cookies.map((c) => '${c.name}=${c.value}').join('; ');
    return {HttpHeaders.cookieHeader: cookieString};
  }

  static Future<void> setCookie(
    String url,
    String ua,
    dynamic controller, { // No specific controller type needed
    String? cookie,
  }) async {
    final Uri uri = Uri.parse(url);
    List<Cookie> cookieList = [];

    if (cookie != null && cookie.isNotEmpty) {
      final List<String> cookieStrings = cookie
          .split(RegExp('(?<=)(,)(?=[^;]+?=)'))
          .where((cookie) => cookie.isNotEmpty)
          .toList();

      for (final cookieStr in cookieStrings) {
        try {
          final parts = cookieStr.split('=');
          if (parts.length >= 2) {
            final name = parts[0].trim();
            final value = parts.sublist(1).join('=').split(';')[0].trim();
            cookieList.add(Cookie(name, value));
          }
        } catch (e) {
          debugPrint('Error parsing cookie: $e');
        }
      }
    }

    if (cookieList.isNotEmpty) {
      // Store cookies in cookie jar
      await cookieJar.saveFromResponse(uri, cookieList);

      // For compatibility with existing code, also store as string
      final host = uri.host;
      final cookiesMap = {}; //loadData(PrefName.cookies);
      cookiesMap.removeWhere((key, value) => key == host || host.contains(key));
      cookiesMap[host] = cookieList.map((c) => '${c.name}=${c.value}').join('; ');
      //saveData(PrefName.cookies, cookiesMap);
    }

    if (ua.isNotEmpty) {
      //saveData(PrefName.userAgent, ua);
    }
  }

  static void deleteAllCookies(String url) {
    final uri = Uri.parse(url);
    cookieJar.deleteAll();

    // For compatibility with existing code
    final cookiesMap = {}; //loadData(PrefName.cookies);
    final urlHost = uri.host;
    cookiesMap.removeWhere(
      (host, cookie) => host == urlHost || urlHost.contains(host),
    );
    //saveData(PrefName.cookies, cookiesMap);
  }

  // static Future<void> setCookie(
  //   String url,
  //   String ua,
  //   flutter_inappwebview.InAppWebViewController? webViewController, {
  //   String? cookie,
  // }) async {
  //   List<String> cookies = [];
  //   if (Platform.isLinux) {
  //     cookies =
  //         cookie
  //             ?.split(RegExp('(?<=)(,)(?=[^;]+?=)'))
  //             .where((cookie) => cookie.isNotEmpty)
  //             .toList() ??
  //         [];
  //   } else {
  //     cookies =
  //         (await flutter_inappwebview.CookieManager.instance(
  //               webViewEnvironment: webViewEnvironment,
  //             ).getCookies(
  //               url: flutter_inappwebview.WebUri(url),
  //               webViewController: webViewController,
  //             ))
  //             .map((e) => "${e.name}=${e.value}")
  //             .toList();
  //   }
  //   if (cookies.isNotEmpty) {
  //     final host = Uri.parse(url).host;
  //     final newCookie = cookies.join("; ");
  //     final cookiesMap = {}; //loadData(PrefName.cookies);
  //     cookiesMap.removeWhere((key, value) => key == host || host.contains(key));
  //     cookiesMap[host] = newCookie;
  //     // saveData(PrefName.cookies, cookiesMap);
  //   }
  //   if (ua.isNotEmpty) {
  //     //saveData(PrefName.userAgent, ua);
  //   }
  // }

}

class MCookieManager extends InterceptorContract {
  MCookieManager(this.reqcopyWith);

  Map<String, dynamic>? reqcopyWith;

  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    final cookie = await MClient.getCookiesPref(request.url.toString());
    if (cookie.isNotEmpty) {
      final userAgent = ''; //loadData(PrefName.userAgent);
      if (request.headers[HttpHeaders.cookieHeader] == null) {
        request.headers.addAll(cookie);
      }
      if (request.headers[HttpHeaders.userAgentHeader] == null) {
        request.headers[HttpHeaders.userAgentHeader] = userAgent;
      }
    }
    try {
      if (reqcopyWith != null) {
        if (reqcopyWith!["followRedirects"] != null) {
          request.followRedirects = reqcopyWith!["followRedirects"];
        }
        if (reqcopyWith!["maxRedirects"] != null) {
          request.maxRedirects = reqcopyWith!["maxRedirects"];
        }
        if (reqcopyWith!["contentLength"] != null) {
          request.contentLength = reqcopyWith!["contentLength"];
        }
        if (reqcopyWith!["persistentConnection"] != null) {
          request.persistentConnection = reqcopyWith!["persistentConnection"];
        }
      }
    } catch (_) {}
    return request;
  }

  @override
  Future<BaseResponse> interceptResponse({
    required BaseResponse response,
  }) async {
    return response;
  }
}

class LoggerInterceptor extends InterceptorContract {
  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    debugPrint(
      '----- Request -----\n${request.toString()}\nheader: ${request.headers.toString()}',
    );
    return request;
  }

  @override
  Future<BaseResponse> interceptResponse({
    required BaseResponse response,
  }) async {
    final cloudflare =
        [403, 503].contains(response.statusCode) &&
        ["cloudflare-nginx", "cloudflare"].contains(response.headers["server"]);
    debugPrint(
      "----- Response -----\n${response.request?.method}: ${response.request?.url}, statusCode: ${response.statusCode} ${cloudflare ? "Failed to bypass Cloudflare" : ""}",
    );
    if (cloudflare) {
      debugPrint("${response.statusCode} Failed to bypass Cloudflare");
    }
    return response;
  }
}
