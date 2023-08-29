import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission_resto/provider/preferences_provider.dart';
import 'package:submission_resto/provider/scheduling_provider.dart';

class SettingsPage extends StatelessWidget {
  static const String settingsTitle = 'Pengaturan';
  static const routeName = '/settings-page';

  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(settingsTitle),
      ),
      body: Consumer<PreferencesProvider>(builder: (context, preference, _) {
        return ListView(
          children: [
            ListTile(
              title: const Text('Daily Resto Notification'),
              trailing: Consumer<SchedulingProvider>(
                builder: (context, schedule, _) {
                  return Switch.adaptive(
                    value: preference.isDailyRestoActive,
                    onChanged: (value) async {
                      if (Platform.isIOS) {
                      } else {
                        schedule.scheduleResto(value);
                        preference.enableDailyResto(value);
                      }
                    },
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
