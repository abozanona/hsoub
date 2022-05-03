import 'dart:convert';
import 'package:logger/logger.dart';

import 'package:hsoub/api/response_enums.dart';
import 'package:hsoub/models/community.dart';
import 'package:hsoub/models/logged_in_user.dart';
import 'package:hsoub/models/post.dart';
import 'package:dio/dio.dart';
import 'data_extractor.dart';
import 'endpoints.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';

class CustomerServer {
  static final CookieJar cookieJar = CookieJar();
  static String? csrfToken;

  static Future<String> _getCsrfToken() async {
    if (csrfToken != null) {
      return csrfToken!;
    }
    var dio = Dio();
    dio.interceptors.add(CookieManager(cookieJar));
    Response response = await dio.get(
      Endpoints.hsoubHome(),
    );
    csrfToken = DataExtractor.getCSRFToken(response.toString());
    return csrfToken!;
  }

  static Future<LoginResult> login(String userName, String password) async {
    var dio = Dio();
    dio.interceptors.add(CookieManager(cookieJar));
    Response response;

    String client_id = '';
    String state = '';

    try {
      response = await dio.get(
        Endpoints.hsoubHome(),
      );
    } catch (ex, trace) {
      var logger = Logger();
      logger.e(ex.toString());
      logger.e(trace.toString());
      return LoginResult.loginException;
    }

    String loginLink1 = DataExtractor.getLoginLink(response.toString());
    try {
      response = await dio.get(
        loginLink1,
      );
    } catch (ex, trace) {
      var logger = Logger();
      logger.e(ex.toString());
      logger.e(trace.toString());
      return LoginResult.loginException;
    }

    response.redirects.forEach((redirect) {
      String location = redirect.location.toString();
      if (location.contains("client_id")) {
        final regexClientId = RegExp(r'client_id=(.*)&redirect_uri');
        final matchClientId = regexClientId.firstMatch(location);
        if (matchClientId != null) {
          client_id = matchClientId.group(1) ?? '';
        }
        final regexState = RegExp(r'state=(.*)');
        final matchState = regexState.firstMatch(location);
        if (matchState != null) {
          state = matchState.group(1) ?? '';
        }
      }
    });

    var formData = FormData.fromMap({
      'source': 'io',
      'user': {
        'email': userName,
        'password': password,
      },
    });
    try {
      response = await dio.post(
        Endpoints.hsoubLogin(),
        data: formData,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {},
        ),
      );
    } on DioError catch (ex, trace) {
      var logger = Logger();
      logger.e(ex.toString());
      logger.e(trace.toString());
      if (ex.response!.statusCode == 401) {
        return LoginResult.passwordError;
      }
      return LoginResult.loginException;
    }

    try {
      response = await dio.get(
        'https://accounts.hsoub.com/oauth/authorize?client_id=$client_id&redirect_uri=https%3A%2F%2Fio.hsoub.com%2Fusers%2Fauth%2Fhsoub%2Fcallback&response_type=code&state=$state',
      );
    } catch (ex, trace) {
      var logger = Logger();
      logger.e(ex.toString());
      logger.e(trace.toString());
      return LoginResult.loginException;
    }

    return LoginResult.loginSuccess;
  }

  static Future<List<Community>> loadComminities(List<int> ids) async {
    var dio = Dio();
    dio.interceptors.add(CookieManager(cookieJar));
    var formData = FormData.fromMap({
      's': ' ',
      'keyword': ' ',
      'search_community_slug': ' ',
      'community_ids': ids.map((e) => e.toString()).toString(),
    });
    try {
      Response response = await dio.post(
        Endpoints.loadCommunities(),
        data: formData,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            'x-csrf-token': await _getCsrfToken(),
          },
        ),
      );
      return DataExtractor.getCommunities(response.data['content']);
    } catch (ex, trace) {
      var logger = Logger();
      logger.e(ex.toString());
      logger.e(trace.toString());
      return [];
    }
  }

  static Future<List<Post>> loadPosts(HomePagePostsType homePagePostsType, List<int> ids) async {
    var dio = Dio();
    dio.interceptors.add(CookieManager(cookieJar));
    var formData = FormData.fromMap({
      's': ' ',
      'keyword': ' ',
      'search_community_slug': ' ',
      'community_ids': ids.map((e) => e.toString()).toString(),
    });
    String url = Endpoints.loadPosts();
    switch (homePagePostsType) {
      case HomePagePostsType.defaultPosts:
        url = Endpoints.loadPosts();
        break;
      case HomePagePostsType.discussionsPosts:
        url = Endpoints.loadDiscussionsPosts();
        break;
      case HomePagePostsType.newPosts:
        url = Endpoints.loadNewPosts();
        break;
      case HomePagePostsType.topDayPosts:
        url = Endpoints.loadTopDayPosts();
        break;
      case HomePagePostsType.topWeekPosts:
        url = Endpoints.loadTopWeekPosts();
        break;
      case HomePagePostsType.topMonthPosts:
        url = Endpoints.loadTopMonthPosts();
        break;
      case HomePagePostsType.topYearPosts:
        url = Endpoints.loadTopYearPosts();
        break;
      case HomePagePostsType.topAllPosts:
        url = Endpoints.loadTopAllPosts();
        break;
    }
    try {
      Response response = await dio.post(
        url,
        data: formData,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            'x-csrf-token': await _getCsrfToken(),
          },
        ),
      );
      return DataExtractor.getPosts(response.data['content']);
    } catch (ex, trace) {
      var logger = Logger();
      logger.e(ex.toString());
      logger.e(trace.toString());
      return [];
    }
  }

  static Future<Post> loadPostPage(int id) async {
    var dio = Dio();
    dio.interceptors.add(CookieManager(cookieJar));
    try {
      Response response = await dio.get(
        Endpoints.loadPost(id),
        options: Options(
          headers: {
            'x-csrf-token': await _getCsrfToken(),
          },
        ),
      );
      return DataExtractor.getPost(response.data);
    } catch (ex, trace) {
      var logger = Logger();
      logger.e(ex.toString());
      logger.e(trace.toString());
      return Post();
    }
  }

  static Future<List<Post>> searchPosts(String query, SearchFilters searchFilter, List<int> ids) async {
    var dio = Dio();
    dio.interceptors.add(CookieManager(cookieJar));
    var data = {
      's': Uri.encodeComponent(query),
      'keyword': ' ',
      'search_community_slug': ' ',
      'in': 'posts',
      'community_ids': ids.map((e) => e.toString()).toString(),
    };
    switch (searchFilter) {
      case SearchFilters.postsRelevance:
        break;
      case SearchFilters.postsBest:
        data['filter'] = 'best';
        break;
      case SearchFilters.postsNew:
        data['filter'] = 'new';
        break;
    }
    var formData = FormData.fromMap(data);
    try {
      Response response = await dio.post(
        Endpoints.loadPosts(),
        data: formData,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            'x-csrf-token': await _getCsrfToken(),
          },
        ),
      );
      return DataExtractor.getPosts(response.data['content']);
    } catch (ex, trace) {
      var logger = Logger();
      logger.e(ex.toString());
      logger.e(trace.toString());
      return [];
    }
  }

  static Future<bool> addComment(int postId, String comment, {int? commentId}) async {
    var dio = Dio();
    dio.interceptors.add(CookieManager(cookieJar));
    var formData = FormData.fromMap({
      'comment': {
        'content': comment,
        'comment_id': commentId ?? ' ',
        'anonymous': '0',
      },
      'authenticity_token': csrfToken,
      'order': 'top',
    });
    try {
      Response response = await dio.post(
        Endpoints.addCommentToPost(postId),
        data: formData,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            'x-csrf-token': await _getCsrfToken(),
          },
        ),
      );
      return true;
    } catch (ex, trace) {
      var logger = Logger();
      logger.e(ex.toString());
      logger.e(trace.toString());
      return false;
    }
  }

  static Future<LoggedInUser> getLoggedInUserDate() async {
    var dio = Dio();
    dio.interceptors.add(CookieManager(cookieJar));
    cookieJar.loadForRequest(Uri.parse(Endpoints.getUserDate())).then((cookies) {
      var cookie = CookieManager.getCookies(cookies);
      if (cookie.isNotEmpty) {
        print('cookie: ' + cookie);
      }
    });
    String token = 'XOXOXOXO';
    try {
      Response response = await dio.get(
        Endpoints.getUserDate(),
        options: Options(
          contentType: Headers.jsonContentType,
          headers: {
            'authorization': 'Bearer ' + token,
          },
        ),
      );
      LoggedInUser loggedInUser = LoggedInUser();
      loggedInUser.email = response.data['email'];
      loggedInUser.birth_date = response.data['birth_date'];
      loggedInUser.first_name = response.data['first_name'];
      loggedInUser.last_name = response.data['last_name'];
      loggedInUser.avatar = response.data['avatar'];
      return loggedInUser;
    } catch (ex, trace) {
      var logger = Logger();
      logger.e(ex.toString());
      logger.e(trace.toString());
      return LoggedInUser();
    }
  }
}
