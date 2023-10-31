import 'package:flutter/material.dart';

class AppLanguage extends ChangeNotifier {
  AppLanguage([this.language = const EnglishLanguage()]);
  Language language;

  void setLanguage(AppLanguages f) {
    Type ancient = language.runtimeType;
    switch (f) {
      case AppLanguages.french:
        language = const FrenchLanguage();
      case AppLanguages.english:
        language = const EnglishLanguage();
    }
    if (ancient != language.runtimeType) {
      notifyListeners();
    }
  }
}

abstract class Language {
  const Language();

  String get emptyList;
  String get username;
  String get password;
  String get reportAdded;
  String get reportUpdated;
  String get reportNotAdded;
  String get reportNotUpdated;
  String get offline;
  String get me;
  String get newReport;
  String get workReports;
  String get updateReport;
  String get profil;
  String get logout;
  String get report;
  String get settings;
  String get logoutConfirm;
  String get yes;
  String get no;
  String get loadFail;
  String get inputHint;
}

class EnglishLanguage extends Language {
  const EnglishLanguage();

  @override
  String get emptyList => 'Nothing to show';

  @override
  String get username => 'username';

  @override
  String get password => 'password';

  @override
  String get reportAdded => 'Report added';

  @override
  String get reportUpdated => 'report updated';

  @override
  String get reportNotAdded => 'Report not added';

  @override
  String get reportNotUpdated => 'report not updated';

  @override
  String get offline => "offline";

  @override
  String get me => "Me";

  @override
  String get newReport => "New Report";

  @override
  String get updateReport => "Update Report";

  @override
  String get workReports => "Works Reports";

  @override
  String get profil => "Profil";

  @override
  String get logout => "Log out";

  @override
  String get report => 'Reports';

  @override
  String get settings => 'Settings';

  @override
  String get logoutConfirm => "Are you sure you want to logout?";

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get loadFail => 'Cannot load content';

  @override
  String get inputHint => 'Your text goes here';
}

class FrenchLanguage extends Language {
  const FrenchLanguage();

  @override
  String get emptyList => 'Vide';

  @override
  String get username => "nom d'utiliisateur";

  @override
  String get password => 'mot de passe';

  @override
  String get reportAdded => 'rapport ajoute';

  @override
  String get reportUpdated => 'rapport mis a jour';

  @override
  String get reportNotAdded => 'rapport non ajoute';

  @override
  String get reportNotUpdated => 'rapport non mis a jour';

  @override
  String get offline => "hors ligne";

  @override
  String get me => "Moi";

  @override
  String get newReport => "Nouveau rapport";

  @override
  String get workReports => "Rapports de travail";

  @override
  String get updateReport => "Modifier rapport";

  @override
  String get profil => "Profil";

  @override
  String get logout => "Deconnexion";

  @override
  String get report => 'Rapport';

  @override
  String get settings => 'settings';

  @override
  String get logoutConfirm => "Voulez vous vraiment vous deconnecter?";

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get loadFail => 'Erreur lors du chargement du contenu';

  @override
  String get inputHint => 'Taper votre text ici';
}

enum AppLanguages { french, english }
