import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hsoub/api/response_enums.dart';
import 'package:hsoub/classes/search_filter_item.dart';
import 'package:hsoub/screens/tabs/search_posts_tab.dart';
import 'package:hsoub/themes/app_theme.dart';
import 'bloc/home_bloc.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _filter = TextEditingController();
  bool showFilter = false;
  SearchFilters selectedSearchFilter = SearchFilters.postsRelevance;

  search(context) {
    HomeBloc.get(context).add(SearchPostsEvent(_filter.text, selectedSearchFilter));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (BuildContext context) => HomeBloc(),
      child: BlocConsumer<HomeBloc, HomeState>(
        listener: (BuildContext context, HomeState state) {},
        builder: (BuildContext context, HomeState state) {
          return Scaffold(
            appBar: AppBar(
              title: TextField(
                controller: _filter,
                style: AppTheme.textStyle(
                  color: Colors.white,
                ),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'ابحث عن...',
                  hintStyle: AppTheme.textStyle(
                    color: Colors.white,
                  ),
                ),
                onSubmitted: (query) {
                  search(context);
                },
              ),
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      search(context);
                    },
                  ),
                ),
              ],
            ),
            body: SizedBox(
              width: double.infinity,
              child: !showFilter
                  ? Column(
                      children: [
                        const SizedBox(height: 4),
                        InkWell(
                          onTap: () {
                            setState(() {
                              showFilter = true;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey,
                            ),
                            child: Icon(Icons.filter_alt_outlined),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Wrap(
                          direction: Axis.horizontal,
                          alignment: WrapAlignment.spaceEvenly,
                          children: [
                            SearchFilterItem("المواضيع الأكثر ملائمة", SearchFilters.postsRelevance),
                            SearchFilterItem("المواضيع الأفضل", SearchFilters.postsBest),
                            SearchFilterItem("المواضيع الأحدث", SearchFilters.postsNew),
                            // SearchFilterItem("التعليقات الأكثر ملائمة", SearchFilters.commentsRelevance),
                            // SearchFilterItem("التعليقات الأفضل", SearchFilters.commentsBest),
                            // SearchFilterItem("التعليقات الأحدث", SearchFilters.commentsNew),
                            // SearchFilterItem("المجتمعات الأكثر ملائمة", SearchFilters.communitiesRelevance),
                            // SearchFilterItem("المجتمعات الأفضل", SearchFilters.communitiesBest),
                            // SearchFilterItem("المجتمعات الأحدث", SearchFilters.communitiesNew),
                            // SearchFilterItem("المستخدمين الأكثر ملائمة", SearchFilters.usersRelevance),
                            // SearchFilterItem("المستخدمين الأفضل", SearchFilters.usersBest),
                          ]
                              .map((SearchFilterItem item) => Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          selectedSearchFilter = item.searchFilters;
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: selectedSearchFilter == item.searchFilters ? null : const Color(AppTheme.secondary),
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                        ),
                                      ),
                                      child: Text(
                                        item.name,
                                        style: AppTheme.textStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              showFilter = false;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey,
                            ),
                            child: const Icon(Icons.close),
                          ),
                        ),
                        SearchPostsTab(HomeBloc.get(context).searchposts),
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }
}
