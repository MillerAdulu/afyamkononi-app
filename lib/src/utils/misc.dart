import 'dart:convert';

import 'package:intl/intl.dart';

Map<int, String> permissions = {
  1: "can_create_account",
  2: "can_set_detail",
  3: "can_set_my_account_detail",
  4: "can_create_asset",
  5: "can_receive",
  6: "can_transfer",
  7: "can_transfer_my_assets",
  8: "can_add_asset_qty",
  9: "can_subtract_asset_qty",
  10: "can_add_domain_asset_qty",
  11: "can_subtract_domain_asset_qty",
  12: "can_create_domain",
  13: "can_grant_can_add_my_signatory",
  14: "can_grant_can_remove_my_signatory",
  15: "can_grant_can_set_my_account_detail",
  16: "can_grant_can_set_my_quorum",
  17: "can_grant_can_transfer_my_assets",
  18: "can_add_peer",
  19: "can_append_role",
  20: "can_create_role",
  21: "can_detach_role",
  22: "can_add_my_signatory",
  23: "can_add_signatory",
  24: "can_remove_my_signatory",
  25: "can_remove_signatory",
  26: "can_remove_signatory",
  27: "can_set_quorum",
  28: "can_get_all_acc_detail",
  29: "can_get_all_accounts",
  30: "can_get_domain_acc_detail",
  31: "can_get_domain_accounts",
  32: "can_get_my_acc_detail",
  33: "can_get_my_account",
  34: "can_get_all_acc_ast",
  35: "can_get_domain_acc_ast",
  36: "can_get_my_acc_ast",
  37: "can_get_all_acc_ast_txs",
  38: "can_get_domain_acc_ast_txs",
  39: "can_get_my_acc_ast_txs",
  40: "can_get_all_acc_txs",
  41: "can_get_domain_acc_txs",
  42: "can_get_my_acc_txs",
  43: "can_read_assets",
  44: "can_get_blocks",
  45: "can_get_roles",
  46: "can_get_all_signatories",
  47: "can_get_domain_signatories",
  48: "can_get_my_signatories",
  49: "can_get_all_txs",
  50: "can_get_my_txs"
};

String getPermission(int permission) {
  return permissions[permission];
}

mixin JWTToObject {
  Map<String, dynamic> parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('invalid token');
    }

    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('invalid payload');
    }

    return payloadMap;
  }

  String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!"');
    }

    return utf8.decode(base64Url.decode(output));
  }
}

String formatDate(int date) {
  DateTime dateTime = new DateTime.fromMillisecondsSinceEpoch(date);
  final format = new DateFormat("yMd");
  return format.format(dateTime);
}
