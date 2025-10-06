import 'package:flutter/material.dart' show FontWeight, TextLeadingDistribution, TextStyle;

const double kHPadding = 16;
const double kVPadding = 10;

const double kCardTileVPadding = 8;

const double iconMenuIconSize = 36;
const double detailBriefDescriptionIconSize = 32;

const double placeDescriptionIconSize = 14;
const double detailDescriptionIconSize = 16;

const double profileAvatarDiameter = 36;
const double profilePictureDiameter = 100;

const double uploadResolution = 1920;
const int imageQuality = 70;

const double portraitKeypadRatio = 1.68;
const double mediumKeypadRatio = 3.3;
const double landscapeKeypadRatio = 5.5;

const double messageSenderHeight = 50;

const int microSecondsSinceEpoch2024 = 1704042000000000;

const String firebaseOptionsApiKey = String.fromEnvironment('FIREBASE_OPTIONS_API_KEY');
const String firebaseOptionsAuthDomain = String.fromEnvironment('FIREBASE_OPTIONS_AUTH_DOMAIN');
const String firebaseOptionsProjectId = String.fromEnvironment('FIREBASE_OPTIONS_PROJECT_ID');
const String firebaseOptionsStorageBucket = String.fromEnvironment('FIREBASE_OPTIONS_STORAGE_BUCKET');
const String firebaseOptionsMessagingSenderId = String.fromEnvironment('FIREBASE_OPTIONS_MESSAGING_SENDER_ID');
const String firebaseOptionsAppId = String.fromEnvironment('FIREBASE_OPTIONS_APP_ID');
const String firebaseOptionsMeasurementId = String.fromEnvironment('FIREBASE_OPTIONS_MEASUREMENT_ID');

//Add font weight : font family
const TextStyle kPTextStyle = TextStyle(
  height: 1.68,
  leadingDistribution: TextLeadingDistribution.even,
  fontFamily: 'Kantumruy',
);
TextStyle kPDisplayTextStyle = kPTextStyle.copyWith(
  fontWeight: FontWeight.w900,
);
TextStyle kPTitleTextStyle = kPTextStyle.copyWith(
  fontWeight: FontWeight.w800,
);
TextStyle kPHeadlineTextStyle = kPTextStyle.copyWith(
  fontWeight: FontWeight.w700,
);
TextStyle kPLabelTextStyle = kPTextStyle.copyWith(
  fontWeight: FontWeight.w500,
);
TextStyle kPBodyTextStyle = kPTextStyle.copyWith(
  fontWeight: FontWeight.w400,
);

//Add font color : font family
const TextStyle kTextStyle = TextStyle(
  height: 1.68,
  leadingDistribution: TextLeadingDistribution.even,
);
TextStyle kDisplayTextStyle = kTextStyle.copyWith(
  fontWeight: FontWeight.w600,
  fontFamily: 'Tomorrow',
);
TextStyle kTitleTextStyle = kTextStyle.copyWith(
  fontWeight: FontWeight.w500,
  fontFamily: 'Tomorrow',
);
TextStyle kHeadlineTextStyle = kTextStyle.copyWith(
  fontWeight: FontWeight.w400,
  fontFamily: 'Tomorrow',
);
TextStyle kLabelTextStyle = kTextStyle.copyWith(
  fontWeight: FontWeight.w500,
  fontFamily: 'Saira',
);
TextStyle kBodyTextStyle = kTextStyle.copyWith(
  fontWeight: FontWeight.w400,
  fontFamily: 'Saira',
);
