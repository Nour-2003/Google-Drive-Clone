import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget homeDrawer(context) => Drawer(
      backgroundColor: const Color(0xffE5E7EB),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 100,
            child:  DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xffE5E7EB),
              ),
              child: Text('Google Drive',style: GoogleFonts.montserrat(
                fontSize: 25,
                fontWeight: FontWeight.w600,
                color: const Color(0xff111827),
              ),),
            ),
          ),
          ListTile(
            title:  Text('Your Folders',style: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: const Color(0xff111827),
            ),),
            leading: const Icon(Icons.folder),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Shared Folders',style: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: const Color(0xff111827),
            ),),
            leading: const Icon(Icons.folder),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title:  Text('Starred',style: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: const Color(0xff111827),
            ),),
            leading: const Icon(Icons.star),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
