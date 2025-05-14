// home_cubit.dart
import 'package:erp_task/Home/Cubit/Home%20States.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState());

  static HomeCubit get(context) => BlocProvider.of(context);

  void loadMockData() {
    folders = ['Documents', 'Photos', 'Projects'];
    files = [
      {
        'filename': 'Resume.pdf',
        'size': 1048576, // 1 MB
        'uploadDate': '2025-05-01',
        'tags': ['job', 'resume'],
      },
      {
        'filename': 'Budget.xlsx',
        'size': 512000, // 500 KB
        'uploadDate': '2025-04-15',
        'tags': ['finance', 'budget'],
      },
      {
        'filename': 'MeetingNotes.txt',
        'size': 10240, // 10 KB
        'uploadDate': '2025-03-30',
        'tags': ['meeting', 'notes'],
      },
    ];

    // Initially, show all folders and files
    filteredFolders = List.from(folders);
    filteredFiles = List.from(files);

    emit(HomeDataLoaded()); // emit any state if needed
  }

  List<String> folders = [];
  List<Map<String, dynamic>> files = [];
  List<String> filteredFolders = [];
  List<Map<String, dynamic>> filteredFiles = [];
  void searchInDrive(String query) {
    final lowerQuery = query.toLowerCase();

    if (query.isEmpty) {
      filteredFolders = List.from(folders);
      filteredFiles = List.from(files);
      emit(HomeSearchState(filteredFolders, filteredFiles));
      return;
    }

    filteredFolders = folders
        .where((folder) => folder.toLowerCase().contains(lowerQuery))
        .toList();

    filteredFiles = files.where((file) {
      final name = file['filename']?.toString().toLowerCase() ?? '';
      final description = file['description']?.toString().toLowerCase() ?? '';
      final tags = (file['tags'] as List?)?.cast<String>() ?? [];

      return name.contains(lowerQuery) ||
          tags.any((tag) => tag.toLowerCase().contains(lowerQuery)) ||
          description.contains(lowerQuery);
    }).toList();

    emit(HomeSearchState(filteredFolders, filteredFiles));
  }

  Future<void> pickFile(BuildContext context) async {
    final nameController = TextEditingController();
    final tagsController = TextEditingController();
    final descriptionController = TextEditingController();
    PlatformFile? selectedFile;

    final fileInfo = await showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Add new file',
                      style: GoogleFonts.montserrat(
                          fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 24),

                    // File picker
                    GestureDetector(
                      onTap: () async {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles(
                          type: FileType.any,
                          allowMultiple: false,
                        );
                        if (result != null) {
                          final file = result.files.first;
                          if (file.size <= 11 * 1024 * 1024) {
                            setState(() {
                              selectedFile = file;
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'File must not exceed 10MB.',
                                  style: GoogleFonts.montserrat(
                                    color: const Color(0xff111827),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          }
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                selectedFile?.name ?? 'browser file',
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w500,
                                  color: selectedFile == null
                                      ? Colors.grey.shade500
                                      : Colors.black,
                                ),
                              ),
                            ),
                            const Icon(Icons.upload_file),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Name & Tags row
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: TextField(
                              controller: nameController,
                              decoration: InputDecoration(
                                hintText: 'Name',
                                hintStyle: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff111827),
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: TextField(
                              controller: tagsController,
                              decoration: InputDecoration(
                                hintText: 'Tags',
                                hintStyle: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff111827),
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Description
                    Container(
                      height: 100,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        controller: descriptionController,
                        maxLines: null,
                        expands: true,
                        decoration: InputDecoration(
                          hintText: 'Description',
                          hintStyle: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w500,
                            color: Color(0xff111827),
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Cancel',
                              style: GoogleFonts.montserrat(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w500)),
                        ),
                        const SizedBox(width: 12),
                        TextButton(
                          onPressed: () {
                            if (selectedFile == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                  'Please select a file',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )),
                              );
                              return;
                            }
                            if (nameController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                  'Please enter a name',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )),
                              );
                              return;
                            }

                            Navigator.pop(context, {
                              'filename': selectedFile!.name,
                              'tags': tagsController.text
                                .split(RegExp(r'[,\s;]+'))
                                  .map((e) => e.trim())
                                .where((e) => e.isNotEmpty) // optional: remove empty entries
                                .toList(),
                            'description': descriptionController.text,
                              'name': nameController.text,
                              'size': selectedFile!.size,
                              'path': selectedFile!.path,
                              'uploadDate': DateTime.now(),
                            });
                          },
                          child: Text(
                            'Add',
                            style: GoogleFonts.montserrat(
                              color: const Color(0xff111827),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );

    if (fileInfo != null) {
      filteredFiles.add(fileInfo);
      emit(HomeAddFileState(List.from(files)));
    }
  }

  void createFolder(String folderName) {
    if (folderName.isNotEmpty) {
      filteredFolders.add(folderName);
      emit(HomeAddFolderState(List.from(folders)));
    }
  }
  void deleteFile(int index) {
    filteredFiles.removeAt(index);
    emit(HomeAddFileState(List.from(files)));
  }
  void deleteFolder(int index) {
    filteredFolders.removeAt(index);
    emit(HomeAddFolderState(List.from(folders)));
  }
  void renameFile(int index, String newName) {
    if (newName.isNotEmpty) {
      filteredFiles[index]['filename'] = newName;
      emit(HomeAddFileState(List.from(files)));
    }
  }
}
