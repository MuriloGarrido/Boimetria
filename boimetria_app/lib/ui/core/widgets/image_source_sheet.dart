import 'package:boimetria/ui/core/widgets/app_button.dart';
import 'package:boimetria/ui/core/widgets/sheet_option_tile.dart';
import 'package:boimetria/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceSheet extends StatelessWidget {
  const ImageSourceSheet({super.key});

  static Future<ImageSource?> show(BuildContext context) {
    return showModalBottomSheet<ImageSource>(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => const ImageSourceSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 10,
        children: [
          Text(l10n.imageSourceQuestion, style: text.headlineMedium),
          const SizedBox(width: 10),
          SheetOptionTile.filled(
            icon: Icons.camera_alt_outlined,
            title: l10n.imageSourceCameraTitle,
            description: l10n.imageSourceCameraDescription,
            onTap: () => Navigator.pop(context, ImageSource.camera),
          ),
          SheetOptionTile.outlined(
            icon: Icons.photo_library_outlined,
            title: l10n.imageSourceGalleryTitle,
            description: l10n.imageSourceGalleryDescription,
            onTap: () => Navigator.pop(context, ImageSource.gallery),
          ),
          AppButton.outlined(
            label: l10n.cancel,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
