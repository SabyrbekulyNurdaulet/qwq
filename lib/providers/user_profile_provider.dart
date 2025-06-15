import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart' as app;

// Provider for Firebase Auth state
final authStateProvider = StreamProvider<auth.User?>((ref) {
  return auth.FirebaseAuth.instance.authStateChanges();
});

// Provider for user profile data from Firestore
final userProfileProvider = StreamProvider<app.User?>((ref) {
  final authState = ref.watch(authStateProvider);

  if (authState.asData?.value != null) {
    final uid = authState.asData!.value!.uid;
    print('DEBUG: userProfileProvider: Getting user data for uid: $uid');
    return FirebaseFirestore.instance.collection('users').doc(uid).snapshots().map((
      doc,
    ) {
      print(
        'DEBUG: userProfileProvider: Received document: ${doc.exists ? 'exists' : 'does not exist'}',
      );
      if (!doc.exists) return null;
      final data = doc.data()!;
      print('DEBUG: userProfileProvider: Document data: $data');
      final user = app.User.fromJson({...data, 'id': doc.id});
      print('DEBUG: userProfileProvider: Created user object: $user');
      return user;
    });
  }
  print('DEBUG: userProfileProvider: No auth state data');
  return Stream.value(null);
});

// Provider to check if user is approved
final isUserApprovedProvider = Provider<bool>((ref) {
  final userProfile = ref.watch(userProfileProvider);
  return userProfile.when(
    data: (user) => user?.status == 'active',
    loading: () => false,
    error: (_, __) => false,
  );
});
