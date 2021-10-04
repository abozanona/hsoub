import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hsoub/api/response_enums.dart';
import 'package:hsoub/classes/customer_server.dart';
import 'package:hsoub/models/community.dart';
import 'package:hsoub/models/logged_in_user.dart';
import 'package:hsoub/models/post.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  static HomeBloc get(BuildContext context) => BlocProvider.of(context);
  HomeBloc() : super(HomeInitial());

  List<int> loadedPostsIds = [];
  List<int> loadedSearchPostsIds = [];
  List<Post> posts = [];
  List<Post> searchposts = [];

  List<int> loadedCommunitiesIds = [];
  List<Community> communities = [];
  Post? currentPagePost;

  LoggedInUser loggedInUserDate = LoggedInUser();

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is GetPostsEvent) {
      yield* _getPosts(event.homePagePostsType);
    }
    if (event is SearchPostsEvent) {
      yield* _searchPosts(event.query, event.searchFilters);
    }
    if (event is GetCommunitiesEvent) {
      yield* _getCommunities();
    }
    if (event is GetPostEvent) {
      yield* _getPost(event.id);
    }
    if (event is AddCommentOnPostEvent) {
      yield* _addCommentOnPost(event.postId, event.comment);
    }
    if (event is AddCommentOnCommentEvent) {
      yield* _addCommentOnComment(event.postId, event.commentId, event.comment);
    }
    if (event is UserLoginEvent) {
      yield* _userLogin(event.email, event.password);
    }
    if (event is LoggedInUserDateEvent) {
      yield* _getLoggedInUserDate();
    }
  }

  Stream<HomeState> _getCommunities() async* {
    List<int> ids = [];
    // yield await (CustomerServer.loadComminities(ids)).then((res) {
    yield await (CustomerServer.loadComminities(loadedCommunitiesIds)).then((res) {
      if (res != null) {
        communities = res;
        for (var community in res) {
          loadedCommunitiesIds.add(community.id);
        }
        return GetCommunitiesState();
      } else {
        return ResponseState();
      }
    });
  }

  Stream<HomeState> _getPosts(HomePagePostsType homePagePostsType) async* {
    yield await (CustomerServer.loadPosts(homePagePostsType, loadedPostsIds)).then((res) {
      if (res != null) {
        posts.addAll(res);
        for (var post in res) {
          loadedPostsIds.add(post.id);
        }
        return GetPostsState();
      } else {
        return ResponseState();
      }
    });
  }

  Stream<HomeState> _searchPosts(String query, SearchFilters searchFilters) async* {
    yield await (CustomerServer.searchPosts(query, searchFilters, loadedPostsIds)).then((res) {
      if (res != null) {
        searchposts.addAll(res);
        for (var post in res) {
          loadedSearchPostsIds.add(post.id);
        }
        return SearchPostsState();
      } else {
        return ResponseState();
      }
    });
  }

  Stream<HomeState> _getPost(int id) async* {
    yield await (CustomerServer.loadPostPage(id)).then((res) {
      if (res != null) {
        currentPagePost = res;
        return GetPostState();
      } else {
        return ResponseState();
      }
    });
  }

  Stream<HomeState> _addCommentOnPost(int postId, String comment) async* {
    yield await (CustomerServer.addComment(postId, comment)).then((res) {
      if (res) {
        return AddCommentOnPostState();
      } else {
        return ResponseState();
      }
    });
  }

  Stream<HomeState> _addCommentOnComment(int postId, int commentId, String comment) async* {
    yield await (CustomerServer.addComment(postId, comment, commentId: commentId)).then((res) {
      if (res != null) {
        return AddCommentOnCommentState();
      } else {
        return ResponseState();
      }
    });
  }

  Stream<HomeState> _userLogin(String email, String password) async* {
    yield await (CustomerServer.login(email, password)).then((res) {
      if (res == LoginResult.loginSuccess) {
        return UserLoginState();
      } else if (res == LoginResult.passwordError) {
        return UserLoginErrorState(res);
      } else {
        return UserLoginErrorState(res);
      }
    });
  }

  Stream<HomeState> _getLoggedInUserDate() async* {
    yield await (CustomerServer.getLoggedInUserDate()).then((res) {
      if (res != null) {
        loggedInUserDate = res;
        return LoggedInUserDateState();
      } else {
        return ResponseState();
      }
    });
  }
}
