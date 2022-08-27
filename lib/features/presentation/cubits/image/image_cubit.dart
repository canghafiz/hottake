import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

part 'image_state.dart';

class ImageCubitEvent {
  ImageCubit read(BuildContext context) {
    return context.read<ImageCubit>();
  }
}

class ImageCubit extends Cubit<ImageState> {
  ImageCubit() : super(_default);

  static final _default = ImageState(onUpload: false);

  // Function
  void clear() {
    emit(_default);
  }

  void updateUpload(bool value) {
    emit(ImageState(onUpload: value));
  }
}
