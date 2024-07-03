import 'package:flutter/material.dart';
import 'package:unyo/models/models.dart';

class DeleteUserMediaDialog extends StatelessWidget {
  const DeleteUserMediaDialog({super.key, required this.totalHeight, required this.totalWidth, required this.currentAnime, required this.deleteUserAnime});

  final double totalHeight;
  final double totalWidth;
  final AnimeModel currentAnime;
  final void Function(int) deleteUserAnime;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: totalHeight * 0.2,
      width: totalWidth * 0.1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: [
          ElevatedButton(
            onPressed: () {
              deleteUserAnime(currentAnime.id);
              Navigator.of(context).pop();
            },
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(
                Color.fromARGB(255, 37, 37, 37),
              ),
              foregroundColor: MaterialStatePropertyAll(
                Colors.white,
              ),
            ),
            child: const Text("Confirm"),
          ),
          const SizedBox(
            width: 20,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(
                Color.fromARGB(255, 37, 37, 37),
              ),
              foregroundColor: MaterialStatePropertyAll(
                Colors.white,
              ),
            ),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }
}
