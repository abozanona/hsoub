import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hsoub/api/response_enums.dart';
import 'package:hsoub/screens/search_screen.dart';
import 'package:hsoub/screens/tabs/communities_tab.dart';
import 'package:hsoub/screens/tabs/posts_tab.dart';
import 'package:hsoub/themes/app_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'bloc/home_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (BuildContext context) => HomeBloc()
        ..add(
          LoggedInUserDateEvent(),
        ),
      child: BlocConsumer<HomeBloc, HomeState>(
        listener: (BuildContext context, HomeState state) {},
        builder: (BuildContext context, HomeState state) {
          return DefaultTabController(
            length: 9,
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  "Arabia I/O",
                  style: AppTheme.textStyle(
                    color: Colors.white,
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const SearchScreen(),
                        ));
                      },
                    ),
                  ),
                ],
                bottom: TabBar(
                  isScrollable: true,
                  labelStyle: AppTheme.textStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelStyle: AppTheme.textStyle(
                    fontSize: 12,
                  ),
                  indicatorColor: Colors.white,
                  tabs: const [
                    Tab(
                      text: "الأكثر شيوعاً",
                    ),
                    Tab(
                      text: "النقاشات",
                    ),
                    Tab(
                      text: "الأحدث",
                    ),
                    Tab(
                      text: "هذا اليوم",
                    ),
                    Tab(
                      text: "هذا الأسبوع",
                    ),
                    Tab(
                      text: "هذا الشهر",
                    ),
                    Tab(
                      text: "هذه السنة",
                    ),
                    Tab(
                      text: "من البداية",
                    ),
                    Tab(
                      text: "المجتمعات",
                    ),
                  ],
                ),
              ),
              drawer: Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    Stack(
                      children: [
                        Container(
                          height: 130,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Color(AppTheme.primary),
                          ),
                        ),
                        Container(
                          height: 170,
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          top: 80,
                          bottom: 0,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                              HomeBloc.get(context).loggedInUserDate.avatar,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      HomeBloc.get(context).loggedInUserDate.first_name + ' ' + HomeBloc.get(context).loggedInUserDate.last_name,
                      style: AppTheme.textStyle(
                        color: const Color(
                          AppTheme.linkText,
                        ),
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    ListTile(
                      leading: const Icon(Icons.folder_outlined),
                      title: Text(
                        AppLocalizations.of(context)!.sideBarUserProfile,
                        style: AppTheme.textStyle(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: const Icon(Icons.favorite_outline),
                      title: Text(
                        'المفضلة',
                        style: AppTheme.textStyle(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: const Icon(Icons.notifications_outlined),
                      title: Text(
                        'التنبيهات',
                        style: AppTheme.textStyle(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: const Icon(Icons.email_outlined),
                      title: Text(
                        'الرسائل',
                        style: AppTheme.textStyle(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: const Icon(Icons.settings_outlined),
                      title: Text(
                        'الإعدادات',
                        style: AppTheme.textStyle(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      onTap: () {},
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.help_outline),
                      title: Text(
                        'عن الموقع',
                        style: AppTheme.textStyle(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: const Icon(Icons.copy),
                      title: Text(
                        'الأسئلة الشائعة',
                        style: AppTheme.textStyle(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: const Icon(Icons.check_outlined),
                      title: Text(
                        'ارشادات الاستخدام',
                        style: AppTheme.textStyle(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: const Icon(Icons.article_outlined),
                      title: Text(
                        'بيان الخصوصية',
                        style: AppTheme.textStyle(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: const Icon(Icons.phone_outlined),
                      title: Text(
                        'اتصل بنا',
                        style: AppTheme.textStyle(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      onTap: () {},
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.arrow_forward_outlined),
                      title: Text(
                        'تسجيل الخروج',
                        style: AppTheme.textStyle(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              body: TabBarView(
                children: <Widget>[
                  PostsTab(HomePagePostsType.defaultPosts, key: GlobalKey()),
                  PostsTab(HomePagePostsType.discussionsPosts, key: GlobalKey()),
                  PostsTab(HomePagePostsType.newPosts, key: GlobalKey()),
                  PostsTab(HomePagePostsType.topDayPosts, key: GlobalKey()),
                  PostsTab(HomePagePostsType.topWeekPosts, key: GlobalKey()),
                  PostsTab(HomePagePostsType.topMonthPosts, key: GlobalKey()),
                  PostsTab(HomePagePostsType.topYearPosts, key: GlobalKey()),
                  PostsTab(HomePagePostsType.topAllPosts, key: GlobalKey()),
                  const CommunitiesTab(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
