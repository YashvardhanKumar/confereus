import 'package:flutter/material.dart';

// class ContainerSize extends InheritedWidget {
//   const ContainerSize({required this.size, super.key, required super.child});
//   final Size size;
//
//   static ContainerSize? maybeOf(BuildContext context) => context.dependOnInheritedWidgetOfExactType<ContainerSize>();
//
//   static ContainerSize of(BuildContext context) {
//     final ContainerSize? res = maybeOf(context);
//     assert(res != null, 'No ContainerSize found in context');
//     return res!;
//   }
//
//   @override
//   bool updateShouldNotify(ContainerSize oldWidget) {
//     return size != oldWidget.size;
//   }
//
// }
// import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';


typedef OnWidgetSizeChange = void Function(Size size);

class MeasureSizeRenderObject extends RenderProxyBox {
  Size? oldSize;
  OnWidgetSizeChange onChange;

  MeasureSizeRenderObject(this.onChange);

  @override
  void performLayout() {
    super.performLayout();

    Size newSize = child!.size;
    if (oldSize == newSize) return;

    oldSize = newSize;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onChange(newSize);
    });
  }
}

class ContainerSize extends SingleChildRenderObjectWidget {
  final OnWidgetSizeChange onChange;

  const ContainerSize({
    Key? key,
    required this.onChange,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return MeasureSizeRenderObject(onChange);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant MeasureSizeRenderObject renderObject) {
    renderObject.onChange = onChange;
  }
}