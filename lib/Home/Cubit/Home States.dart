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
  final List<Map<String, dynamic>> folders;
  final List<Map<String, dynamic>> files;

  HomeSearchState(this.folders, this.files);
}
class HomeDataLoaded extends HomeStates{

}
class HomeNavigateState extends HomeStates{
  final String path;

  HomeNavigateState(this.path);
}