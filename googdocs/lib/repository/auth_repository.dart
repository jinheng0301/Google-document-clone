import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googdocs/constants.dart';
import 'package:googdocs/models/error_models.dart';
import 'package:googdocs/models/user_models.dart';
import 'package:googdocs/repository/local_storage_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    googleSignIn: GoogleSignIn(),
    client: Client(),
    localStorageRepository: LocalStorageRepository(),
  ),
);

final userProvider = StateProvider<UserModel?>((ref) => null);
// ? -> non-nullable, it cannot be null

class AuthRepository {
  final GoogleSignIn _googleSignIn;
  final Client _client;
  final LocalStorageRepository _localStorageRepository;

  AuthRepository({
    required GoogleSignIn googleSignIn,
    required Client client,
    required LocalStorageRepository localStorageRepository,
  })  : _googleSignIn = googleSignIn,
        _client = client,
        _localStorageRepository = localStorageRepository;
  // create a private variable which will use throughout application

  Future<ErrorModel> signInWithGoogle() async {
    ErrorModel error = ErrorModel(
      data: null,
      error: 'Some unexpected error occured.',
    );

    try {
      final user = await _googleSignIn.signIn();
      if (user != null) {
        final userAcc = UserModel(
          email: user.email,
          name: user.displayName ?? '',
          profilePic: user.photoUrl ?? '',
          uid: '',
          token: '',
        );

        var res = await _client.post(
          Uri.parse('$host/api/signup'),
          body: userAcc.toJson(),
          headers: {
            'Content type:': 'application/json; charset=UTF-8',
          },
        );

        switch (res.statusCode) {
          case 200:
            final newUser = userAcc.copyWith(
              uid: jsonDecode(res.body)['user']['_id'],
              token: jsonDecode(res.body)['token'],
            );
            error = ErrorModel(
              data: newUser,
              error: null,
            );
            _localStorageRepository.setToken(newUser.token);
            break;
          default:
        }
      }
    } catch (e) {
      error = ErrorModel(
        data: e.toString(),
        error: null,
      );
    }

    return error;
  }

  Future<ErrorModel> getUserData() async {
    ErrorModel error = ErrorModel(
      data: null,
      error: 'Some unexpected error occured.',
    );

    try {
      String? token = await _localStorageRepository.getToken();

      if (token != null) {
        var res = await _client.get(
          Uri.parse('$host/api/signup'),
          headers: {
            'Content type:': 'application/json; charset=UTF-8',
            'x-auth-token': token,
          },
        );

        switch (res.statusCode) {
          case 200:
            final newUser = UserModel.fromJson(
              jsonEncode(
                jsonDecode(res.body)['user'],
              ),
            ).copyWith(token: token);
            error = ErrorModel(
              data: newUser,
              error: null,
            );
            _localStorageRepository.setToken(newUser.token);
            break;
          default:
        }
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
