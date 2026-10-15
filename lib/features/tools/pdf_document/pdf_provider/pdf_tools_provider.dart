import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

// 1. IMAGE TO PDF STATE
class ImageToPdfState {
  final List<XFile> images;
  final String pageSize;
  final String orientation;

  const ImageToPdfState({
    this.images = const [],
    this.pageSize = 'A4',
    this.orientation = 'Portrait',
  });

  ImageToPdfState copyWith({
    List<XFile>? images,
    String? pageSize,
    String? orientation,
  }) {
    return ImageToPdfState(
      images: images ?? this.images,
      pageSize: pageSize ?? this.pageSize,
      orientation: orientation ?? this.orientation,
    );
  }
}

class ImageToPdfNotifier extends StateNotifier<ImageToPdfState> {
  ImageToPdfNotifier() : super(const ImageToPdfState());

  void addImages(List<XFile> newImages) {
    state = state.copyWith(images: [...state.images, ...newImages]);
  }

  void removeImage(int index) {
    final updated = List<XFile>.from(state.images)..removeAt(index);
    state = state.copyWith(images: updated);
  }

  void reorderImage(int oldIndex, int newIndex) {
    final updated = List<XFile>.from(state.images);
    final item = updated.removeAt(oldIndex);
    updated.insert(newIndex, item);
    state = state.copyWith(images: updated);
  }

  void setPageSize(String size) {
    state = state.copyWith(pageSize: size);
  }

  void setOrientation(String orientation) {
    state = state.copyWith(orientation: orientation);
  }

  void clearImages() {
    state = state.copyWith(images: []);
  }
}

final imageToPdfProvider = StateNotifierProvider<ImageToPdfNotifier, ImageToPdfState>((ref) {
  return ImageToPdfNotifier();
});

// 2. ID CARD SCANNER STATE
class IdCardScannerState {
  final XFile? frontImage;
  final XFile? backImage;

  const IdCardScannerState({this.frontImage, this.backImage});

  IdCardScannerState copyWith({XFile? frontImage, XFile? backImage}) {
    return IdCardScannerState(
      frontImage: frontImage ?? this.frontImage,
      backImage: backImage ?? this.backImage,
    );
  }
}

class IdCardScannerNotifier extends StateNotifier<IdCardScannerState> {
  IdCardScannerNotifier() : super(const IdCardScannerState());

  void setFrontImage(XFile img) => state = state.copyWith(frontImage: img);
  void setBackImage(XFile img) => state = state.copyWith(backImage: img);
  void reset() => state = const IdCardScannerState();
}

final idCardScannerProvider = StateNotifierProvider<IdCardScannerNotifier, IdCardScannerState>((ref) {
  return IdCardScannerNotifier();
});

// 3. OCR TEXT EXTRACTOR STATE
class OcrExtractorState {
  final XFile? scannedImage;
  final String extractedText;

  const OcrExtractorState({
    this.scannedImage,
    this.extractedText = "Sample OCR Result:\nThis is extracted text from scanned image/document.\nYou can edit, copy or share this text directly.",
  });

  OcrExtractorState copyWith({XFile? scannedImage, String? extractedText}) {
    return OcrExtractorState(
      scannedImage: scannedImage ?? this.scannedImage,
      extractedText: extractedText ?? this.extractedText,
    );
  }
}

class OcrExtractorNotifier extends StateNotifier<OcrExtractorState> {
  OcrExtractorNotifier() : super(const OcrExtractorState());

  void setScannedImage(XFile img) {
    state = state.copyWith(
      scannedImage: img,
      extractedText: "OCR Text extracted from ${img.name}:\nAll Tools PDF Scanner captured document text successfully.\nReady to copy or share.",
    );
  }

  void updateText(String text) {
    state = state.copyWith(extractedText: text);
  }
}

final ocrExtractorProvider = StateNotifierProvider<OcrExtractorNotifier, OcrExtractorState>((ref) {
  return OcrExtractorNotifier();
});
