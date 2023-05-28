import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:shot_locker/authentication/model/auth_model.dart';

class TokenSharedPref {
  //TokenSharedPreference keys
  final String _token = 'Token';
  final String _key = 'ShotLockerToken';

  Future<void> storeToken(TokenData incomingtokenData) async {
    final _tokenPath = await SharedPreferences.getInstance();
    var _encodedData = jsonEncode({
      _token: incomingtokenData.token,
    });
    await _tokenPath.setString(_key, _encodedData);
  }

  Future<TokenData> fetchStoredToken() async {
    final _tokenPath = await SharedPreferences.getInstance();

    if (!_tokenPath.containsKey(_key)) {
      return TokenData(token: null);
    }
    final _extractedUserToken =
        json.decode(_tokenPath.getString(_key)!) as Map<String, dynamic>;
    var _tokenData = TokenData(
      token: _extractedUserToken[_token],
    );
    return _tokenData;
  }

  Future<void> deleteToken() async {
    final _tokenPath = await SharedPreferences.getInstance();
    //Clear the whole shared preference including token and stripe credentials
    _tokenPath.clear();
  }

  Future<bool> hasToken() async {
    final _hasToken = await fetchStoredToken();
    if (_hasToken.token == null) {
      return false;
    } else {
      return true;
    }
  }
}
