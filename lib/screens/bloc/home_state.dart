part of 'home_bloc.dart';

// @immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class ResponseState extends HomeInitial {
  ResponseState();
}

class GetCommunitiesState extends HomeInitial {
  GetCommunitiesState();
}

class GetPostsState extends HomeInitial {
  GetPostsState();
}

class SearchPostsState extends HomeInitial {
  SearchPostsState();
}

class GetPostState extends HomeInitial {
  GetPostState();
}

class SearchPostState extends HomeInitial {
  SearchPostState();
}

class UserLoginState extends HomeInitial {
  UserLoginState();
}

class UserLoginErrorState extends HomeInitial {
  final LoginResult loginResult;
  UserLoginErrorState(this.loginResult);
}

class AddCommentOnPostState extends HomeInitial {
  AddCommentOnPostState();
}

class AddCommentOnCommentState extends HomeInitial {
  AddCommentOnCommentState();
}

class UpvotePostState extends HomeInitial {
  UpvotePostState();
}

class DownvotePostState extends HomeInitial {
  DownvotePostState();
}

class UpvoteCommentState extends HomeInitial {
  UpvoteCommentState();
}

class DownvoteCommentState extends HomeInitial {
  DownvoteCommentState();
}

class LoggedInUserDateState extends HomeInitial {
  LoggedInUserDateState();
}
