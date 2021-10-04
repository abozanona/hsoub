import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hsoub/api/response_enums.dart';
import 'package:hsoub/models/post.dart';
import 'package:hsoub/screens/widgets/widgets.dart';
import 'package:hsoub/themes/app_theme.dart';
import '../bloc/home_bloc.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

class SearchPostsTab extends StatefulWidget {
  final List<Post> posts;

  const SearchPostsTab(this.posts, {Key? key}) : super(key: key);

  @override
  _SearchPostsTabState createState() => _SearchPostsTabState();
}

class _SearchPostsTabState extends State<SearchPostsTab> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (BuildContext context) => HomeBloc(),
      child: BlocConsumer<HomeBloc, HomeState>(
          listener: (BuildContext context, HomeState state) {},
          builder: (BuildContext context, HomeState state) {
            return Container(
              color: const Color(AppTheme.backgroundColor),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: widget.posts.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 5,
                    ),
                    child: postOuter(widget.posts[index], context),
                  );
                },
              ),
            );
          }),
    );
  }
}
