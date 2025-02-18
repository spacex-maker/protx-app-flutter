import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop/constants.dart';
import 'package:shop/route/screen_export.dart';

/// 应用程序的主入口点组件
/// 管理底部导航栏和页面切换
class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
  // 所有主要页面的列表
  final List _pages = const [
    HomeScreen(), // 首页
    DiscoverScreen(), // 发现页
    BookmarkScreen(), // 收藏页
    ChatScreen(), // 聊天页
    ProfileScreen(), // 个人中心页
  ];

  // 当前选中的页面索引
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // 用于创建底部导航栏图标的辅助函数
    SvgPicture svgIcon(String src, {Color? color}) {
      return SvgPicture.asset(
        src,
        height: 24,
        colorFilter: ColorFilter.mode(
            color ??
                Theme.of(context).iconTheme.color!.withOpacity(
                    Theme.of(context).brightness == Brightness.dark ? 0.3 : 1),
            BlendMode.srcIn),
      );
    }

    return Scaffold(
      // 主体内容区域
      body: PageTransitionSwitcher(
        duration: defaultDuration,
        // 使用 FadeThroughTransition 实现页面切换动画
        transitionBuilder: (child, animation, secondAnimation) {
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondAnimation,
            child: child,
          );
        },
        child: _pages[_currentIndex],
      ),

      // 底部导航栏
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(top: defaultPadding / 2),
        // 根据主题设置底部导航栏背景色
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : const Color(0xFF101015),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          // 处理底部导航栏项目点击
          onTap: (index) {
            if (index != _currentIndex) {
              setState(() {
                _currentIndex = index;
              });
            }
          },
          // 设置底部导航栏样式
          backgroundColor: Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : const Color(0xFF101015),
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 12,
          selectedItemColor: primaryColor,
          unselectedItemColor: Colors.transparent,
          items: [
            // 首页导航项
            BottomNavigationBarItem(
              icon: svgIcon("assets/icons/Shop.svg"),
              activeIcon: svgIcon("assets/icons/Shop.svg", color: primaryColor),
              label: "Shop",
            ),
            // 发现页导航项
            BottomNavigationBarItem(
              icon: svgIcon("assets/icons/Category.svg"),
              activeIcon:
                  svgIcon("assets/icons/Category.svg", color: primaryColor),
              label: "Discover",
            ),
            // 收藏页导航项
            BottomNavigationBarItem(
              icon: svgIcon("assets/icons/Bookmark.svg"),
              activeIcon:
                  svgIcon("assets/icons/Bookmark.svg", color: primaryColor),
              label: "Bookmark",
            ),
            // 购物车导航项
            BottomNavigationBarItem(
              icon: svgIcon("assets/icons/Bag.svg"),
              activeIcon: svgIcon("assets/icons/Bag.svg", color: primaryColor),
              label: "Cart",
            ),
            // 个人中心导航项
            BottomNavigationBarItem(
              icon: svgIcon("assets/icons/Profile.svg"),
              activeIcon:
                  svgIcon("assets/icons/Profile.svg", color: primaryColor),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
