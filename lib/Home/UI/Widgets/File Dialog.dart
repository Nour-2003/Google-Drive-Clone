import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateFileDialog extends StatefulWidget {
  final PlatformFile? selectedFile;
  final TextEditingController nameController;
  final TextEditingController tagsController;
  final TextEditingController descriptionController;


  const CreateFileDialog({
    super.key,
    this.selectedFile,
    required this.nameController,
    required this.tagsController,
    required this.descriptionController,
  });
  @override
  _CreateFileDialogState createState() => _CreateFileDialogState();
}
class _CreateFileDialogState extends State<CreateFileDialog> {
  PlatformFile? selectedFile;

  @override
  void initState() {
    super.initState();
    selectedFile = widget.selectedFile;
  }
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
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
                            controller: widget.nameController,
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
                            controller: widget.tagsController,
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
                      controller: widget.descriptionController,
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
                          if (widget.nameController.text.isEmpty) {
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
                            'name': selectedFile!.name,
                            'tags':widget.tagsController.text
                                .split(RegExp(r'[,\s;]+'))
                                .map((e) => e.trim())
                                .where((e) => e.isNotEmpty) // optional: remove empty entries
                                .toList(),
                            'description': widget.descriptionController.text,
                            'size': selectedFile!.size,
                            'path': '/${selectedFile!.name}',
                            'uploadDate': DateTime.now(),
                            'isFolder': false,
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
    );
  }
}