import 'package:Hogwarts/component/custom_drawer/home_drawer.dart';
import 'package:Hogwarts/component/custom_drawer/navigation_home_screen.dart';
import 'package:Hogwarts/utils/StorageUtil.dart';
import 'package:Hogwarts/utils/FilterStaticDataType.dart';
import 'package:flutter/material.dart';
import 'package:Hogwarts/component/settings/settings_ui.dart';

import 'package:Hogwarts/component/settings/languages_screen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool lockInBackground = true;
  bool notificationsEnabled = true;
  int lanIndex = GlobalSetting.globalSetting.lanIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(lanIndex == 0 ? '设置' : 'Setting')),
      body: SettingsList(
        // backgroundColor: Colors.orange,
        sections: [
          SettingsSection(
            title: lanIndex == 0 ? '基本' : 'Base',
            // titleTextStyle: TextStyle(fontSize: 30),
            tiles: [
              SettingsTile(
                title: lanIndex == 0 ? '语言' : 'Language',
                subtitle: lanIndex == 0 ? '中文' : 'English',
                leading: Icon(Icons.language),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                          builder: (BuildContext context) => LanguagesScreen()))
                      .then((value) => {
                            this.setState(() {
                              lanIndex = GlobalSetting.globalSetting.lanIndex;
                            }),
                            Navigator.of(context).pushAndRemoveUntil(
                                new MaterialPageRoute(
                                    builder: (context) => NavigationHomeScreen(
                                          drawerIndex: DrawerIndex.Setting,
                                        )),
                                (route) => route == null)
                          });
                },
              ),
              SettingsTile(
                title: lanIndex == 0 ? '环境' : 'Environment',
                subtitle: lanIndex == 0 ? '白昼' : 'Day',
                leading: Icon(Icons.cloud_queue),
                onTap: () => print('e'),
              ),
            ],
          ),
          SettingsSection(
            title: lanIndex == 0 ? '账户' : 'Account',
            tiles: [
              SettingsTile(
                  title: lanIndex == 0 ? '电话' : 'Telephone',
                  leading: Icon(Icons.phone)),
              SettingsTile(
                  title: lanIndex == 0 ? '邮箱' : 'Email',
                  leading: Icon(Icons.email)),
              SettingsTile(
                  title: lanIndex == 0 ? '退出登录' : 'Logout',
                  leading: Icon(Icons.exit_to_app)),
            ],
          ),
          SettingsSection(
            title: lanIndex == 0 ? '安全' : 'Security',
            tiles: [
              SettingsTile.switchTile(
                title: lanIndex == 0
                    ? '允许后台运行'
                    : 'Allow running in the background',
                leading: Icon(Icons.phonelink_lock),
                switchValue: lockInBackground,
                onToggle: (bool value) {
                  setState(() {
                    lockInBackground = value;
                    notificationsEnabled = value;
                  });
                },
              ),
              SettingsTile.switchTile(
                  title: lanIndex == 0 ? '使用指纹' : 'Using Fingerprints',
                  leading: Icon(Icons.fingerprint),
                  onToggle: (bool value) {},
                  switchValue: false),
              SettingsTile.switchTile(
                title: lanIndex == 0 ? '修改密码' : 'Change Password',
                leading: Icon(Icons.lock),
                switchValue: true,
                onToggle: (bool value) {},
              ),
              SettingsTile.switchTile(
                title: lanIndex == 0 ? '允许通知' : 'Allow Notification',
                enabled: notificationsEnabled,
                leading: Icon(Icons.notifications_active),
                switchValue: true,
                onToggle: (value) {},
              ),
            ],
          ),
          SettingsSection(
            title: lanIndex == 0 ? '其他' : 'Others',
            tiles: [
              SettingsTile(
                  title: lanIndex == 0 ? '服务项' : 'Services',
                  leading: Icon(Icons.description)),
              SettingsTile(
                  title: 'Open source licenses',
                  leading: Icon(Icons.collections_bookmark)),
            ],
          ),
          CustomSection(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 22, bottom: 8),
                  child: Image.asset(
                    'assets/settings.png',
                    height: 50,
                    width: 50,
                    color: Color(0xFF777777),
                  ),
                ),
                Text(
                  lanIndex == 0 ? '版本号：2.4.0 （287）' : 'Version: 2.4.0 (287)',
                  style: TextStyle(color: Color(0xFF777777)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
