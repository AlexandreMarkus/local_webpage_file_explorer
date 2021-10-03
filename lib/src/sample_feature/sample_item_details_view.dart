import 'dart:io' as io;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:url_launcher/url_launcher.dart';

/// Displays detailed information about a SampleItem.
class SampleItemDetailsView extends StatelessWidget {
  const SampleItemDetailsView({Key? key}) : super(key: key);

  static const routeName = '/sample_item';

  @override
  Widget build(BuildContext context) {
    String folderName = ModalRoute.of(context)!.settings.arguments.toString();
    String currentFolderPath =
        Directory.current.parent.path + '/' + folderName + '/';
    List items = io.Directory(currentFolderPath).listSync();
    return Scaffold(
      appBar: AppBar(
        title: Text(folderName),
      ),
      body: ListView.builder(
        // Providing a restorationId allows the ListView to restore the
        // scroll position when a user leaves and returns to the app after it
        // has been killed while running in the background.
        restorationId: 'sampleItemListView',
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          final currentDirectoryName = basename(items[index]
              .toString()
              .substring(0, items[index].toString().length - 1));

          return ListTile(
              title: Text(currentDirectoryName),
              leading: const CircleAvatar(
                // Display the Flutter Logo image asset.
                foregroundImage: AssetImage('assets/images/flutter_logo.png'),
              ),
              onTap: () async {
                // Navigate to the details page. If the user leaves and returns to
                // the app after it has been killed while running in the
                // background, the navigation stack is restored.
                if (isNumeric(currentDirectoryName)) {
                  await launch(
                    'file://' +
                        currentFolderPath +
                        currentDirectoryName +
                        '/index.html',
                    enableJavaScript: true,
                  );
                } else {
                  if (Directory(currentFolderPath + currentDirectoryName)
                      .existsSync()) {
                    Navigator.restorablePushNamed(
                        context, SampleItemDetailsView.routeName,
                        arguments: folderName + '/' + currentDirectoryName);
                  }
                }
              });
        },
      ),
    );
  }
}

bool isNumeric(String s) {
  return double.tryParse(s) != null;
}
