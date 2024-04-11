import 'package:form_builder_file_picker/form_builder_file_picker.dart' show PlatformFile;
import 'package:http_parser/http_parser.dart' show MediaType;
import 'package:http/http.dart' as http;
import 'dart:convert' show json;


class Registry {

  Registry({required this.creation_date, required this.name, required this.dni, required this.birth_date, required this.photo_url});

  final int creation_date;

  final String name;

  final String dni;

  final int birth_date;

  final String? photo_url;

  static Registry fromJSON(dynamic data) {
    return Registry(
      creation_date: data['creation_date'] as int,
      name: data['name'] as String,
      dni: data['dni'] as String,
      birth_date: data['birth_date'] as int,
      photo_url: data['photo_url'] as String?,
    );
  }

  static List<Registry> fromJSONArray(dynamic list) {
    final registryList = <Registry>[];

    for (final item in list as Iterable) {
      final registry = Registry.fromJSON(item);
      registryList.add(registry);
    }

    return registryList;
  }

}


Future<List<Registry>> getData({String? filter}) async {
  final url = Uri.https(
    'proyecto-inicial-backend-agk6kyxhfa-uc.a.run.app',
    '/api/get-all-data/',
    {'filter': filter},
  );

  // final url = Uri.http(
  //   '10.0.2.2:8080',
  //   '/api/get-all-data/',
  //   {'filter': filter},
  // );

  final http.Response response;

  try {
    response = await http.get(url);
  } catch (reason) {
    print(reason);

    throw Exception('Failed to make request to the server.');
  }

  if (response.statusCode != 200) {
    throw Exception('Request failed with status code ${response.statusCode}.');
  }

  try {
    final data = Registry.fromJSONArray(json.decode(response.body));
    return data;
  } catch (reason) {
    print(reason);

    throw Exception('Failed to parse response.');
  }
}


Future<http.StreamedResponse> sendData({
  required String name,
  required String dni,
  required String birth_date,
  required PlatformFile photo_file
}) async {
  final url = Uri.https('proyecto-inicial-backend-agk6kyxhfa-uc.a.run.app', '/api/send-data/');

  // final url = Uri.http('10.0.2.2:8080', '/api/send-data/');

  final request = http.MultipartRequest('POST', url);

  request.fields.addAll({
    'creation_date': DateTime.now().millisecondsSinceEpoch.toString(),
    'name': name,
    'dni': dni,
    'birth_date': DateTime.parse(birth_date).millisecondsSinceEpoch.toString(),
  });

  request.files.add(
    http.MultipartFile.fromBytes(
      'photo_file',
      photo_file.bytes == null ? List.empty() : photo_file.bytes as List<int>,
      // If `filename` is not set, file is sent to the server as text
      filename: photo_file.name,
      contentType: MediaType('image', photo_file.extension ?? 'jpg'),
    )
  );

  final response = await request.send();

  if (response.statusCode != 200) {
    throw Exception('Request failed with status code ${response.statusCode}.');
  }

  return response;
}
