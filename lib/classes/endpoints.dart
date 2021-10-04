class Endpoints {
  static Duration timeout = const Duration(seconds: 30);

  static const String _baseUrl = "https://io.hsoub.com";

  static String loadComminities() {
    return '$_baseUrl/communities/load_more.json';
  }

  static String loadPosts() {
    return '$_baseUrl/load_more.json';
  }

  static String searchPosts() {
    return '$_baseUrl/search/load_more.json';
  }

  static String loadDiscussionsPosts() {
    return '$_baseUrl/discussions/load_more.json';
  }

  static String loadNewPosts() {
    return '$_baseUrl/new/load_more.json';
  }

  static String loadTopDayPosts() {
    return '$_baseUrl/top/day/load_more.json';
  }

  static String loadTopWeekPosts() {
    return '$_baseUrl/top/week/load_more.json';
  }

  static String loadTopMonthPosts() {
    return '$_baseUrl/top/month/load_more.json';
  }

  static String loadTopYearPosts() {
    return '$_baseUrl/top/year/load_more.json';
  }

  static String loadTopAllPosts() {
    return '$_baseUrl/top/month/load_more.json';
  }

  static String loadCommunities() {
    return '$_baseUrl/communities/active/load_more.json';
  }

  static String loadPost(int postId) {
    return '$_baseUrl/foo/$postId';
  }

  static String hsoubHome() {
    return '$_baseUrl/';
  }

  static String hsoubLogin() {
    return 'https://accounts.hsoub.com/api/login';
  }

  static String getUserDate() {
    return 'https://accounts.hsoub.com/api/account';
  }

  static String addCommentToPost(int postId) {
    return '$_baseUrl/posts/$postId-foo/comments';
  }

  static String upvotePost(int postId) {
    return '$_baseUrl/post/$postId/upvote.json';
  }

  static String downvotePost(int postId) {
    return '$_baseUrl/post/$postId/downvote.json';
  }

  static String upvoteComment(int postId, int commentId) {
    return '$_baseUrl/post/$postId/comments/$commentId/upvote.json';
  }

  static String downvoteComment(int postId, int commentId) {
    return '$_baseUrl/post/$postId/comments/$commentId/downvote.json';
  }
}
