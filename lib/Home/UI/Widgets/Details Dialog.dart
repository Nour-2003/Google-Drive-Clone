
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Cubit/Home Cubit.dart';

class DetailsDialog extends StatelessWidget{
  final File;
  final renameController;
  final tagController;
  final emailController;
  final int index;
  final List<String> sharedWith;
  DetailsDialog({
    super.key,
    required this.File,
    required this.renameController,
    required this.tagController,
    required this.emailController,
    required this.sharedWith,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: const Color(0xffF9FAFB),
        title: Text(
         File['isFolder'] ?"Folder Details" : "File Details",
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
                          deleteIcon: const Icon(Icons.close, size: 16),
                      onDeleted: () {
                        (File['tags'] as List<String>).remove(tag);
                        (context as Element).markNeedsBuild();
                      },
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
              const SizedBox(height: 16),
              Text("Share with:", style: GoogleFonts.montserrat(
                fontSize: 14, fontWeight: FontWeight.w500, color: const Color(0xff111827),
              )),
              const SizedBox(height: 6),
              if (sharedWith.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: List<Widget>.from(
                    sharedWith.map(
                          (email) => Chip(
                        label: Text(email),
                        backgroundColor: const Color(0xffE5E7EB),
                        deleteIcon: const Icon(Icons.close, size: 16),
                        onDeleted: () {
                          sharedWith.remove(email);
                          (context as Element).markNeedsBuild();
                        },
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
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: "Add email address",
                        hintStyle: GoogleFonts.montserrat(
                          color: const Color(0xff6B7280),
                          fontWeight: FontWeight.w500,
                        ),
                        filled: true,
                        fillColor: const Color(0xffE5E7EB),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      final email = emailController.text.trim();
                      if (email.isNotEmpty && email.contains('@')) {
                        if (!sharedWith.contains(email)) {
                          sharedWith.add(email);
                          emailController.clear();
                          (context as Element).markNeedsBuild();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Already shared with $email'),
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please enter a valid email'),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffE5E7EB),
                    ),
                    child: const Icon(Icons.add, color: Color(0xff111827)),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              HomeCubit.get(context).deleteFileInFolder(File['path']);
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
          TextButton(
            onPressed: () {
              final newName = renameController.text.trim();
              if (newName.isNotEmpty) {
                HomeCubit.get(context).renameItem(File['path'], newName);
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
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Close",
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          )
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