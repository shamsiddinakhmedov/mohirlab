import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StateListener<BLOC extends StateStreamable<STATE>, STATE, LISTENABLE>
    extends StatelessWidget {
  const StateListener({
    super.key,
    this.listenWhen,
    required this.listener, this.child,
  });

  final bool Function(LISTENABLE)? listenWhen;
  final Function(LISTENABLE) listener;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<BLOC, STATE>(
      listenWhen: (previous, current) {
        return current is LISTENABLE && (listenWhen?.call(current) ?? true);
      },
      listener: (context, state) {
        listener(state as LISTENABLE);
      },
      child: child,
    );
  }
}
