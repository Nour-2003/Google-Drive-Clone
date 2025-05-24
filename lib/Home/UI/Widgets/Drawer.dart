import 'package:erp_task/Home/Cubit/Home%20Cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget homeDrawer(context) => Drawer(
      backgroundColor: const Color(0xffE5E7EB),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 100,
            child: DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xffE5E7EB),
              ),
              child: Text(
                'Google Drive',
                style: GoogleFonts.montserrat(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff111827),
                ),
              ),
            ),
          ),
          ListTile(
            title: Text(
              'All Items',
              style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: const Color(0xff111827),
              ),
            ),
            leading: const Icon(Icons.all_inbox),
            onTap: () {
              HomeCubit.get(context).showAllItems();
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(
              'Your Folders',
              style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: const Color(0xff111827),
              ),
            ),
            leading: const Icon(Icons.folder),
            onTap: () {
              HomeCubit.get(context).showFoldersOnly();
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(
              'Your Files',
              style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: const Color(0xff111827),
              ),
            ),
            leading: const Icon(Icons.folder),
            onTap: () {
              HomeCubit.get(context).showFilesOnly();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
