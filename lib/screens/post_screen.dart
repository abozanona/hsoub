import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hsoub/models/comment.dart';
import 'package:hsoub/models/post.dart';
import 'package:hsoub/screens/widgets/widgets.dart';
import 'package:hsoub/themes/app_theme.dart';
import 'bloc/home_bloc.dart';

class PostScreen extends StatefulWidget {
  final int id;
  const PostScreen(this.id, {Key? key}) : super(key: key);

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (BuildContext context) => HomeBloc()
        //TODO: Change this later
        ..add(
          // GetPostEvent(widget.id),
          GetPostEvent(45758),
        ),
      child: BlocConsumer<HomeBloc, HomeState>(
        listener: (BuildContext context, HomeState state) {
          if (state is AddCommentOnPostState || state is AddCommentOnCommentState) {
            HomeBloc.get(context).add(GetPostEvent(widget.id));
            //TODO: Change this later
            HomeBloc.get(context).add(GetPostEvent(45758));
          }
          if (state is UpvotePostState || state is DownvotePostState) {
            HomeBloc.get(context).add(GetPostEvent(widget.id));
            //TODO: Change this later
            HomeBloc.get(context).add(GetPostEvent(45758));
          }
          if (state is UpvoteCommentState || state is DownvoteCommentState) {
            HomeBloc.get(context).add(GetPostEvent(widget.id));
            //TODO: Change this later
            HomeBloc.get(context).add(GetPostEvent(45758));
          }
        },
        builder: (BuildContext context, HomeState state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                HomeBloc.get(context).currentPagePost != null ? HomeBloc.get(context).currentPagePost!.title : 'Arabia I/O',
                style: AppTheme.textStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: HomeBloc.get(context).currentPagePost == null
                ? Container(
                    color: const Color(AppTheme.backgroundColor),
                    alignment: Alignment.center,
                    child: const Text(
                      "Content is loading",
                    ),
                  )
                : Container(
                    color: const Color(AppTheme.backgroundColor),
                    child: ListView.builder(
                      itemCount: generateContent(HomeBloc.get(context).currentPagePost!).length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 5,
                          ),
                          child: generateContent(HomeBloc.get(context).currentPagePost!)[index],
                        );
                      },
                    ),
                  ),
          );
        },
      ),
    );
  }

  List<Widget> commentsWidgets = [];
  List<Widget> generateContent(Post post) {
    commentsWidgets.add(PostContent(post, context));
    for (int i = 0; i < post.comments.length; i++) {
      generateCommentsContent(post.comments[i], context);
    }
    return commentsWidgets;
  }

  generateCommentsContent(Comment comment, BuildContext contenxt) {
    commentsWidgets.add(PostComment(comment, context));
    for (int i = 0; i < comment.comments.length; i++) {
      generateCommentsContent(comment.comments[i], contenxt);
    }
  }
}
