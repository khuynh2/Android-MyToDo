import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class AnalyticController extends ControllerMVC {
  static FirebaseAnalytics analytics = FirebaseAnalytics();

  static FirebaseAnalyticsObserver analyticsObserver =
      FirebaseAnalyticsObserver(analytics: analytics);

  Future setUserProperties(
      {@required String userId, String userRole, String username}) async {
    await analytics.setUserId(userId);
    await analytics.setUserProperty(name: 'user_role', value: userRole);
    await analytics.setUserProperty(name: 'username', value: username);
  }

  Future logLogin() async {
    await analytics.logLogin(loginMethod: 'email');
  }

  Future logToDo(String title, String date) async {
    await analytics.logEvent(name: 'add_todo', parameters: <String, dynamic>{
      'Title': title,
      'Duedate': date,
    });
  }

  Future logDaily(String title) async {
    await analytics.logEvent(name: 'add_daily', parameters: <String, dynamic>{
      'Title': title,
    });
  }

  Future logCompleteToDo(String title) async {
    await analytics
        .logEvent(name: 'complete_todo', parameters: <String, dynamic>{
      'Title': title,
    });
  }

  Future logSettings(bool changed) async {
    await analytics
        .logEvent(name: 'change_settings', parameters: <String, dynamic>{
      'change_image': changed,
    });
  }
}
