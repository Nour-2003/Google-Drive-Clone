// home_cubit.dart
import 'package:erp_task/Home/Cubit/Home%20States.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../UI/Widgets/File Dialog.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState());

  static HomeCubit get(context) => BlocProvider.of(context);

  List<Map<String, dynamic>> allItems = [];
  List<Map<String, dynamic>> filteredItems = [];

  void loadMockData() {
    allItems = [
      {
        'name': 'Work',
        'path': '/Work',
        'type': 'folder',
        'size': 0,
        'isFolder': true,
        'children': [
          {
            'name': 'Subfolder 1',
            'path': '/Work/Subfolder 1',
            'size': 0,
            'children': List<Map<String, dynamic>>.empty(),
            'isFolder': true,
            'tags': ['work', 'subfolder'],
            'date': '2025-05-01',
            'description': '',
            'parentFolder': '/Work',
            'sharedWith': ['team1@company.com', 'manager@company.com'],
          },
          {
            'name': 'Subfolder 2',
            'path': '/Work/Subfolder 2',
            'size': 0,
            'children': List<Map<String, dynamic>>.empty(),
            'isFolder': true,
            'tags': ['work', 'subfolder'],
            'date': '2025-05-01',
            'description': '',
            'parentFolder': '/Work',
            'sharedWith': ['team2@company.com'],
          }
        ],
        'tags': ['work', 'office'],
        'date': '2025-05-01',
        'description': '',
        'parentFolder': '/',
        'sharedWith': ['ceo@company.com', 'hr@company.com'],
      },
      {
        'name': 'Personal',
        'path': '/Personal',
        'size': 0,
        'children': <Map<String, dynamic>>[],
        'isFolder': true,
        'tags': ['personal', 'home'],
        'date': '2025-04-15',
        'description': '',
        'parentFolder': '/',
        'sharedWith': ['family@home.com'],
      },
      {
        'name': 'Projects',
        'path': '/Projects',
        'size': 0,
        'isFolder': true,
        'children': [
          {
            'name': 'File 1.jpg',
            'path': '/Projects/File 1.jpg',
            'isFolder': false,
            'size': 14,
            'tags': ['projects', 'work'],
            'date': '2025-03-30',
            'description': 'This is a file description',
            'sharedWith': ['designer@company.com'],
          },
          {
            'name': 'File 2.docx',
            'path': '/Projects/File 2.docx',
            'isFolder': false,
            'size': 14,
            'tags': ['projects', 'work'],
            'date': '2025-03-30',
            'description': 'This is a file description',
            'sharedWith': ['developer@company.com', 'qa@company.com'],
          }
        ],
        'tags': ['projects', 'work'],
        'date': '2025-03-30',
        'description': '',
        'parentFolder': '/',
        'sharedWith': ['project_manager@company.com'],
      },
      {
        'name': 'Resume.pdf',
        'isFolder': false,
        'size': 1048576,
        'uploadDate': '2025-05-01',
        'tags': ['job', 'resume'],
        'path': '/Resume.pdf',
        'sharedWith': ['recruiter1@jobs.com', 'recruiter2@jobs.com'],
      },
      {
        'name': 'Budget.xlsx',
        'isFolder': false,
        'size': 512000,
        'uploadDate': '2025-04-15',
        'tags': ['finance', 'budget'],
        'path': '/Budget.xlsx',
        'sharedWith': ['accountant@company.com'],
      },
      {
        'name': 'MeetingNotes.txt',
        'isFolder': false,
        'size': 10240,
        'uploadDate': '2025-03-30',
        'tags': ['meeting', 'notes'],
        'path': '/MeetingNotes.txt',
        'sharedWith': ['assistant@company.com'],
      },
    ];

    filteredItems = List.from(allItems);
    emit(HomeDataLoaded());
  }

  void searchInFolder(String query, String currentPath) {
    final lowerQuery = query.toLowerCase();

    if (query.isEmpty) {
      filteredItems = getFolderContents(currentPath);
      emit(HomeSearchState(filteredItems, currentPath));
      return;
    }

    final currentFolderContents = getFolderContents(currentPath);

    filteredItems = currentFolderContents.where((item) {
      final name = item['name']?.toString().toLowerCase() ?? '';
      final description = item['description']?.toString().toLowerCase() ?? '';
      final tags = (item['tags'] as List?)?.cast<String>() ?? [];

      return name.contains(lowerQuery) ||
          tags.any((tag) => tag.toLowerCase().contains(lowerQuery)) ||
          description.contains(lowerQuery);
    }).toList();

    emit(HomeSearchState(filteredItems, currentPath));
  }
  void updateSharedEmails(String itemPath, List<String> emails) {
    final pathComponents = itemPath.split('/').where((part) => part.isNotEmpty).toList();
    final updatedItems = List<Map<String, dynamic>>.from(allItems);

    bool updated = _updateSharedEmailsRecursive(updatedItems, pathComponents, 0, emails);

    if (updated) {
      allItems = updatedItems;
      filteredItems = List.from(allItems);
      emit(HomeFolderContentUpdatedState(
        currentPath: itemPath.substring(0, itemPath.lastIndexOf('/')),
        items: allItems,
      ));
    }
  }

  bool _updateSharedEmailsRecursive(
      List<Map<String, dynamic>> items,
      List<String> pathComponents,
      int currentIndex,
      List<String> emails,
      ) {
    final nameToFind = pathComponents[currentIndex];
    final itemIndex = items.indexWhere((item) => item['name'] == nameToFind);

    if (itemIndex == -1) return false;

    if (currentIndex == pathComponents.length - 1) {
      items[itemIndex]['sharedWith'] = List<String>.from(emails);
      return true;
    }

    final item = items[itemIndex];
    if (item['isFolder'] == true && item['children'] != null) {
      final children = List<Map<String, dynamic>>.from(item['children']);
      final updated = _updateSharedEmailsRecursive(
          children,
          pathComponents,
          currentIndex + 1,
          emails
      );

      if (updated) {
        items[itemIndex] = {...item, 'children': children};
        return true;
      }
    }

    return false;
  }
  Future<void> pickFile(BuildContext context, String parentPath) async {
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
      final newFile = {
        ...fileInfo,
        'isFolder': false,
        'path': parentPath == '/'
            ? '/${fileInfo['name']}'
            : '$parentPath/${fileInfo['name']}',
        'parentFolder': parentPath,
        'sharedWith': <String>[],
        'date': DateTime.now().toString().substring(0, 10),
      };

      if (parentPath == '/') {
        allItems.add(newFile);
        filteredItems.add(newFile);
        emit(HomeFolderContentUpdatedState(
          currentPath: parentPath,
          items: List.from(allItems),
        ));
        return;
      }

      final pathComponents =
          parentPath.split('/').where((part) => part.isNotEmpty).toList();
      final updatedItems = List<Map<String, dynamic>>.from(allItems);
      final added = _addFileRecursive(updatedItems, pathComponents, 0, newFile);

      if (added) {
        allItems = updatedItems;
        filteredItems = List.from(allItems);
        emit(HomeFolderContentUpdatedState(
          currentPath: parentPath,
          items: List.from(allItems),
        ));
      }
    }
  }

  bool _addFileRecursive(
    List<Map<String, dynamic>> items,
    List<String> pathComponents,
    int currentIndex,
    Map<String, dynamic> newFile,
  ) {
    if (currentIndex == pathComponents.length) {
      items.add(newFile);
      return true;
    }

    final currentFolderName = pathComponents[currentIndex];
    final folderIndex = items.indexWhere(
      (item) => item['name'] == currentFolderName && item['isFolder'] == true,
    );

    if (folderIndex == -1) return false;

    final folder = items[folderIndex];
    final children = List<Map<String, dynamic>>.from(folder['children'] ?? []);
    final added =
        _addFileRecursive(children, pathComponents, currentIndex + 1, newFile);

    if (added) {
      items[folderIndex] = {
        ...folder,
        'children': children,
      };
      return true;
    }

    return false;
  }

  void createFolder(String parentPath, String folderName) {
    if (folderName.isEmpty) return;

    final newFolder = {
      'name': folderName,
      'size': 0,
      'children': <Map<String, dynamic>>[], // Explicitly typed
      'isFolder': true,
      'tags': <String>[],
      'sharedWith': <String>[],
      'date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
      'description': '',
      'path': parentPath == '/' ? '/$folderName' : '$parentPath/$folderName',
    };

    if (parentPath == '/') {
      allItems.add(newFolder);
      filteredItems.add(newFolder);
      emit(HomeFolderContentUpdatedState(
        currentPath: parentPath,
        items: List<Map<String, dynamic>>.from(allItems),
      ));
      return;
    }

    final pathComponents = parentPath.split('/').where((part) => part.isNotEmpty).toList();
    final updatedItems = List<Map<String, dynamic>>.from(allItems);
    final created = _createFolderRecursive(updatedItems, pathComponents, 0, newFolder);

    if (created) {
      allItems = updatedItems;
      filteredItems = List<Map<String, dynamic>>.from(allItems);
      emit(HomeFolderContentUpdatedState(
        currentPath: parentPath,
        items: List<Map<String, dynamic>>.from(allItems),
      ));
    }
  }

  bool _createFolderRecursive(
    List<Map<String, dynamic>> items,
    List<String> pathComponents,
    int currentIndex,
    Map<String, dynamic> newFolder,
  ) {
    // If we've reached the target parent folder
    if (currentIndex == pathComponents.length) {
      items.add(newFolder);
      return true;
    }

    final currentFolderName = pathComponents[currentIndex];
    final folderIndex = items.indexWhere(
      (item) => item['name'] == currentFolderName && item['isFolder'] == true,
    );

    if (folderIndex == -1) return false;

    final folder = items[folderIndex];
    final children = List<Map<String, dynamic>>.from(folder['children'] ?? []);
    final created = _createFolderRecursive(
        children, pathComponents, currentIndex + 1, newFolder);

    if (created) {
      items[folderIndex] = {
        ...folder,
        'children': children,
      };
      return true;
    }

    return false;
  }

  void deleteFileInFolder(String filePath) {
    final pathComponents =
        filePath.split('/').where((part) => part.isNotEmpty).toList();

    if (pathComponents.isEmpty) return;

    final updatedItems = List<Map<String, dynamic>>.from(allItems);
    final deleted = _deleteFileRecursive(updatedItems, pathComponents, 0);

    if (deleted) {
      allItems = updatedItems;
      filteredItems = List.from(allItems);

      emit(HomeFolderContentUpdatedState(
          currentPath: filePath.substring(0, filePath.lastIndexOf('/')),
          items: allItems));
    }
  }

  bool _deleteFileRecursive(List<Map<String, dynamic>> items,
      List<String> pathComponents, int currentIndex) {
    final nameToFind = pathComponents[currentIndex];

    final itemIndex = items.indexWhere((item) => item['name'] == nameToFind);

    if (itemIndex == -1) return false;

    if (currentIndex == pathComponents.length - 1) {
      items.removeAt(itemIndex);
      return true;
    }

    final item = items[itemIndex];
    if (item['isFolder'] == true && item['children'] != null) {
      // Create a new mutable list for children
      final children = List<Map<String, dynamic>>.from(item['children']);
      final deletedInChild =
          _deleteFileRecursive(children, pathComponents, currentIndex + 1);

      if (deletedInChild) {
        items[itemIndex] = {...item, 'children': children};
        return true;
      }
    }

    return false;
  }

  List<Map<String, dynamic>> getFolderContents(String path) {
    if (path == '/') return List<Map<String, dynamic>>.from(allItems);

    final pathComponents = path.split('/').where((part) => part.isNotEmpty).toList();
    List<Map<String, dynamic>> currentItems = allItems;

    for (final component in pathComponents) {
      final folder = currentItems.firstWhere(
            (item) => item['name'] == component && item['isFolder'] == true,
        orElse: () => {},
      );

      if (folder.isEmpty) return [];
      currentItems = List<Map<String, dynamic>>.from(folder['children'] ?? []);
    }

    return currentItems;
  }
  void renameItem(String itemPath, String newName) {
    if (newName.isEmpty) return;

    final pathComponents =
        itemPath.split('/').where((part) => part.isNotEmpty).toList();

    if (pathComponents.isEmpty) return;

    final updatedItems = List<Map<String, dynamic>>.from(allItems);
    final renamed =
        _renameItemRecursive(updatedItems, pathComponents, 0, newName);

    if (renamed) {
      allItems = updatedItems;
      filteredItems = List.from(allItems);
      emit(HomeFolderContentUpdatedState(
          currentPath: itemPath.substring(0, itemPath.lastIndexOf('/')),
          items: allItems));
    }
  }

  bool _renameItemRecursive(List<Map<String, dynamic>> items,
      List<String> pathComponents, int currentIndex, String newName) {
    final nameToFind = pathComponents[currentIndex];

    final itemIndex = items.indexWhere((item) => item['name'] == nameToFind);

    if (itemIndex == -1) return false;

    if (currentIndex == pathComponents.length - 1) {
      items[itemIndex]['name'] = newName;
      return true;
    }

    final item = items[itemIndex];
    if (item['isFolder'] == true && item['children'] != null) {
      final children = List<Map<String, dynamic>>.from(item['children']);
      final renamedInChild = _renameItemRecursive(
          children, pathComponents, currentIndex + 1, newName);

      if (renamedInChild) {
        items[itemIndex] = {...item, 'children': children};
        return true;
      }
    }

    return false;
  }
}
