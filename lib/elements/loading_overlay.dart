import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:way_to_work/elements/app_loader.dart';
import 'package:way_to_work/helpers/app_colors.dart';

class LoadingOverlay {
  BuildContext _context;

  void hide() {
    Navigator.of(_context).pop();
  }

  void show() {
    showDialog(context: _context, barrierDismissible: false, child: _FullScreenLoader(),
        barrierColor: AppColors.loaderBarrierColor);
  }

  Future<T> during<T>(Future<T> future) {
    show();
    return future.whenComplete(() => hide());
  }

  LoadingOverlay._create(this._context);

  factory LoadingOverlay.of(BuildContext context) {
    return LoadingOverlay._create(context);
  }
}

class _FullScreenLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(child: Center(child: AppLoader()));
  }
}
