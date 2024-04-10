
import 'dart:typed_data';

import 'package:flutter/material.dart' show
  State, GlobalKey, TextEditingController, StatefulWidget,
  BuildContext, FormState, showDatePicker,
  Text, SizedBox, Flex, Axis, ElevatedButton,
  MainAxisSize, Container, EdgeInsets, Colors, Color, SingleChildScrollView,
  MainAxisAlignment, Form, TextStyle, BoxConstraints, Center,
  BoxDecoration, BorderRadius, Border, Radius, FontWeight, Icons, Icon
;
import 'package:form_builder_file_picker/form_builder_file_picker.dart' show
  FormBuilderFilePicker, PlatformFile, FileType, TypeSelector
;
import 'package:http_parser/http_parser.dart' show MediaType;
import 'package:loader_overlay/loader_overlay.dart' show OverlayControllerWidgetExtension;
import 'package:http/http.dart' as http;
import '/utils.dart';
import '/widgets.dart' show InputTextField, createInputDecoration;

class Home extends StatefulWidget {

  final String title;

  const Home({super.key, required this.title});

  @override
  createState() => _HomeState() as State<Home>;

}


class _HomeState extends State<Home> {

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

  var _photo_file = PlatformFile(name: 'empty-file.jpg', size: 0, bytes: Uint8List(0));

  @override
  build(BuildContext context) {
    // final mediaQueryContext = MediaQuery.of(context);

    nameValidator(String? name) {
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
    }

    dniValidator(String? dni) {
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
    }

    birth_dateValidator(String? birth_date) {
      if (birth_date == null) {
        return null;
      }

      if (birth_date == '') {
        return 'Birth Date cannot be empty';
      }

      return null;
    }

    selectDate() async {
      final date = await showDatePicker(
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
    }

    onFileSelect(List<PlatformFile>? platformFiles) {
      if (platformFiles == null) {
        return;
      }

      final file = platformFiles.firstOrNull;

      if (file == null) {
        this._photo_file = PlatformFile(name: 'empty-file.jpg', size: 0, bytes: Uint8List(0));
        return;
      }

      this._photo_file = file;
    }

    submit() async {
      if (!this._formKey.currentState!.validate()) {
        return;
      }

      final url = Uri.https('proyecto-inicial-backend-agk6kyxhfa-uc.a.run.app', '/api/send-data/');

      // final url = Uri.http('10.0.2.2:8080', '/api/send-data/');

      late http.StreamedResponse response;

      final request = http.MultipartRequest('POST', url);

      request.fields.addAll({
        'creation_date': DateTime.now().millisecondsSinceEpoch.toString(),
        'name': this._nameController.text,
        'dni': this._dniController.text,
        'birth_date': DateTime.parse(this._birth_dateController.text).millisecondsSinceEpoch.toString(),
      });

      request.files.add(
        http.MultipartFile.fromBytes(
          'photo_file',
          // If `filename` is not set, file is sent to the server as text
          filename: this._photo_file.name,
          this._photo_file.bytes == null ? List.empty() : this._photo_file.bytes as List<int>,
          contentType: MediaType('image', this._photo_file.extension ?? 'jpg'),
        )
      );

      context.loaderOverlay.show();

      try {
        response = await request.send();
      }
      catch (error) {
        if (context.mounted) {
          showAlertDialog(
            context: context,
            title: 'An error happened',
            okText: 'Accept',
            messageWidget: Flex(
              direction: Axis.vertical,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Request failded.'),
                const SizedBox(height: 20,),
                Text(error.toString()),
              ],
            ),
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
          showAlertDialog(
            context: context,
            title: 'An error happened',
            okText: 'Accept',
            messageWidget: const Flex(
              direction: Axis.vertical,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Could not send data to server.'),
              ],
            ),
          );
        }
        return;
      }

      if (context.mounted) {
        showAlertDialog(
          context: context,
          title: 'Data was uploaded successfuly',
          message: 'Click Ok to continue.',
          okText: 'Ok',
        );
      }
    }

    return Center(
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
                    InputTextField(
                      label: 'Name',
                      controller: this._nameController,
                      style: const TextStyle(color: Colors.white),

                      validator: nameValidator,
                    ),
                    const SizedBox(height: 20,),
                    InputTextField(
                      label: 'DNI',
                      controller: this._dniController,
                      style: const TextStyle(color: Colors.white),

                      validator: dniValidator,
                    ),
                    const SizedBox(height: 20,),
                    InputTextField(
                      label: 'Birth Date',
                      readOnly: true,
                      controller: this._birth_dateController,
                      style: const TextStyle(color: Colors.white),

                      onTap: selectDate,

                      validator: birth_dateValidator,
                    ),
                    const SizedBox(height: 20,),
                    FormBuilderFilePicker(
                      maxFiles: 1,
                      name: "Photo",
                      decoration: createInputDecoration({'labelText': 'Photo'}),
                      withData: true,
                      previewImages: true,
                      onChanged: onFileSelect,
                      typeSelectors: [
                        TypeSelector(
                          type: FileType.image,
                          selector: Flex(
                            direction: Axis.horizontal,

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
                    ),
                    const SizedBox(height: 20,),
                    ElevatedButton(
                      onPressed: submit,

                      child: const Text('Submit'),
                    ),
                  ],
                )
              ),
            )
          ],
        )
      )
    );
  }

}
