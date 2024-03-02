import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../entities/entities.dart';
import 'draggable.dart';

class SDragTargetArea<T extends Object> extends StatefulWidget {
  const SDragTargetArea({
    super.key,
    required this.builder,
    this.onWillAcceptWithDetails,
    this.onAcceptWithDetails,
    this.onLeave,
    this.onMove,
    this.hitTestBehavior = HitTestBehavior.translucent,
  });

  final SDragTargetBuilder<T> builder;

  final SDragTargetWillAcceptWithDetails<T>? onWillAcceptWithDetails;

  final SDragTargetAcceptWithDetails<T>? onAcceptWithDetails;

  final SDragTargetLeave<T>? onLeave;

  final SDragTargetMove<T>? onMove;

  final HitTestBehavior hitTestBehavior;

  @override
  State<SDragTargetArea<T>> createState() => SDragTargetAreaState<T>();
}

List<T?> _mapAvatarsToData<T extends Object>(
  List<SDragAvatar<Object>> avatars,
) {
  return avatars
      .map<T?>((SDragAvatar<Object> avatar) => avatar.data as T?)
      .toList();
}

class SDragTargetAreaState<T extends Object> extends State<SDragTargetArea<T>> {
  final List<SDragAvatar<Object>> _candidateAvatars = <SDragAvatar<Object>>[];
  final List<SDragAvatar<Object>> _rejectedAvatars = <SDragAvatar<Object>>[];

  RenderBox get renderBox => context.findRenderObject() as RenderBox;

  bool isExpectedDataType(Object? data, Type type) {
    if (kIsWeb &&
        ((type == int && T == double) || (type == double && T == int))) {
      return false;
    }
    return data is T?;
  }

  bool didEnter(SDragAvatar<Object> avatar) {
    assert(!_candidateAvatars.contains(avatar));
    assert(!_rejectedAvatars.contains(avatar));
    final bool hasNoAcceptCallbacks = widget.onWillAcceptWithDetails == null;

    final bool willAcceptWithDetails = widget.onWillAcceptWithDetails != null &&
        widget.onWillAcceptWithDetails!(
          SDragTargetDetails<T>(
            data: avatar.data! as T,
            offset: avatar.finalLastPosition,
          ),
        );

    final bool resolvedWillAccept =
        hasNoAcceptCallbacks || willAcceptWithDetails;

    if (resolvedWillAccept) {
      setState(() {
        _candidateAvatars.add(avatar);
      });
      return true;
    } else {
      setState(() {
        _rejectedAvatars.add(avatar);
      });
      return false;
    }
  }

  void didLeave(SDragAvatar<Object> avatar) {
    assert(_candidateAvatars.contains(avatar) ||
        _rejectedAvatars.contains(avatar));
    if (!mounted) {
      return;
    }
    setState(() {
      _candidateAvatars.remove(avatar);
      _rejectedAvatars.remove(avatar);
    });
    widget.onLeave?.call(avatar.data as T?);
  }

  bool didDrop(SDragAvatar<Object> avatar) {
    assert(_candidateAvatars.contains(avatar));
    if (!mounted) {
      return false;
    }
    setState(() {
      _candidateAvatars.remove(avatar);
    });

    return widget.onAcceptWithDetails?.call(
          SDragTargetDetails<T>(
            data: avatar.data! as T,
            offset: avatar.position + avatar.feedbackRect.topLeft,
          ),
        ) ??
        false;
  }

  void didMove(SDragAvatar<Object> avatar) {
    if (!mounted) {
      return;
    }
    widget.onMove?.call(
      SDragTargetDetails<T>(
        data: avatar.data! as T,
        offset: avatar.lastOffset,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MetaData(
      metaData: this,
      behavior: widget.hitTestBehavior,
      child: widget.builder(
        context,
        _mapAvatarsToData<T>(
          _candidateAvatars,
        ),
        _mapAvatarsToData<Object>(
          _rejectedAvatars,
        ),
      ),
    );
  }
}
