import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googdocs/constants.dart';
import 'package:googdocs/models/error_models.dart';
import 'package:googdocs/models/user_models.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    googleSignIn: GoogleSignIn(),
    client: Client(),
  ),
);

final userProvider = StateProvider<UserModel?>((ref) => null);
// ? -> non-nullable, it cannot be null

class AuthRepository {
  final GoogleSignIn _googleSignIn;
  final Client _client;

  AuthRepository({
    required GoogleSignIn googleSignIn,
    required Client client,
  })  : _googleSignIn = googleSignIn,
        _client = client;
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
          name: user.displayName!,
          profilePic: user.photoUrl!,
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
            );
            error = ErrorModel(
              data: newUser,
              error: null,
            );
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
