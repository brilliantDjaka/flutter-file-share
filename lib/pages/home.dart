import 'dart:io';

import 'package:flutter/material.dart';
import 'package:libadwaita/libadwaita.dart';
import 'package:libadwaita_bitsdojo/libadwaita_bitsdojo.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String resultText = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return AdwScaffold(
      headerbar: (_) => AdwHeaderBar.bitsdojo(
          appWindow: appWindow,
          start: const [
            AdwHeaderButton(
              icon: Icon(Icons.nightlight_round, size: 15),
            ),
          ],
          title: const SizedBox(
            child: Text('File Share'),
          )),
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AdwButton.pill(
            child: const Text('Upload File'),
            onPressed: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles();
              if (result != null && result.files.single.path != null) {
                File file = File(result.files.single.path!);
                setState(() {
                  resultText = 'Loading ...';
                });
                String res = await uploadFile(file);
                setState(() {
                  resultText = res;
                });
              }
            },
          ),
          loading
              ? const Text('Result: loading...')
              : resultText == ''
                  ? const Text('Result: ')
                  : InkWell(
                      child: Text('Result: $resultText'),
                      onTap: () async {
                        !await launch(resultText);
                      },
                    )
        ],
      )),
    );
  }
}

Future<String> uploadFile(File file) async {
  String filename = basename(file.path);
  Uri url = Uri.parse('https://transfer.sh/${filename}');
  http.Response response = await http.put(url, body: file.readAsBytesSync());
  return response.body;
}
