import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vbt_app/services/user/user_service.dart';

final userProvider = StreamProvider.autoDispose<User>((_) async* {
  await for(final user in UserService.firebaseAuth.userChanges()) {
    if (user != null) {
      yield user;
    }
  }
});

final isSignedInProvider = StreamProvider.autoDispose<bool>((_) async* {
  await for(final user in UserService.firebaseAuth.userChanges()) {
    if (user != null) {
      yield true;
    } else {
      yield false;
    }
  }
});
