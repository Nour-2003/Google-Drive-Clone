import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Home/Cubit/Home Cubit.dart';
import 'Home/UI/Screens/Folder Details.dart';
import 'Home/UI/Screens/Home Page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeCubit()..loadMockData(),
        ),
      ],
      child: Builder(
          builder: (context) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              ),
              home: FolderInspectPage(
                children: BlocProvider.of<HomeCubit>(context).filteredItems,
                path: '/',
                folderName: 'Root',
              ),
            );
          }
      ),
    );
  }
}