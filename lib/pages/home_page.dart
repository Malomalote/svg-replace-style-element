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
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar:
          AppBar(title: const Center(child: Text('SVG Replace style element'))),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: () async {
                    FilePickerResult? result = await FilePicker.platform
                        .pickFiles(
                            type: FileType.custom, allowedExtensions: ['svg']);

                    if (result != null) {
                      File file = File(result.files.single.path!);
                      svg = svgRemoveStyleLabel(file.readAsStringSync());
                      outputName = result.files.single.name;
                      outputName = outputName.replaceAll('.svg', '_copia.svg');
                      setState(() {});
                    } else {
                      // User canceled the picker
                    }
                  },
                  child: const Text('Load file')),
              (svg != '')
                  ? Column(
                      children: [
                        const SizedBox(height: 20),
                        SizedBox(
                          width: size.width - 100,
                          height: size.height - 220,
                          child: SvgPicture.string(svg, fit: BoxFit.contain),
                        ),
                        const SizedBox(height: 20),
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
                            child: const Text('Save file')),
                      ],
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
