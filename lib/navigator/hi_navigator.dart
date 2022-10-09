import 'package:flutter/material.dart';
import 'package:flutter_bili_app/navigator/bottom_navigator.dart';
import 'package:flutter_bili_app/page/dark_mode_page.dart';
import 'package:flutter_bili_app/page/login_page.dart';
import 'package:flutter_bili_app/page/registration_page.dart';
import 'package:flutter_bili_app/page/video_detail_page.dart';
import 'package:url_launcher/url_launcher.dart';

typedef RouteChangeListener = Function(
    RouteStatusInfo? current, RouteStatusInfo? pre);

/// 构建页面
pageWrap(Widget child) {
  return MaterialPage(key: ValueKey(child.hashCode), child: child);
}

///获取routeStatus在页面栈中的位置
int getPageIndex(List<MaterialPage> pages, RouteStatus routeStatus) {
  for (int i = 0; i < pages.length; i++) {
    MaterialPage page = pages[i];
    if (getStatus(page) == routeStatus) {
      return i;
    }
  }
  return -1;
}

/// 自定义路由封装，路由状态
enum RouteStatus { login, registration, home, detail, unknown, darkMode }

/// 获取page对应的RouteStatus
RouteStatus getStatus(MaterialPage page) {
  if (page.child is LoginPage) {
    return RouteStatus.login;
  } else if (page.child is RegistrationPage) {
    return RouteStatus.registration;
  } else if (page.child is BottomNavigator) {
    return RouteStatus.home;
  } else if (page.child is DarkModePage) {
    return RouteStatus.darkMode;
  } else if (page.child is VideoDetailPage) {
    return RouteStatus.detail;
  } else {
    return RouteStatus.unknown;
  }
}

/// 路由信息
class RouteStatusInfo {
  final RouteStatus routeStatus;
  final Widget page;

  RouteStatusInfo(this.routeStatus, this.page);
}

/// 监听路由页面跳转
/// 感知当前页面是否压后台

class HiNavigator extends _RouteJumpListener {
  static HiNavigator? _instance;

  RouteJumpListener? _routeJump;
  final List<RouteChangeListener> _listeners = [];
  RouteStatusInfo? _current;
  // 首页底部tab
  RouteStatusInfo? _bottomTab;

  HiNavigator._();

  static HiNavigator getInstance() {
    _instance ??= HiNavigator._();
    return _instance!;
  }

  RouteStatusInfo getCurrent() {
    return _current!;
  }

  Future<bool> openH5(String url) async {
    var result = await canLaunchUrl(Uri.parse(url));
    if (result) {
      return await launchUrl(Uri.parse(url));
    } else {
      return Future.value(false);
    }
  }

  // 首页底部tab切换监听
  void onBottomTabChange(int index, Widget page) {
    _bottomTab = RouteStatusInfo(RouteStatus.home, page);
    _notify(_bottomTab!);
  }

  // 注册路由跳转逻辑
  void registerRouteJump(RouteJumpListener routeJumpListener) {
    _routeJump = routeJumpListener;
  }

  /// 监听路由页面跳转
  void addListener(RouteChangeListener listener) {
    if (!_listeners.contains(listener)) {
      _listeners.add(listener);
    }
  }

  /// 通知路由页面变化
  void notify(List<MaterialPage> currentPages, List<MaterialPage> prePages) {
    if (currentPages == prePages) return;
    var current =
        RouteStatusInfo(getStatus(currentPages.last), currentPages.last.child);
    _notify(current);
  }

  /// 移除监听
  void removeListener(RouteChangeListener listener) {
    _listeners.remove(listener);
  }

  @override
  void onJumpTo(RouteStatus routeStatus, {Map? args}) {
    _routeJump!.onJumpTo!(routeStatus, args: args);
  }

  void _notify(RouteStatusInfo current) {
    if (_current?.page is BottomNavigator && _bottomTab != null) {
      // 如果打开的是首页，则明确到首页具体的tab
      current = _bottomTab!;
    }
    print('hi_navigator: current:${current.page}');
    print('hi_navigator: pre:${_current?.page}');
    _listeners.forEach((listener) {
      listener(current, _current!);
    });
    _current = current;
  }
}

/// 抽象类供 HiNavigator 实现
abstract class _RouteJumpListener {
  void onJumpTo(RouteStatus routeStatus, {Map args});
}

typedef OnJumpTo = void Function(RouteStatus routeStatus, {Map? args});

/// 定义路由跳转逻辑要实现的功能
class RouteJumpListener {
  final OnJumpTo? onJumpTo;

  RouteJumpListener({this.onJumpTo});
}
