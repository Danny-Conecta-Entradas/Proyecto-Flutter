import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:form_builder_file_picker/form_builder_file_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:loader_overlay/loader_overlay.dart';


void main() {
  runApp(const AppRoot());
}

class AppRoot extends StatelessWidget {

  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(),

      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter App'),
          backgroundColor: const Color.fromARGB(255, 48, 102, 181),
          foregroundColor: Colors.white,
        ),

        body: const LoaderOverlay(
          child: DefaultTextStyle(
            style: TextStyle(color: Colors.white),
            child: App(title: 'App Title'),
          )
        )
      ),
    );
  }

}

class App extends StatefulWidget {

  final String title;

  const App({super.key, required this.title});

  @override
  State<App> createState() => AppState();

}


class AppState extends State<App> {

  // String _birth_date = '';

  // void setBirthDate(String newValue) {
  //   setState(() {
  //     this._birth_date = newValue;
  //   });
  // }

  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();

  final _dniController = TextEditingController();

  final _birth_dateController = TextEditingController();

  PlatformFile _photo_file = PlatformFile(name: 'empty-file.jpg', size: 0, bytes: Uint8List(0));

  @override
  Widget build(BuildContext context) {
    // final mediaQueryContext = MediaQuery.of(context);

    InputDecoration createInputDecoration(Map<String, dynamic> inputDecorationSettings) {
      const baseInputDecorationSettings = {
        'labelStyle': TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 18, fontWeight: FontWeight.bold),
        'hintStyle': TextStyle(color: Color.fromARGB(255, 159, 159, 159)),
        'enabledBorder': UnderlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 149, 149, 149))),
        'focusedBorder': UnderlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 0, 255, 234))),
        'errorStyle': TextStyle(color: Colors.red, fontSize: 14),
        'errorBorder': UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
      };

      final mixedInputDecorationSettigns  = {
        ...baseInputDecorationSettings,
        ...inputDecorationSettings,
      }.map((key, value) => MapEntry(Symbol(key), value));
      final inputDecoration = Function.apply(InputDecoration.new, [], mixedInputDecorationSettigns);

      return inputDecoration;
    }

    return FractionallySizedBox(
      widthFactor: 1.0,
      heightFactor: 1.0,

      child: Container(
        padding: const EdgeInsets.all(10),
        color: const Color.fromARGB(255, 24, 185, 110),

        child: Center(
          widthFactor: 1.0,
          heightFactor: 1.0,

          child: SingleChildScrollView(
            child: Flex(
              direction: Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Form(
                  key: this._formKey,

                  child: Container(
                    constraints: const BoxConstraints(minHeight: 400),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 105, 23, 168),
                      border: Border.all(width: 2, color: const Color.fromARGB(255, 255, 255, 255)),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),

                    child: Flex(
                      direction: Axis.vertical,
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        const Text('Send Data', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                        const SizedBox(height: 40,),
                        TextFormField(
                          controller: this._nameController,
                          style: const TextStyle(color: Colors.white),
                          decoration: createInputDecoration({'labelText': 'Name'}),

                          validator: (String? name) {
                            if (name == null) {
                              return null;
                            }

                            if (name == '') {
                              return 'Name cannot be empty';
                            }

                            if (name.length > 30) {
                              return 'Name cannot be longer than 30 characters';
                            }

                            return null;
                          },
                        ),
                        const SizedBox(height: 20,),
                        TextFormField(
                          controller: this._dniController,
                          style: const TextStyle(color: Colors.white),
                          decoration: createInputDecoration({'labelText': 'DNI'}),

                          validator: (String? dni) {
                            if (dni == null) {
                              return null;
                            }

                            if (dni == '') {
                              return 'DNI cannot be empty';
                            }

                            final dniRegexp = RegExp(r'^[1-9]{8,8}[A-Z]$');
                            if (!dniRegexp.hasMatch(dni)) {
                              return 'DNI must follow this format: 12345678A';
                            }

                            return null;
                          },
                        ),
                        const SizedBox(height: 20,),
                        TextFormField(
                          readOnly: true,
                          controller: this._birth_dateController,
                          style: const TextStyle(color: Colors.white),
                          decoration: createInputDecoration({'labelText': 'Birth Date'}),
                          onTap: () async {
                            DateTime? date = await showDatePicker(
                              context: context,
                              firstDate: DateTime.parse('1920-01-01'),
                              lastDate: DateTime.now()
                            );

                            if (date == null) {
                              this._birth_dateController.text = '';
                              return;
                            }

                            final year = date.year.toString().padLeft(4, '0');
                            final month = date.month.toString().padLeft(2, '0');
                            final day = date.day.toString().padLeft(2, '0');

                            final dateString = '${year}-${month}-${day}';
                            this._birth_dateController.text = dateString;
                          },

                          validator: (String? birth_date) {
                            if (birth_date == null) {
                              return null;
                            }

                            if (birth_date == '') {
                              return 'Birth Date cannot be empty';
                            }

                            return null;
                          },
                        ),
                        const SizedBox(height: 20,),
                        FormBuilderFilePicker(
                          name: "images",
                          decoration: createInputDecoration({'labelText': 'Photo'}),
                          withData: true,
                          previewImages: true,
                          onChanged: (platformFiles) {
                            if (platformFiles == null) {
                              return;
                            }

                            final file = platformFiles.firstOrNull;

                            if (file == null) {
                              this._photo_file = PlatformFile(name: 'empty-file.jpg', size: 0, bytes: Uint8List(0));
                              return;
                            }

                            file.bytes;

                            this._photo_file = file;
                          },
                          typeSelectors: [
                            TypeSelector(
                              type: FileType.image,
                              selector: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: const Icon(Icons.add_circle),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(top: 10, left: 8.0),
                                    child: const Text("Select image"),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          // onFileLoading: (val) {
                          //   print(val);
                          // },
                        ),
                        const SizedBox(height: 20,),
                        ElevatedButton(
                          onPressed: () async {
                            if (!this._formKey.currentState!.validate()) {
                              return;
                            }

                            final url = Uri.https('proyecto-inicial-backend-agk6kyxhfa-uc.a.run.app', '/api/send-data/');

                            // final url = Uri.http('10.0.2.2:8080', '/api/send-data/');

                            late http.StreamedResponse response;

                            final request = http.MultipartRequest('POST', url);

                            request.fields.addAll({
                              'creation_date': DateTime.now().microsecondsSinceEpoch.toString(),
                              'name': this._nameController.text,
                              'dni': this._dniController.text,
                              'birth_date': DateTime.parse(this._birth_dateController.text).millisecondsSinceEpoch.toString(),
                            });

                            print('File Name: ${this._photo_file.name}');

                            request.files.add(
                              http.MultipartFile.fromBytes(
                                'photo_file',
                                // If `filename` is not set, file is sent to the server as text
                                filename: this._photo_file.name,
                                this._photo_file.bytes == null ? List.empty() : this._photo_file.bytes as List<int>,
                                contentType: MediaType('image', this._photo_file.extension ?? 'jpg'),
                              )
                            );

                            try {
                              context.loaderOverlay.show();

                              response = await request.send();
                            }
                            catch (error) {
                              if (context.mounted) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('An error happened'),
                                      content: Flex(
                                        direction: Axis.vertical,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text('Request failded.'),
                                          const SizedBox(height: 20,),
                                          Text(error.toString()),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {Navigator.pop(context);},
                                          child: const Text('Accept'),
                                        ),
                                      ],
                                    );
                                  },
                                );

                                return;
                              }
                            }
                            finally {
                              if (context.mounted) {
                                context.loaderOverlay.hide();
                              }
                            }

                            if (response.statusCode != 200) {
                              response.stream.bytesToString()
                              .then((value) {
                                print('Response: ${value}');
                                print('Response Status: ${response.statusCode}');
                              });

                              if (context.mounted) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('An error happened'),
                                      content: const Flex(
                                        direction: Axis.vertical,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text('Could not send data to server.'),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {Navigator.pop(context);},
                                          child: const Text('Accept'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                              return;
                            }

                            if (context.mounted) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Data was uploaded successfuly'),
                                    content: const Text('Click Ok to continue.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {Navigator.pop(context);},
                                        child: const Text('Ok'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },

                          child: const Text('Submit'),
                        ),
                      ],
                    )
                  ),
                )
              ],
            ),
          )
        ),
      )
    );
  }

}
