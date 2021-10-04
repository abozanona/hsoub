import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hsoub/screens/widgets/widgets.dart';
import 'package:hsoub/themes/app_theme.dart';
import '../bloc/home_bloc.dart';

class CommunitiesTab extends StatefulWidget {
  const CommunitiesTab({Key? key}) : super(key: key);

  @override
  _CommunitiesTabState createState() => _CommunitiesTabState();
}

class _CommunitiesTabState extends State<CommunitiesTab> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (BuildContext context) => HomeBloc()
        ..add(
          GetCommunitiesEvent(),
        ),
      child: BlocConsumer<HomeBloc, HomeState>(
          listener: (BuildContext context, HomeState state) {},
          builder: (BuildContext context, HomeState state) {
            return Container(
              color: const Color(AppTheme.backgroundColor),
              child: ListView.builder(
                itemCount: HomeBloc.get(context).communities.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 5,
                    ),
                    child: communityOuter(HomeBloc.get(context).communities[index], context),
                  );
                },
              ),
            );
          }),
    );
  }
}
