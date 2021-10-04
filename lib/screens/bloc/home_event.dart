part of 'home_bloc.dart';

// @immutable
abstract class HomeEvent {}

class GetCommunitiesEvent extends HomeEvent {}

class GetPostsEvent extends HomeEvent {
  HomePagePostsType homePagePostsType;
  GetPostsEvent(this.homePagePostsType);
}

class SearchPostsEvent extends HomeEvent {
  String query;
  SearchFilters searchFilters;
  SearchPostsEvent(this.query, this.searchFilters);
}

class GetPostEvent extends HomeEvent {
  int id;
  GetPostEvent(this.id);
}

class UserLoginEvent extends HomeEvent {
  String email;
  String password;
  UserLoginEvent(this.email, this.password);
}

class AddCommentOnPostEvent extends HomeEvent {
  int postId;
  String comment;
  AddCommentOnPostEvent(this.postId, this.comment);
}

class AddCommentOnCommentEvent extends HomeEvent {
  int postId;
  int commentId;
  String comment;
  AddCommentOnCommentEvent(this.postId, this.commentId, this.comment);
}

class UpvotePostEvent extends HomeEvent {
  int postId;
  UpvotePostEvent(this.postId);
}

class DownvotePostEvent extends HomeEvent {
  int postId;
  DownvotePostEvent(this.postId);
}

class UpvoteCommentEvent extends HomeEvent {
  int postId;
  int commentId;
  UpvoteCommentEvent(this.postId, this.commentId);
}

class DownvoteCommentEvent extends HomeEvent {
  int postId;
  int commentId;
  DownvoteCommentEvent(this.postId, this.commentId);
}

class LoggedInUserDateEvent extends HomeEvent {
  LoggedInUserDateEvent();
}
