import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googdocs/constants.dart';
import 'package:googdocs/models/document_model.dart';
import 'package:googdocs/models/error_models.dart';
import 'package:http/http.dart';

final documentRepositoryProvider = Provider(
  (ref) => DocumentRepository(
    client: Client(),
  ),
);

class DocumentRepository {
  final Client _client;
  DocumentRepository({
    required Client client,
  }) : _client = client;

  Future<ErrorModel> createDocument(String token) async {
    ErrorModel error = ErrorModel(
      data: null,
      error: 'Some unexpected error occured.',
    );

    try {
      var res = await _client.post(
        Uri.parse('$host/doc/create'),
        body: jsonEncode({
          'createdAt': DateTime.now().millisecondsSinceEpoch,
        }),
        headers: {
          'Content type:': 'application/json; charset=UTF-8',
        },
      );

      switch (res.statusCode) {
        case 200:
          error = ErrorModel(
            data: DocumentModel.fromJson(res.body),
            error: null,
          );

          break;
        default:
          error = ErrorModel(
            data: null,
            error: res.body,
          );
      }
    } catch (e) {
      error = ErrorModel(
        data: e.toString(),
        error: null,
      );
    }

    return error;
  }
}
