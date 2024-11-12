import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppColors {
  static const Color pNoColor = Colors.transparent;
  static const Color pBlackColor = Colors.black;
  static const Color pBlack12Color = Colors.black12;
  static const Color pBlack87Color = Colors.black87;
  static const Color pWhiteColor = Colors.white;
  static const Color pWhite54Color = Colors.white54;
  static const Color pWhite70Color = Colors.white70;
  static Color pDeepPurple = Colors.deepPurpleAccent.shade400;
  static const Color pGreenColor = Color(0xFF0EBD08);
  static const Color pDarkGreenColor = Color(0xFF047C00);
  static const Color pGreen38Color = Color(0x610EBD08);
  static const Color pDarkOrangeColor = Color(0xFF8F2400);
  static const Color pLightOrangeColor = Color(0x8FF53D00);
  static const Color pBGWhiteColor = Color(0xFFFCFCFC);
  static const Color pLightBlueColor = Color(0xFFA7D2F9);
  static const Color pLightGreenColor = Color(0xFF8AB33D);
  static const Color pLightPurpleColor = Color(0xFFC1C5FF);
  static const Color pPurpleColor = Color(0xFF651BCD);
  static const Color pOrangeColor = Color(0xFFEE692E);
  static const Color pSOrangeColor = Color(0xFFF53D00);
  static const Color pBGGreyColor = Color(0xFF868686);
  static const Color pGreyColor = Colors.grey;
  static Color get pGrey100Color => Colors.grey.shade100;
  static Color get pGrey400Color => Colors.grey.shade400;
  static Color get pGrey800Color => Colors.grey.shade800;
  static const Color pTFColor = Color(0xFFEEDCDC);
  static const Color pDarkGreyColor = Color(0xFF544E4E);
  static const Color pMGreyColor = Color(0xFFBBBBBB);
  static const Color pLightGreyColor = Color(0xFFE9E9E9);
  static const Color pVioletColor = Color(0xFF5762FF);
  static const Color pBlueColor = Color(0xFF3299F4);
  static const Color pYellow = Color(0xFFF4B146);
}

final userId = FirebaseAuth.instance.currentUser!.uid;
