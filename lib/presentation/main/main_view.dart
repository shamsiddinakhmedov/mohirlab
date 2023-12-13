import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gulim/common/widgets/state_builder.dart';
import 'package:gulim/presentation/main/cubit/main_cubit.dart';
import 'package:gulim/presentation/main/widgets/scanner_widget.dart';
import 'package:image_picker/image_picker.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final bool _animationStopped = false;

  @override
  void initState() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animateScanAnimation(true);
      } else if (status == AnimationStatus.dismissed) {
        animateScanAnimation(false);
      }
    });
    animateScanAnimation(false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          width: width,
          height: width,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            child: Stack(
              children: [
                StateBuilder<MainCubit, MainState, MainBuildable>(
                  properties: (buildable) => [buildable.file],
                  builder: (context, state) {
                    return state.file != null
                        ? Image.file(
                            state.file!,
                            height: width,
                            width: width,
                            alignment: Alignment.center,
                          )
                        : Container(
                            width: width,
                            height: width,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.deepPurple),
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white,
                            ),
                          );
                  },
                ),
                StateBuilder<MainCubit, MainState, MainBuildable>(
                  properties: (buildable) => [buildable.scanning],
                  builder: (context, state) {
                    return state.scanning
                        ? ScannerAnimation(
                            _animationStopped,
                            width,
                            animation: _animationController,
                          )
                        : const SizedBox();
                  },
                )
              ],
            ),
          ),
        ),
        const Spacer(),
        StateBuilder<MainCubit, MainState, MainBuildable>(
          properties: (buildable) => [
            buildable.result,
            buildable.scanning,
          ],
          builder: (context, state) {
            if (state.result != null) {
              return Container(
                width: width,
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.red, Colors.red.withOpacity(0.4)],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(8),
                  ),
                ),
                child: Center(
                  child: Text(
                    state.result ?? '',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              );
            }
            return const SizedBox();
          },
        ),
        const Spacer(),
        Row(
          children: [
            Expanded(
              child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: const Icon(
                  Icons.camera_alt_outlined,
                  size: 36,
                  color: Colors.deepPurple,
                ),
                onTap: () => context
                    .read<MainCubit>()
                    .uploadImage(source: ImageSource.camera),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () => context
                    .read<MainCubit>()
                    .uploadImage(source: ImageSource.gallery),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: const Icon(
                  Icons.image_outlined,
                  size: 36,
                  color: Colors.deepPurple,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24)
      ],
    );
  }

  void animateScanAnimation(bool reverse) {
    if (reverse) {
      _animationController.reverse(from: 1.0);
    } else {
      _animationController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
