import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

// 1. IMAGE RESIZER & COMPRESSOR STATE
class ImageResizerState {
  final XFile? image;
  final double quality;
  final String format;
  final double width;
  final double height;

  const ImageResizerState({
    this.image,
    this.quality = 80,
    this.format = 'JPG',
    this.width = 1080,
    this.height = 1080,
  });

  ImageResizerState copyWith({
    XFile? image,
    double? quality,
    String? format,
    double? width,
    double? height,
  }) {
    return ImageResizerState(
      image: image ?? this.image,
      quality: quality ?? this.quality,
      format: format ?? this.format,
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }
}

class ImageResizerNotifier extends StateNotifier<ImageResizerState> {
  ImageResizerNotifier() : super(const ImageResizerState());

  void setImage(XFile img) => state = state.copyWith(image: img);
  void setQuality(double q) => state = state.copyWith(quality: q);
  void setFormat(String fmt) => state = state.copyWith(format: fmt);
  void setDimensions(double w, double h) => state = state.copyWith(width: w, height: h);
}

final imageResizerProvider = StateNotifierProvider<ImageResizerNotifier, ImageResizerState>((ref) {
  return ImageResizerNotifier();
});

// 2. PHOTO FILTERS STATE
final activeFilterProvider = StateProvider<String>((ref) => 'Normal');
final watermarkCaptionProvider = StateProvider<String>((ref) => 'All Tools App');
final passportCountryProvider = StateProvider<String>((ref) => 'Bangladesh Passport (40x50 mm)');
