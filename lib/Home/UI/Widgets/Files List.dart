import 'package:erp_task/Home/Cubit/Home%20States.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Cubit/Home Cubit.dart';

Widget homePageList(context) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: BlocBuilder<HomeCubit,HomeStates>(
        builder: (context, state) {
          final cubit = HomeCubit.get(context);
          final folders = cubit.filteredFolders;
          final files = cubit.filteredFiles;
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.1,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount:
            folders.length +
                files.length,
            itemBuilder: (context, index) {
              if (index <folders.length) {
                // Folder item
                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xffF9FAFB),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Padding(
                            padding:
                            EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                            child: Icon(
                              Icons.folder,
                              size: 40,
                              color: Color(0xff111827),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              folders[index],
                              overflow: TextOverflow.ellipsis,
                              style:  GoogleFonts.montserrat(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xff111827),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.more_vert),
                            onPressed: () {
                              // Handle folder options
                            },
                          ),
                        ],
                      ),
                      const Icon(Icons.folder, size: 100, color: Color(0xff111827)),
                    ],
                  ),
                );
              } else {
                int fileIndex = index - folders.length;
                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xffF9FAFB),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                            child:
                              _getFileIcon(files[fileIndex]
                              ['filename'],true),
                          ),
                          Expanded(
                            child: Text(
                              files[fileIndex]['filename'],
                              overflow: TextOverflow.ellipsis,
                              style:  GoogleFonts.montserrat(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff111827),
                              ),
                            ),
                          ),IconButton(
                            icon: const Icon(Icons.more_vert),
                            onPressed: () {
                              final file = files[fileIndex];
                              final renameController = TextEditingController(text: file['filename']);
                              final tagController = TextEditingController();

                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor: const Color(0xffF9FAFB),
                                  title: Text(
                                    "File Details",
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
                                            hintText: "New filename",
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8),
                                              borderSide: BorderSide.none,
                                            ),
                                          ),
                                        ),

                                        const SizedBox(height: 12),

                                        // File Info
                                        Text("Size: ${_formatFileSize(file['size'])}", style: GoogleFonts.montserrat(
                                          fontSize: 14, fontWeight: FontWeight.w500, color: const Color(0xff111827),
                                        )),
                                        const SizedBox(height: 8),
                                        Text("Type: ${file['filename'].split('.').last}", style: GoogleFonts.montserrat(
                                          fontSize: 14, fontWeight: FontWeight.w500, color: const Color(0xff111827),
                                        )),
                                        const SizedBox(height: 8),
                                        Text("Uploaded: ${file['uploadDate']}", style: GoogleFonts.montserrat(
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
                                            (file['tags'] as List<String>).map(
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
                                                  (file['tags'] as List<String>).add(newTag);
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
                                        HomeCubit.get(context).deleteFile(fileIndex);
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
                                          HomeCubit.get(context).renameFile(fileIndex, newName);
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
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                        _getFileIcon(
                            files[fileIndex]['filename'],false),
                    ],
                  ),
                );
              }
            },
          );
        },
      ),
    );

String _formatFileSize(int bytes) {
  if (bytes < 1024) return "$bytes B";
  if (bytes < 1024 * 1024) return "${(bytes / 1024).toStringAsFixed(1)} KB";
  if (bytes < 1024 * 1024 * 1024)
    return "${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB";
  return "${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB";
}

// Helper function to get icon based on file extension
Icon _getFileIcon(String fileName,bool smallIcon) {
  final extension = fileName.split('.').last.toLowerCase();

  switch (extension) {
    case 'pdf':
      return Icon(Icons.picture_as_pdf_rounded,color: Colors.red, size: smallIcon ? 30:100 ,);
    case 'doc':
    case 'docx':
      return  Icon(Icons.description,color: Colors.blue, size: smallIcon ? 30:100 ,);
    case 'xls':
    case 'xlsx':
      return  Icon(Icons.table_chart,color: Colors.green, size: smallIcon ? 30:100 ,);
    case 'ppt':
    case 'pptx':
      return  Icon(Icons.slideshow,color: Colors.orange, size: smallIcon ? 30:100 ,);
    case 'jpg':
    case 'jpeg':
    case 'png':
    case 'gif':
      return  Icon(Icons.image,color: Colors.red, size: smallIcon ? 30:100 ,);
    case 'mp3':
    case 'wav':
        return  Icon(Icons.audiotrack,color: Colors.blueAccent, size: smallIcon ? 30:100 ,);
    case 'mp4':
    case 'mov':
    case 'avi':
      return  Icon(Icons.videocam,color: Colors.redAccent, size: smallIcon ? 30:100 ,);
    case 'zip':
    case 'rar':
      return  Icon(Icons.archive,color: Colors.brown,  size: smallIcon ? 30:100 ,);
    case 'txt':
      return  Icon(Icons.text_snippet,color: Colors.grey,  size: smallIcon ? 30:100 ,);
    default:
      return   Icon(Icons.insert_drive_file,color: Colors.black, size: smallIcon ? 30:100 ,);
  }
}
