import 'package:azkar/provider/language_provider.dart';
import 'package:azkar/screens/setting/change_language.dart';
import 'package:azkar/screens/setting/font_setting.dart';
import 'package:azkar/screens/setting/notification_setting.dart';
import 'package:azkar/widgets/arabic_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context); // Access

    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "assets/bg.png",
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset("assets/logo.png", height: 150),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (builder) => NotificationSetting(),
                      ),
                    );
                  },
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
                  title: ArabicText(
                    languageProvider.localizedStrings["Notifications"] ??
                        "Notifications",
                    style: TextStyle(color: Colors.white),
                  ),
                  leading: Icon(Icons.notifications, color: Colors.white),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (builder) => ChangeLangage()),
                    );
                  },
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
                  title: ArabicText(
                    languageProvider.localizedStrings["Change Language"] ??
                        "Change Language",
                    style: TextStyle(color: Colors.white),
                  ),
                  leading: Icon(Icons.language, color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (builder) => FontSettingsScreen(),
                      ),
                    );
                  },
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
                  title: ArabicText(
                    languageProvider.localizedStrings["Font Setting"] ??
                        "Font Setting",
                    style: TextStyle(color: Colors.white),
                  ),
                  leading: Icon(Icons.font_download, color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
                child: ListTile(
                  onTap: () {
                    shareApp();
                  },
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
                  title: ArabicText(
                    languageProvider.localizedStrings["Invite Friends"] ??
                        "Invite Friends",
                    style: TextStyle(color: Colors.white),
                  ),
                  leading: Icon(Icons.share, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void shareApp() {
    String appLink =
        "https://play.google.com/store/apps/details?id=com.example.yourapp";
    Share.share("Hey, check out this amazing app: $appLink");
  }
}
