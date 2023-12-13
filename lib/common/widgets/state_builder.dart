// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class StateBuilder<BLOC extends StateStreamable<STATE>, STATE, BUILDABLE>
    extends StatelessWidget {
  late List<dynamic> Function(BUILDABLE) properties;
  final bool Function(BUILDABLE)? buildWhen;
  final Widget Function(BuildContext context, BUILDABLE buildable) builder;

  StateBuilder({
    Key? key,
    List<dynamic> Function(BUILDABLE)? properties,
    required this.builder,
    this.buildWhen,
  }) : super(key: key) {
    this.properties = properties ?? (state) => [state];
  }

  final Function equals = const DeepCollectionEquality().equals;

  @override
  Widget build(BuildContext context) {
    List<Object?>? built;
    return BlocBuilder<BLOC, STATE>(
      buildWhen: (_, current) {
        if (current is! BUILDABLE) return false;
        return !equals(built, properties(current)) &&
            (buildWhen == null || buildWhen!(current));
      },
      builder: (context, state) {
        built = properties(state as BUILDABLE);
        return builder(context, state);
      },
    );
  }
}
