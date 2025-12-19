import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_handson/l10n/app_localizations.dart';
import 'package:image/image.dart' as image_lib;
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';

class IamgeSelectScreen extends StatefulWidget {
  const IamgeSelectScreen({super.key});

  @override
  State<IamgeSelectScreen> createState() => _IamgeSelectScreenState();
}

class _IamgeSelectScreenState extends State<IamgeSelectScreen> {
  Uint8List? _originalImageBitmap;
  Uint8List? _displayImageBitmap;
  int _resizeWidth = 500;

  void _updateImage(Uint8List? imageData) {
    setState(() {
      _originalImageBitmap = imageData;
      _displayImageBitmap = imageData;
      _resizeWidth = 500;
    });
  }

  void _updateResizedImage(Uint8List? imageData, int width) {
    setState(() {
      _displayImageBitmap = imageData;
      _resizeWidth = width;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(l10n.imageSelectScreentTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 画像表示コンポーネント
            ImagePreviewWidget(imageBitmap: _displayImageBitmap),
            const SizedBox(height: 16),
            // リサイズスライダーコンポーネント
            if (_originalImageBitmap != null)
              ResizeSliderWidget(
                originalImageBitmap: _originalImageBitmap!,
                currentWidth: _resizeWidth,
                onResized: _updateResizedImage,
              ),
            const SizedBox(height: 24),
            // ボタン群
            Wrap(
              spacing: 16,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                // 画像選択ボタン
                ImageSelectButton(onImageSelected: _updateImage),
                // 保存ボタン
                ImageSaveButton(imageBitmap: _displayImageBitmap),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 画像プレビュー表示用コンポーネント
class ImagePreviewWidget extends StatelessWidget {
  const ImagePreviewWidget({
    super.key,
    required this.imageBitmap,
  });

  final Uint8List? imageBitmap;

  @override
  Widget build(BuildContext context) {
    if (imageBitmap == null) {
      return Container(
        width: 300,
        height: 300,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[400]!),
        ),
        child: const Center(
          child: Icon(
            Icons.image_outlined,
            size: 64,
            color: Colors.grey,
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.memory(
        imageBitmap!,
        width: 300,
        height: 300,
        fit: BoxFit.contain,
      ),
    );
  }
}

/// リサイズスライダーコンポーネント
class ResizeSliderWidget extends StatefulWidget {
  const ResizeSliderWidget({
    super.key,
    required this.originalImageBitmap,
    required this.currentWidth,
    required this.onResized,
  });

  final Uint8List originalImageBitmap;
  final int currentWidth;
  final void Function(Uint8List? imageData, int width) onResized;

  @override
  State<ResizeSliderWidget> createState() => _ResizeSliderWidgetState();
}

class _ResizeSliderWidgetState extends State<ResizeSliderWidget> {
  late double _sliderValue;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _sliderValue = widget.currentWidth.toDouble();
  }

  @override
  void didUpdateWidget(ResizeSliderWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentWidth != widget.currentWidth) {
      _sliderValue = widget.currentWidth.toDouble();
    }
  }

  Future<void> _applyResize(double value) async {
    setState(() {
      _isProcessing = true;
    });

    try {
      final image = image_lib.decodeImage(widget.originalImageBitmap);
      if (image == null) return;

      final targetWidth = value.toInt();
      final resizedImage = image_lib.copyResize(image, width: targetWidth);
      final encodedImage = image_lib.encodePng(resizedImage);

      widget.onResized(encodedImage, targetWidth);
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  l10n.resizeLabel,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                if (_isProcessing)
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(l10n.widthLabel(_sliderValue.toInt())),
            Slider(
              value: _sliderValue,
              min: 100,
              max: 1000,
              divisions: 18,
              label: '${_sliderValue.toInt()}px',
              onChanged: (value) {
                setState(() {
                  _sliderValue = value;
                });
              },
              onChangeEnd: _applyResize,
            ),
          ],
        ),
      ),
    );
  }
}

/// 画像選択ボタンコンポーネント
class ImageSelectButton extends StatefulWidget {
  const ImageSelectButton({
    super.key,
    required this.onImageSelected,
  });

  final void Function(Uint8List? imageData) onImageSelected;

  @override
  State<ImageSelectButton> createState() => _ImageSelectButtonState();
}

class _ImageSelectButtonState extends State<ImageSelectButton> {
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  Future<void> _selectImage() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final XFile? imageFile =
          await _picker.pickImage(source: ImageSource.gallery);
      if (imageFile == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final imageBitmap = await imageFile.readAsBytes();

      final image = image_lib.decodeImage(imageBitmap);
      if (image == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // 画像をリサイズ（長辺を500pxに）
      final image_lib.Image resizedImage;
      if (image.width > image.height) {
        resizedImage = image_lib.copyResize(image, width: 500);
      } else {
        resizedImage = image_lib.copyResize(image, height: 500);
      }

      final encodedImage = image_lib.encodePng(resizedImage);
      widget.onImageSelected(encodedImage);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);

    return ElevatedButton.icon(
      onPressed: _isLoading ? null : _selectImage,
      icon: _isLoading
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.photo_library),
      label: Text(l10n.imageSelect),
    );
  }
}

/// 画像保存ボタンコンポーネント
class ImageSaveButton extends StatefulWidget {
  const ImageSaveButton({
    super.key,
    required this.imageBitmap,
  });

  final Uint8List? imageBitmap;

  @override
  State<ImageSaveButton> createState() => _ImageSaveButtonState();
}

class _ImageSaveButtonState extends State<ImageSaveButton> {
  bool _isLoading = false;

  Future<void> _saveImage() async {
    if (widget.imageBitmap == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // 一時ファイルに保存
      final tempDir = await getTemporaryDirectory();
      final fileName = 'EditSnap_${DateTime.now().millisecondsSinceEpoch}.png';
      final tempFile = File('${tempDir.path}/$fileName');
      await tempFile.writeAsBytes(widget.imageBitmap!);

      // ギャラリーに保存
      await Gal.putImage(tempFile.path);

      // 一時ファイルを削除
      await tempFile.delete();

      if (!mounted) return;

      final l10n = L10n.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.saveSuccess),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      final l10n = L10n.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.saveFailed),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final hasImage = widget.imageBitmap != null;

    return ElevatedButton.icon(
      onPressed: hasImage && !_isLoading ? _saveImage : null,
      icon: _isLoading
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.save_alt),
      label: Text(l10n.imageSave),
    );
  }
}
