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

  Future<ErrorModel> getDocument(String token) async {
    ErrorModel error = ErrorModel(
      data: null,
      error: 'Some unexpected error occured.',
    );

    try {
      var res = await _client.get(
        Uri.parse('$host/doc/me'),
        headers: {
          'Content type:': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
      );

      switch (res.statusCode) {
        case 200:
          List<DocumentModel> documents = [];

          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            documents.add(
              DocumentModel.fromJson(
                jsonEncode(jsonDecode(res.body)[i]),
              ),
            );
          }
          error = ErrorModel(
            data: documents,
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

  Future<ErrorModel> updateDocumentTitle(
    String token,
    String id,
    String title,
  ) async {
    ErrorModel error = ErrorModel(
      data: null,
      error: 'Some unexpected error occured.',
    );

    try {
      var res = await _client.post(
        Uri.parse('$host/doc/title'),
        body: jsonEncode({
          'title': title,
          'id': id,
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

  Future<ErrorModel> getDocumentById(String token, String id) async {
    ErrorModel error = ErrorModel(
      data: null,
      error: 'Some unexpected error occured.',
    );

    try {
      var res = await _client.get(
        Uri.parse('$host/doc/$id'),
        headers: {
          'Content type:': 'application/json; charset=UTF-8',
          'x-auth-token': token,
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
          throw 'This document does not exist, please create a new one.';
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
