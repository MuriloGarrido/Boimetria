import 'package:boimetria/ui/core/themes/app_colors.dart';
import 'package:boimetria/ui/identify/widgets/sheet_option_tile.dart';
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

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 10,
        children: [
          Text("De onde vem a foto do focinho?", style: text.headlineMedium),
          const SizedBox(width: 10),
          SheetOptionTile.filled(
            icon: Icons.camera_alt_outlined,
            title: "Tirar foto agora",
            description: "O animal está na sua frente",
            onTap: () => Navigator.pop(context, ImageSource.camera),
          ),
          SheetOptionTile.outlined(
            icon: Icons.photo_library_outlined,
            title: "Escolher da galeria",
            description: "Uma foto já tirada do focinho",
            onTap: () => Navigator.pop(context, ImageSource.gallery),
          ),  
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.text,
              backgroundColor: Colors.white,
              side: const BorderSide(color: AppColors.border, width: 2.5),
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text("CANCELAR", style: text.headlineSmall,),
          ),
        ],
      ),
    );
  }
}
