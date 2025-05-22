import 'package:erp_task/Home/Cubit/Home%20Cubit.dart';
import 'package:erp_task/Home/Cubit/Home%20States.dart';
import 'package:erp_task/Home/UI/Widgets/Files%20List.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Widgets/Drawer.dart';

class MyHomePage extends StatelessWidget {
  final TextEditingController folderNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {
        if (state is HomeAddFolderState) {

        } else if (state is HomeAddFileState) {

        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xffE5E7EB),
          drawer: homeDrawer(context),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                child: Column(
                  children: [
                    TextFormField(
                      onChanged: HomeCubit.get(context).searchInDrive,
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
                    homePageList(context)
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
                  onPressed: () => HomeCubit.get(context).pickFile(context,'/'),
                  mini: true,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  child: const Icon(
                    Icons.upload,
                    size: 30,
                  ),
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
                      builder: (context) => AlertDialog(
                        backgroundColor: const Color(0xffF9FAFB),
                        title:  Text('Create New Folder',style: GoogleFonts.montserrat(
                          color: const Color(0xff111827),
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),),
                        content: TextFormField(
                          controller: folderNameController,
                          decoration:  InputDecoration(
                            labelText: 'Folder Name',
                            labelStyle: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w500,
                              color: const Color(0xff111827),
                            ),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child:  Text('Cancel',style: GoogleFonts.montserrat(
                              color: Colors.red,
                              fontWeight: FontWeight.w500,
                            ),),
                          ),
                          TextButton(
                            onPressed: () {
                              String folderName = folderNameController.text;
                              if (folderName.isNotEmpty) {
                                HomeCubit.get(context).createFolder('/',folderName);
                                Navigator.pop(context);
                                folderNameController.clear();
                              } else {
                                // Show error message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('Please enter a folder name.',style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w500,
                                        ),),
                                  ),
                                );
                              }
                            },
                            child:  Text('Create',style: GoogleFonts.montserrat(
                              color: const Color(0xff111827),
                              fontWeight: FontWeight.w500,
                            ),),
                          ),
                        ],
                      ),
                    );
                  },
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  child: const Icon(
                    Icons.create_new_folder,
                    size: 35,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
