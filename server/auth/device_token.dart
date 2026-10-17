import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';

/// Validates the `X-Device-Token` header against `DEVICE_TOKEN_SECRET`.
bool isValidDeviceToken(HttpRequest request) {
  final secret = Platform.environment['DEVICE_TOKEN_SECRET'];
  final token = request.headers.value('X-Device-Token');
  if (secret == null || secret.isEmpty || token == null) return false;

  final valid = token == secret;
  if (!valid) {
    print('Rejected device token: $token');
  }
  return valid;
}

/// Logs a fingerprint of the configured secret at startup so operators can
/// confirm which one is active without printing it in cleartext.
void logDeviceTokenFingerprint() {
  final secret = Platform.environment['DEVICE_TOKEN_SECRET'];
  if (secret == null) return;
  final fingerprint = sha256.convert(utf8.encode(secret)).toString();
  print('DEVICE_TOKEN_SECRET fingerprint: $fingerprint');
}
