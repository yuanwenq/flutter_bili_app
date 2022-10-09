import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bili_app/db/hi_cache.dart';
import 'package:flutter_bili_app/util/color.dart';
import 'package:flutter_bili_app/util/hi_constants.dart';

extension ThemeModelExtension on ThemeMode {
  String get value => <String>['System', 'Light', 'Dark'][index];
}

class ThemeProvider extends ChangeNotifier {
  ThemeMode? _themeMode;
  var _platformBrightness = SchedulerBinding.instance.window.platformBrightness;

  /// 系统Dark Mode 发生变化
  void darkModeChange() {
    if (_platformBrightness !=
        SchedulerBinding.instance.window.platformBrightness) {
      _platformBrightness = SchedulerBinding.instance.window.platformBrightness;
      notifyListeners();
    }
  }

  /// 判断是否 Dark Mode
  bool isDark() {
    if (_themeMode == ThemeMode.system) {
      // 获取系统的Dark Mode
      return SchedulerBinding.instance.window.platformBrightness ==
          Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }

  // 获取主题模式
  ThemeMode getThemeMode() {
    String? theme = HiCache.getInstance().get(HiConstants.theme);
    switch (theme) {
      case 'Dark':
        _themeMode = ThemeMode.dark;
        break;
      case 'System':
        _themeMode = ThemeMode.system;
        break;
      default:
        _themeMode = ThemeMode.light;
        break;
    }
    return _themeMode!;
  }

  // 设置主题
  void setTheme(ThemeMode themeMode) {
    HiCache.getInstance().setString(HiConstants.theme, themeMode.value);
    notifyListeners();
  }

  // 获取主题
  ThemeData getTheme({bool isDarkMode = false}) {
    var themeData = ThemeData(
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        errorColor: isDarkMode ? HiColor.dark_red : HiColor.red,
        primaryColor: isDarkMode ? HiColor.dark_bg : white,
        appBarTheme: AppBarTheme(
            titleTextStyle: isDarkMode
                ? TextStyle(color: white)
                : TextStyle(color: HiColor.dark_bg),
            iconTheme:
                IconThemeData(color: isDarkMode ? white : HiColor.dark_bg)),
        // Tab指示器的颜色
        indicatorColor: isDarkMode ? primary[50] : white,
        // 页面背景色
        scaffoldBackgroundColor: isDarkMode ? HiColor.dark_bg : white,
        colorScheme: ColorScheme(
          brightness: isDarkMode ? Brightness.dark : Brightness.light,
          primary: isDarkMode ? HiColor.dark_bg : white,
          onPrimary: isDarkMode ? HiColor.dark_bg : white,
          secondary: isDarkMode ? HiColor.dark_bg : white,
          onSecondary: isDarkMode ? HiColor.dark_bg : white,
          error: isDarkMode ? HiColor.dark_bg : white,
          onError: isDarkMode ? HiColor.dark_bg : white,
          background: isDarkMode ? HiColor.dark_bg : white,
          onBackground: isDarkMode ? HiColor.dark_bg : white,
          surface: isDarkMode ? HiColor.dark_bg : white,
          onSurface: isDarkMode ? HiColor.dark_bg : white,
        ));
    return themeData;
  }
}
