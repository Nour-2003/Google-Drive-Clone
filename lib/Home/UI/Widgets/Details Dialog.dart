import 'package:erp_task/Home/Models/Mock%20Data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Cubit/Home Cubit.dart';

class DetailsDialog extends StatelessWidget{
  final File;
  final renameController;
  final tagController;
  final int index;
  DetailsDialog({
    super.key,
    required this.File,
    required this.renameController,
    required this.tagController,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: const Color(0xffF9FAFB),
        title: Text(
          "Folder Details",
          style: GoogleFonts.montserrat(
            color: const Color(0xff111827),
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Rename
              Text("Rename:", style: GoogleFonts.montserrat(
                fontSize: 14, fontWeight: FontWeight.w500, color: const Color(0xff111827),
              )),
              const SizedBox(height: 6),
              TextField(
                controller: renameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xffE5E7EB),
                  hintText: "New folder name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Folder Info
              Text("Size: ${_formatFileSize(File['size'])}", style: GoogleFonts.montserrat(
                fontSize: 14, fontWeight: FontWeight.w500, color: const Color(0xff111827),
              )),
              const SizedBox(height: 8),
              Text("Created on ${File['date']}", style: GoogleFonts.montserrat(
                fontSize: 14, fontWeight: FontWeight.w500, color: const Color(0xff111827),
              )),

              const SizedBox(height: 12),

              // Tags Section
              Text("Tags:", style: GoogleFonts.montserrat(
                fontSize: 14, fontWeight: FontWeight.w500, color: const Color(0xff111827),
              )),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: List<Widget>.from(
                  (File['tags'] as List<String>).map(
                        (tag) => Chip(
                      label: Text(tag),
                      backgroundColor: const Color(0xffE5E7EB),
                      labelStyle: GoogleFonts.montserrat(
                        color: const Color(0xff111827),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: tagController,
                      decoration: InputDecoration(
                        hintText: "Add tag",
                        hintStyle: GoogleFonts.montserrat(
                          color: const Color(0xff6B7280),
                          fontWeight: FontWeight.w500,
                        ),
                        filled: true,
                        fillColor: const Color(0xffE5E7EB),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      final newTag = tagController.text.trim();
                      if (newTag.isNotEmpty) {
                        (File['tags'] as List<String>).add(newTag);
                        tagController.clear();
                        Navigator.pop(context);
                        Future.delayed(Duration.zero, () {
                          // Reopen updated dialog
                          (context as Element).reassemble(); // Optional: refresh UI
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffE5E7EB),
                    ),
                    child: const Icon(Icons.add, color: Color(0xff111827)),
                  )
                ],
              ),
            ],
          ),
        ),
        actions: [
          // Delete
          TextButton(
            onPressed: () {
              HomeCubit.get(context).deleteFolder(index);
              Navigator.pop(context);
            },
            child: Text(
              "Delete",
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500,
                color: Colors.red,
              ),
            ),
          ),
          // Save Rename
          TextButton(
            onPressed: () {
              final newName = renameController.text.trim();
              if (newName.isNotEmpty) {
                // HomeCubit.get(context).renameFolder(index, newName);
              }
              Navigator.pop(context);
            },
            child: Text(
              "Save",
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500,
                color: Colors.green[700],
              ),
            ),
          ),
          // Close
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Close",
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      );
  }

}
String _formatFileSize(int bytes) {
  if (bytes < 1024) return "$bytes B";
  if (bytes < 1024 * 1024) return "${(bytes / 1024).toStringAsFixed(1)} KB";
  if (bytes < 1024 * 1024 * 1024)
    return "${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB";
  return "${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB";
}