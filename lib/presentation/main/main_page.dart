import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gulim/common/di/injection.dart';
import 'package:gulim/presentation/main/cubit/main_cubit.dart';
import 'package:gulim/presentation/main/main_view.dart';

@RoutePage()
class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MainCubit>(
      create: (context) => getIt<MainCubit>(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: const Text(
            'Mohirlab',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: const SafeArea(child: MainView()),
      ),
    );
  }
}
