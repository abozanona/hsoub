import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hsoub/api/response_enums.dart';
import 'package:hsoub/screens/widgets/widgets.dart';
import 'package:hsoub/themes/app_theme.dart';
import '../bloc/home_bloc.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

class PostsTab extends StatefulWidget {
  final HomePagePostsType homePagePostsType;

  const PostsTab(this.homePagePostsType, {Key? key}) : super(key: key);

  @override
  _PostsTabState createState() => _PostsTabState();
}

class _PostsTabState extends State<PostsTab> {
  bool isLoading = false;
  void loadMore() {
    if (isLoading) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    HomeBloc.get(context).add(GetPostsEvent(widget.homePagePostsType));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (BuildContext context) => HomeBloc()
        ..add(
          GetPostsEvent(widget.homePagePostsType),
        ),
      child: BlocConsumer<HomeBloc, HomeState>(listener: (BuildContext context, HomeState state) {
        if (state is GetPostsState) {
          setState(() {
            isLoading = false;
          });
        }
      }, builder: (BuildContext context, HomeState state) {
        return Container(
          color: const Color(AppTheme.backgroundColor),
          child: LazyLoadScrollView(
            onEndOfPage: () {
              loadMore();
            },
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: HomeBloc.get(context).posts.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 5,
                  ),
                  child: postOuter(HomeBloc.get(context).posts[index], context),
                );
              },
            ),
          ),
        );
      }),
    );
  }
}
