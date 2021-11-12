import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:salon/repository.dart';

class Finish extends StatefulWidget {
  final bool value;
  Finish(this.value, {Key key}) : super(key: key);

  @override
  _FinishState createState() => _FinishState();
}

class _FinishState extends State<Finish> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LottieBuilder.asset(
      widget.value
          ? 'assets/json/process-success.json'
          : 'assets/json/process-failed.json',
      frameBuilder: (context, child, composition) => Padding(
        child: child,
        padding: EdgeInsets.all(100),
      ),
      controller: _controller,
      onLoaded: (composition) {
        _controller
          ..duration = composition.duration
          ..forward().then(repo.app.navi.pop);
      },
    );
  }
}
