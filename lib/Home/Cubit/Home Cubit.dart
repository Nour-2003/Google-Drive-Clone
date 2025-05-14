// home_cubit.dart
import 'package:erp_task/Home/Cubit/Home%20States.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';

import '../UI/Widgets/File Dialog.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState());

  static HomeCubit get(context) => BlocProvider.of(context);

  void loadMockData() {
    folders = [
      {
        'name': 'Work',
        'path': '/Work',
        'type': 'folder',
        'size': 0,
        'children': [
          {
            'name': 'Subfolder 1',
            'path': '/Work/Subfolder 1',
            'size': 0,
            'children': [],
            'isFolder': true,
            'tags': ['work', 'subfolder'],
            'date': '2025-05-01',
            'description': '',
            'parentFolder': '/Work',
          },
          {
            'name': 'Subfolder 2',
            'path': '/Work/Subfolder 2',
            'size': 0,
            'children': [],
            'isFolder': true,
            'tags': ['work', 'subfolder'],
            'date': '2025-05-01',
            'description': '',
            'parentFolder': '/Work',
          }
        ],
        'tags': ['work', 'office'],
        'date': '2025-05-01',
        'description': '',
        'parentFolder': '/',
      },
      {
        'name': 'Personal',
        'path': '/Personal',
        'size': 0,
        'children': [],
        'isFolder': true,
        'tags': ['personal', 'home'],
        'date': '2025-04-15',
        'description': '',
        'parentFolder': '/',
      },
      {
        'name': 'Projects',
        'path': '/Projects',
        'size': 0,
        'children': [
          {
            'name':'File 1.jpg',
            'path': '/Projects/File 1',
            'isFolder':false,
            'size': 14,
            'tags': ['projects', 'work'],
            'date': '2025-03-30',
            'description': ' This is a file description',

          },
          {
            'name':'File 2.docx',
            'path': '/Projects/File 2',
            'isFolder':false,
            'size': 14,
            'tags': ['projects', 'work'],
            'date': '2025-03-30',
            'description': ' This is a file description',
          }
        ],
        'tags': ['projects', 'work'],
        'date': '2025-03-30',
        'description': '',
        'parentFolder': '/',
      },
    ];
    files = [
      {
        'filename': 'Resume.pdf',
        'size': 1048576, // 1 MB
        'uploadDate': '2025-05-01',
        'tags': ['job', 'resume'],
        'path': '/'
      },
      {
        'filename': 'Budget.xlsx',
        'size': 512000, // 500 KB
        'uploadDate': '2025-04-15',
        'tags': ['finance', 'budget'],
        'path': '/'
      },
      {
        'filename': 'MeetingNotes.txt',
        'size': 10240, // 10 KB
        'uploadDate': '2025-03-30',
        'tags': ['meeting', 'notes'],
        'path': '/'
      },
    ];

    // Initially, show all folders and files
    filteredFolders = List.from(folders);
    filteredFiles = List.from(files);

    emit(HomeDataLoaded()); // emit any state if needed
  }

  List<Map<String, dynamic>> folders = [];
  List<Map<String, dynamic>> files = [];
  List<Map<String, dynamic>> filteredFolders = [];
  List<Map<String, dynamic>> filteredFiles = [];

  void searchInDrive(String query) {
    final lowerQuery = query.toLowerCase();

    if (query.isEmpty) {
      filteredFolders = List.from(folders);
      filteredFiles = List.from(files);
      emit(HomeSearchState(filteredFolders, filteredFiles));
      return;
    }

    filteredFolders = folders.where((file) {
      final name = file['name']?.toString().toLowerCase() ?? '';
      final description = file['description']?.toString().toLowerCase() ?? '';
      final tags = (file['tags'] as List?)?.cast<String>() ?? [];

      return name.contains(lowerQuery) ||
          tags.any((tag) => tag.toLowerCase().contains(lowerQuery)) ||
          description.contains(lowerQuery);
    }).toList();

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
      builder: (context) => CreateFileDialog(
        nameController: nameController,
        tagsController: tagsController,
        descriptionController: descriptionController,
        selectedFile: selectedFile,
      ),
    );

    if (fileInfo != null) {
      filteredFiles.add(fileInfo);
      emit(HomeAddFileState(List.from(files)));
    }
  }

  void createFolder(String folderName) {
    if (folderName.isNotEmpty) {
      filteredFolders.add({
        'name': folderName,
        'path': '/$folderName',
        'type': 'folder',
        'size': '0 KB',
        'date': DateTime.now().toString(),
        'description': '',
        'parentFolder': '/',
      });
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
