import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils/utils.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String svg = '';
  String outputName = 'output.svg';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text('SVG Transform'))),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () async {
                  FilePickerResult? result = await FilePicker.platform
                      .pickFiles(
                          type: FileType.custom, allowedExtensions: ['svg']);

                  if (result != null) {
                    File file = File(result.files.single.path!);
                    svg = transformSVG(file.readAsStringSync());
                    outputName = result.files.single.name;
                    outputName = outputName.replaceAll('.svg', '_copia.svg');
                    setState(() {});
                  } else {
                    // User canceled the picker
                  }
                },
                child: const Text('Cargar archivo')),
            (svg != '')
                ? Column(
                    children: [
                      SvgPicture.string(svg),
                      ElevatedButton(
                          onPressed: () async {
                            String? outputFile =
                                await FilePicker.platform.saveFile(
                              dialogTitle: 'Please select an output file:',
                              fileName: outputName,
                            );

                            if (outputFile == null) {
                              // User canceled the picker
                            } else {
                              File newFile = File(outputFile);
                              newFile.writeAsStringSync(svg);
                            }
                          },
                          child: const Text('Guardar archivo')),
                    ],
                  )
                : Container(
                    width: 100,
                    height: 100,
                    color: Colors.red,
                  )
          ],
        ),
      ),
    );
  }
}
