import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/common/repositories/common_firebase_storage_repository.dart';
import 'package:whatsapp_ui/common/utils/utils.dart';
import 'package:whatsapp_ui/features/auth/screen/otp_screen.dart';
import 'package:whatsapp_ui/features/auth/screen/user_information_screen.dart';
import 'package:whatsapp_ui/model/user_model.dart';
import 'package:whatsapp_ui/screens/mobile_layout_screen.dart';

import '../../../model/user_model.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  ),
);

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRepository({required this.auth, required this.firestore});

  Future<UserModel?> getCurrentUserData() async {
    var userData =
        await firestore.collection('users').doc(auth.currentUser?.uid).get();
    UserModel? user;

    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }
    return user;
  }

  void signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      await auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await auth.signInWithCredential(credential);
          },
          verificationFailed: ((e) {
            throw Exception(e.message);
          }),
          codeSent: ((String verificationId, int? resendToken) {
            Navigator.pushNamed(
              context,
              OTPScreen.routeName,
              arguments: verificationId,
            );
          }),
          codeAutoRetrievalTimeout: ((String verificationId) {
            // Navigator.pushNamed(context, OTPScreen.routeName);
          }));
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }

  void verifyOTP({
    required BuildContext context,
    required String verificationId,
    required String userOTP,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: userOTP,
      );
      await auth.signInWithCredential(credential);
      Navigator.pushNamedAndRemoveUntil(
          context, UserInformationScreen.routeName, (route) => false);
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }

  void saveUserDataToFirebase({
    required BuildContext context,
    required String name,
    required File? profilePic,
    required ProviderRef ref,
  }) async {
    try {
      String uid = auth.currentUser!.uid;
      String profileUrl =
          "https://png.pngitem.com/pimgs/s/24-248235_user-profile-avatar-login-account-fa-user-circle.png";

      if (profilePic != null) {
        profileUrl = await ref
            .read(commonFirebaseStorageRepositoryProvider)
            .storeFileTOFirebase(
              "profile/$uid",
              profilePic,
            );
      }
      var user = UserModel(
          name: name,
          uid: uid,
          profilePic: profileUrl,
          isOnline: true,
          phoneNumber: auth.currentUser!.phoneNumber!,
          groupId: []);
      log(user.toMap().toString());
      await firestore.collection("users").doc(uid).set(user.toMap());

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MobileLayoutScreen()),
          (route) => false);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Stream<UserModel> userData(String userID) {
    return firestore.collection('users').doc(userID).snapshots().map(
          (event) => UserModel.fromMap(
            event.data()!,
          ),
        );
  }
}
