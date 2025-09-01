import 'package:agenda/layers/domain/auth/entity/register.dart';
import 'package:agenda/layers/domain/auth/repository/register/register_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterRepoImpl implements RegisterRepository {
  @override
  Future<bool> register(Register register) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: register.email ?? '',
        password: register.password ?? '',
      );
      return true;
    } on FirebaseException catch (e) {
      debugPrint(e.message);
      return false;
    }
  }

 
}


// class RegisterRepoImpl implements RegisterRepository {
//   @override
//   Future<bool> register(Register register) async {
//     try {
//       // AppCheck-ni tekshirish va foydalanuvchi ma'lumotlarini saqlash
//       await FirebaseAppCheck.instance.verifyAppCheckToken();

//       await FirebaseAuth.instance.createUserWithEmailAndPassword(
//         email: register.email ?? '',
//         password: register.password ?? '',
//       );
//       return true;
//     } on FirebaseException catch (e) {
//       debugPrint(e.message);
//       return false;
//     }
//   }
// }
