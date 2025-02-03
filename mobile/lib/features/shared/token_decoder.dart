import 'dart:developer';

import 'package:jwt_decoder/jwt_decoder.dart';

class TokenDecoder {
  static String getUserId({required String token}) {
    // if (!JwtDecoder.isExpired(token)) {
    //   print("Token jest ważny.");
    // } else {
    //   print("Token wygasł.");
    // }

    final decodedToken = JwtDecoder.decode(token);

    log("Token Type: ${decodedToken['token_type']}");
    log("Expiration Time: ${decodedToken['exp']}");
    log("Issued At: ${decodedToken['iat']}");
    log("JWT ID: ${decodedToken['jti']}");
    log("User Identifier: ${decodedToken['user_identifier']}");
    return decodedToken['user_identifier'];
  }
}
