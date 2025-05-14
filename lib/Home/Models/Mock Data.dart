abstract class FileSystemEntity {
  String name;
  String path;
  String type;
  String size;
  String date;
  String description;
  String parentFolder;
  bool isFolder;
  List<String> tags = [];
  FileSystemEntity({
    required this.name,
    required this.path,
    required this.type,
    required this.size,
    required this.date,
    required this.parentFolder,
    required this.isFolder,
    required this.description,
  });
}

class Folder extends FileSystemEntity {
  List<FileSystemEntity> children = [];

  Folder({
    required String name,
    required String path,
    required String type,
    required String size,
    required String date,
    required String description,
    required String parentFolder,
  }) : super(
    name: name,
    path: path,
    type: type,
    size: size,
    date: date,
    parentFolder: parentFolder,
    isFolder: true,
    description: description,
  );
}

class File extends FileSystemEntity {
  File({
    required String name,
    required String path,
    required String type,
    required String size,
    required String description,
    required String date,
    List<String> tags = const [],
    required String parentFolder,
  }) : super(
    name: name,
    path: path,
    type: type,
    size: size,
    date: date,
    parentFolder: parentFolder,
    isFolder: false,
    description: description,
  );
}

List<Folder> generateMockData() {
  // Root folder
  final root = Folder(
    name: "Root",
    path: "/",
    type: "Folder",
    size: "0",
    date: "2023-10-01",
    description: "Root folder",
    parentFolder: "",
  );

  // Documents folder
  final documents = Folder(
    name: "Documents",
    path: "/Documents/",
    type: "Folder",
    size: "0",
    date: "2023-10-02",
    description: "Documents folder",
    parentFolder: "/",
  );

  // Images folder
  final images = Folder(
    name: "Images",
    path: "/Images/",
    type: "Folder",
    size: "0",
    date: "2023-10-03",
    description: "Images folder",
    parentFolder: "/",
  );

  // Work folder inside Documents
  final work = Folder(
    name: "Work",
    path: "/Documents/Work/",
    type: "Folder",
    size: "0",
    date: "2023-10-04",
    description: "Work folder",
    parentFolder: "/Documents/",
  );

  // Personal folder inside Documents
  final personal = Folder(
    name: "Personal",
    path: "/Documents/Personal/",
    type: "Folder",
    size: "0",
    date: "2023-10-05",
    description: "Personal folder",
    parentFolder: "/Documents/",
  );

  // Vacation folder inside Images
  final vacation = Folder(
    name: "Vacation",
    path: "/Images/Vacation/",
    type: "Folder",
    size: "0",
    date: "2023-10-06",
    description: "Vacation folder",
    parentFolder: "/Images/",
  );

  // Create some files
  final resume = File(
    name: "Resume.pdf",
    path: "/Documents/Work/Resume.pdf",
    type: "pdf",
    size: "2.5 MB",
    date: "2023-09-15",
    description: "This is my resume.",
    tags: ["job", "application"],
    parentFolder: "/Documents/Work/",
  );

  final report = File(
    name: "Q3_Report.docx",
    path: "/Documents/Work/Q3_Report.docx",
    type: "docx",
    size: "1.8 MB",
    date: "2023-09-30",
    description: "Quarterly report for Q3.",
    tags: ["report", "Q3"],
    parentFolder: "/Documents/Work/",
  );

  final notes = File(
    name: "Notes.txt",
    path: "/Documents/Personal/Notes.txt",
    type: "txt",
    size: "12 KB",
    date: "2023-10-01",
    description: "Personal notes.",
    tags: ["personal", "notes"],
    parentFolder: "/Documents/Personal/",
  );

  final beach = File(
    name: "Beach.jpg",
    path: "/Images/Vacation/Beach.jpg",
    type: "jpg",
    size: "3.2 MB",
    date: "2023-08-20",
    description: "Beach vacation photo.",
    parentFolder: "/Images/Vacation/",
  );

  final mountain = File(
    name: "Mountain.png",
    path: "/Images/Vacation/Mountain.png",
    type: "png",
    size: "4.5 MB",
    date: "2023-08-22",
    description: "Mountain vacation photo.",
    parentFolder: "/Images/Vacation/",
  );

  final readme = File(
    name: "README.md",
    path: "/README.md",
    type: "md",
    size: "5 KB",
    date: "2023-10-01",
    description: "This is a readme file.",
    parentFolder: "/",
  );

  // Build the hierarchy
  work.children.addAll([resume, report]);
  personal.children.add(notes);
  vacation.children.addAll([beach, mountain]);

  documents.children.addAll([work, personal]);
  images.children.add(vacation);

  root.children.addAll([documents, images, readme]);

  return [root];
}