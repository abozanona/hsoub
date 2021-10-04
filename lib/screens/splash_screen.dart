import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/home_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (BuildContext context) => HomeBloc(),
      child: BlocConsumer<HomeBloc, HomeState>(
          listener: (BuildContext context, HomeState state) {},
          builder: (BuildContext context, HomeState state) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Hsoub'),
              ),
              body: Container(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: const <Widget>[
                    Text("2222"),
                    Text("3333"),
                    Text("4444"),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
