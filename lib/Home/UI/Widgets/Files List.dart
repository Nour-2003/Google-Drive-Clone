import 'package:erp_task/Home/Cubit/Home%20States.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Cubit/Home Cubit.dart';
import '../Screens/Folder Details.dart';
import 'Details Dialog.dart';

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
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FolderInspectPage(
                          folderName: folders[index]['name'],
                          children: folders[index]['children'],
                          path: folders[index]['path'],

                        ),
                      ),
                    );
                  },
                  child: Container(
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
                                folders[index]['name'],
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
                                final folder = folders[index];
                                final renameController = TextEditingController(text: folder['name']);
                                final tagController = TextEditingController();

                                showDialog(
                                  context: context,
                                  builder: (context) => DetailsDialog(File: folder, renameController: renameController, tagController: tagController, index: index),
                                );
                              },
                            ),
                          ],
                        ),
                        const Icon(Icons.folder, size: 100, color: Color(0xff111827)),
                      ],
                    ),
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
                                builder: (context) => DetailsDialog(File: file,
                                  renameController: renameController,
                                  tagController: tagController,
                                  index: fileIndex,
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
