abstract class HomeStates {}

class HomeInitialState extends HomeStates {}

class HomeAddFolderState extends HomeStates {
  final List<String> folders;
  HomeAddFolderState(this.folders);
}

class HomeAddFileState extends HomeStates {
  final List<Map<String, dynamic>> files;
  HomeAddFileState(this.files);
}

class HomeLoadingState extends HomeStates {}

class HomeSearchState extends HomeStates {
  final List<Map<String, dynamic>> searchResults;
  final String currentSearchPath; // Add this

  HomeSearchState(this.searchResults, this.currentSearchPath);
}
class HomeDataLoaded extends HomeStates{

}
class HomeNavigateState extends HomeStates{
  final String path;

  HomeNavigateState(this.path);
}
class HomeFolderContentUpdatedState extends HomeStates {
  final String currentPath;
  final List<Map<String, dynamic>> items;

  HomeFolderContentUpdatedState({
    required this.currentPath,
    required this.items,
  });
}
// Add this to your HomeStates.dart
class HomeFilterState extends HomeStates {
  final bool showFiles;
  final bool showFolders;

  HomeFilterState(this.showFiles, this.showFolders);
}