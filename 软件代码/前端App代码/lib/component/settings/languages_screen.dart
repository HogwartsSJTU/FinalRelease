import 'package:Hogwarts/utils/StorageUtil.dart';
import 'package:Hogwarts/utils/FilterStaticDataType.dart';
import 'package:flutter/material.dart';
import 'package:Hogwarts/component/settings/settings_ui.dart';

class LanguagesScreen extends StatefulWidget {
  @override
  _LanguagesScreenState createState() => _LanguagesScreenState();
}

class _LanguagesScreenState extends State<LanguagesScreen> {
  int languageIndex = GlobalSetting.globalSetting.lanIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(languageIndex == 0 ? '语言' : 'Languages')),
      body: SettingsList(
        sections: [
          SettingsSection(tiles: [
            SettingsTile(
              title: "简体中文",
              trailing: trailingWidget(0),
              onTap: () {
                changeLanguage(0);
              },
            ),
            SettingsTile(
              title: "English",
              trailing: trailingWidget(1),
              onTap: () {
                changeLanguage(1);
              },
            ),
            SettingsTile(
              title: "español", //西班牙语
              trailing: trailingWidget(2),
              onTap: () {
                changeLanguage(2);
              },
            ),
            SettingsTile(
              title: "Deutsch", //德语
              trailing: trailingWidget(3),
              onTap: () {
                changeLanguage(3);
              },
            ),
          ]),
        ],
      ),
    );
  }

  Widget trailingWidget(int index) {
    return (languageIndex == index)
        ? Icon(Icons.check, color: Colors.blue)
        : Icon(null);
  }

  void changeLanguage(int index) {
    GlobalSetting.globalSetting.lanIndex = index;
    setState(() {
      languageIndex = index;
    });
  }
}
