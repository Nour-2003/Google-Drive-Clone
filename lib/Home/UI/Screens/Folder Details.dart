import 'package:erp_task/Home/Cubit/Home%20States.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Cubit/Home Cubit.dart';
import '../Widgets/Details Dialog.dart';

class FolderInspectPage extends StatelessWidget {
  final String path;
  final String folderName;
  final List<Map<String, dynamic>> children;

  FolderInspectPage({
    super.key,
    required this.path,
    required this.folderName,
    required List<dynamic> children, // Accept List<dynamic> in constructor
  }) : children = children.cast<Map<String, dynamic>>(); // Convert to List<Map>
  final TextEditingController folderNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // Get the cubit instance
    final homeCubit = HomeCubit.get(context);

    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {
        if (state is HomeFolderContentUpdatedState) {
          if (state.currentPath == path) {
            // This will trigger a rebuild when our folder's content changes
          }
        }
      },
      builder: (context, state) {
        // Get fresh data from cubit on every rebuild
        final currentChildren = homeCubit.getFolderContents(path);
        List<Map<String, dynamic>> displayItems;

        if (state is HomeSearchState && state.currentSearchPath == path) {
          displayItems = state.searchResults;
        } else {
          displayItems = homeCubit.getFolderContents(path);
        }

        final folders = displayItems.where((item) => item['isFolder'] == true).toList();
        final files = displayItems.where((item) => item['isFolder'] == false).toList();
        return Scaffold(
          backgroundColor: const Color(0xffE5E7EB),
          appBar: path == '/'
              ? null
              : AppBar(
            title: Text(
              folderName,
              style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: const Color(0xff111827),
              ),
            ),
            backgroundColor: const Color(0xffF9FAFB),
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: currentChildren.isEmpty
                ? Center(
              child: Text(
                'No items yet',
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
            )
                : SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10,bottom: 15),
                          child: TextFormField(
                            onChanged: (query) {
                              HomeCubit.get(context).searchInFolder(query, path);
                            },
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(vertical: 15),
                              filled: true,
                              fillColor: const Color(0xffD2D4D9),
                              labelText: 'Search in Drive',
                              labelStyle: GoogleFonts.montserrat(
                                color: const Color(0xff111827),
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                              suffixIcon: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: CircleAvatar(
                                    radius: 22,
                                    backgroundImage: NetworkImage(
                                      'https://media.istockphoto.com/id/1437816897/photo/business-woman-manager-or-human-resources-portrait-for-career-success-company-we-are-hiring.jpg?s=612x612&w=0&k=20&c=tyLvtzutRh22j9GqSGI33Z4HpIwv9vL_MZw_xOE19NQ=',
                                    ),
                                  ),
                                ),
                              ),
                              prefixIcon: Builder(
                                builder: (context) => IconButton(
                                  icon: const Icon(Icons.menu),
                                  onPressed: () {
                                    Scaffold.of(context).openDrawer();
                                  },
                                ),
                              ),
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(25)),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        GridView.builder(
                                      shrinkWrap: true,
                                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.1,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                                      ),
                                      itemCount: folders.length + files.length,
                                      itemBuilder: (context, index) {
                        if (index < folders.length) {
                          final folder = folders[index];
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      FolderInspectPage(
                                        path: '$path/${folder['name']}',
                                        folderName: folder['name'],
                                        children: folder['children'] ?? [],
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
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.0, vertical: 8),
                                        child: Icon(Icons.folder, size: 40,
                                            color: Color(0xff111827)),
                                      ),
                                      Expanded(
                                        child: Text(
                                          folder['name'],
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.montserrat(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xff111827),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.more_vert),
                                        onPressed: () {
                                          final renameController = TextEditingController(
                                              text: folder['name']);
                                          final tagController = TextEditingController();
                                          final emailController = TextEditingController();
                                          showDialog(
                                            context: context,
                                            builder: (context) =>
                                                DetailsDialog(
                                                  File: folder,
                                                  renameController: renameController,
                                                  tagController: tagController,
                                                  emailController: emailController,
                                                  sharedWith: folder['sharedWith'],
                                                  index: index,
                                                ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  const Icon(Icons.folder, size: 100,
                                      color: Color(0xff111827)),
                                ],
                              ),
                            ),
                          );
                        } else {
                          final fileIndex = index - folders.length;
                          final file = files[fileIndex];
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0, vertical: 8),
                                      child: _getFileIcon(file['name'], true),
                                    ),
                                    Expanded(
                                      child: Text(
                                        file['name'],
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.montserrat(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xff111827),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.more_vert),
                                      onPressed: () {
                                        final renameController = TextEditingController(
                                            text: file['name']);
                                        final tagController = TextEditingController();
                                        final emailController = TextEditingController();
                                        showDialog(
                                          context: context,
                                          builder: (context) =>
                                              DetailsDialog(
                                                File: file,
                                                renameController: renameController,
                                                tagController: tagController,
                                                emailController: emailController,
                                                sharedWith: file['sharedWith'],
                                                index: fileIndex,
                                              ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                _getFileIcon(file['name'], false),
                              ],
                            ),
                          );
                        }
                                      },
                                    ),
                      ],
                    ),
                  ),
                ),
          ),
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 50,
                width: 50,
                child: FloatingActionButton(
                  heroTag: "btn1",
                  onPressed: () => homeCubit.pickFile(context,path),
                  mini: true,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  child: const Icon(Icons.upload, size: 30),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 70,
                width: 70,
                child: FloatingActionButton(
                  heroTag: "btn2",
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) =>
                          AlertDialog(
                            backgroundColor: const Color(0xffF9FAFB),
                            title: Text('Create New Folder',
                              style: GoogleFonts.montserrat(
                                color: const Color(0xff111827),
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            content: TextFormField(
                              controller: folderNameController,
                              decoration: InputDecoration(
                                labelText: 'Folder Name',
                                labelStyle: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xff111827),
                                ),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Cancel',
                                  style: GoogleFonts.montserrat(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  String folderName = folderNameController.text;
                                  if (folderName.isNotEmpty) {
                                    homeCubit.createFolder(path,folderName);
                                    Navigator.pop(context);
                                    folderNameController.clear();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Please enter a folder name.',
                                          style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: Text('Create',
                                  style: GoogleFonts.montserrat(
                                    color: const Color(0xff111827),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                    );
                  },
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  child: const Icon(Icons.create_new_folder, size: 35),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
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
    case 'opus':
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
