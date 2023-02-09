import 'package:flutter/material.dart';

class KeepAliveFutureBuilder extends StatefulWidget {
  const KeepAliveFutureBuilder({required this.future, required this.builder});
  final Future future;
  final AsyncWidgetBuilder builder;

  @override
  KeepAliveFutureBuilderState createState() => KeepAliveFutureBuilderState();
}

class KeepAliveFutureBuilderState extends State<KeepAliveFutureBuilder>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.future,
      builder: widget.builder,
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class KeepAliveStreamBuilder extends StatefulWidget {
  const KeepAliveStreamBuilder({required this.stream, required this.builder});
  final Stream stream;
  final AsyncWidgetBuilder builder;

  @override
  KeepAliveStreamBuilderState createState() => KeepAliveStreamBuilderState();
}

class KeepAliveStreamBuilderState extends State<KeepAliveStreamBuilder>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.stream,
      builder: widget.builder,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
