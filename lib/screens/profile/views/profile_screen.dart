import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shop/components/list_tile/divider_list_tile.dart';
import 'package:shop/components/network_image_with_loader.dart';
import 'package:shop/constants.dart';
import 'package:shop/route/screen_export.dart';
import 'package:shop/utils/storage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'components/profile_card.dart';
import 'components/profile_menu_item_list_tile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _userInfo;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final userInfo = await Storage.getUserInfo();
    if (mounted) {
      setState(() {
        _userInfo = userInfo;
      });
    }
  }

  Future<void> _handleLogout() async {
    final l10n = AppLocalizations.of(context)!;
    // 清除存储的用户信息和token
    await Storage.clear();
    if (!mounted) return;

    // 显示退出成功提示
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.logoutSuccess)),
    );

    // 跳转到登录页
    Navigator.pushNamedAndRemoveUntil(
      context,
      loginScreenRoute,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: ListView(
        children: [
          if (_userInfo != null)
            ProfileCard(
              name: _userInfo!['username'] ?? '',
              email: _userInfo!['email'] ?? '',
              imageSrc:
                  _userInfo!['avatar'] ?? 'https://i.imgur.com/IXnwbLk.png',
              press: () {
                Navigator.pushNamed(context, userInfoScreenRoute);
              },
            ),

          if (_userInfo != null)
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: defaultPadding, vertical: defaultPadding * 1.5),
              child: Row(
                children: [
                  Expanded(
                    child: _buildBalanceCard(
                      title: l10n.balance,
                      amount:
                          '\$${_userInfo!['balance']?.toStringAsFixed(2) ?? '0.00'}',
                      icon: 'assets/icons/Wallet.svg',
                    ),
                  ),
                  const SizedBox(width: defaultPadding),
                  Expanded(
                    child: _buildBalanceCard(
                      title: 'USDT',
                      amount: _userInfo!['usdtAmount']?.toStringAsFixed(2) ??
                          '0.00',
                      icon: 'assets/icons/crypto.svg',
                    ),
                  ),
                ],
              ),
            ),

          // Account Section
          _buildSectionTitle(context, l10n.account),
          const SizedBox(height: defaultPadding / 2),
          ProfileMenuListTile(
            text: l10n.orders,
            svgSrc: "assets/icons/Order.svg",
            press: () => Navigator.pushNamed(context, ordersScreenRoute),
          ),
          ProfileMenuListTile(
            text: "Returns",
            svgSrc: "assets/icons/Return.svg",
            press: () {},
          ),
          ProfileMenuListTile(
            text: "Wishlist",
            svgSrc: "assets/icons/Wishlist.svg",
            press: () {},
          ),
          ProfileMenuListTile(
            text: "Addresses",
            svgSrc: "assets/icons/Address.svg",
            press: () {
              Navigator.pushNamed(context, addressesScreenRoute);
            },
          ),
          ProfileMenuListTile(
            text: "Payment",
            svgSrc: "assets/icons/card.svg",
            press: () {
              Navigator.pushNamed(context, emptyPaymentScreenRoute);
            },
          ),
          ProfileMenuListTile(
            text: "Wallet",
            svgSrc: "assets/icons/Wallet.svg",
            press: () {
              Navigator.pushNamed(context, walletScreenRoute);
            },
          ),
          const SizedBox(height: defaultPadding),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding, vertical: defaultPadding / 2),
            child: Text(
              "Personalization",
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          DividerListTileWithTrilingText(
            svgSrc: "assets/icons/Notification.svg",
            title: "Notification",
            trilingText: "Off",
            press: () {
              Navigator.pushNamed(context, enableNotificationScreenRoute);
            },
          ),
          ProfileMenuListTile(
            text: "Preferences",
            svgSrc: "assets/icons/Preferences.svg",
            press: () {
              Navigator.pushNamed(context, preferencesScreenRoute);
            },
          ),
          const SizedBox(height: defaultPadding),

          // Settings Section
          _buildSectionTitle(context, l10n.settings),
          ProfileMenuListTile(
            text: l10n.language,
            svgSrc: "assets/icons/Language.svg",
            press: () =>
                Navigator.pushNamed(context, selectLanguageScreenRoute),
          ),
          ProfileMenuListTile(
            text: "Location",
            svgSrc: "assets/icons/Location.svg",
            press: () {},
          ),
          const SizedBox(height: defaultPadding),

          // Help & Support Section
          _buildSectionTitle(context, l10n.helpAndSupport),
          ProfileMenuListTile(
            text: l10n.getHelp,
            svgSrc: "assets/icons/Help.svg",
            press: () => Navigator.pushNamed(context, getHelpScreenRoute),
          ),
          ProfileMenuListTile(
            text: l10n.faq,
            svgSrc: "assets/icons/FAQ.svg",
            press: () {},
            isShowDivider: false,
          ),
          const SizedBox(height: defaultPadding),

          // Log Out
          ListTile(
            onTap: _handleLogout,
            minLeadingWidth: 24,
            leading: SvgPicture.asset(
              "assets/icons/Logout.svg",
              height: 24,
              width: 24,
              colorFilter: const ColorFilter.mode(
                errorColor,
                BlendMode.srcIn,
              ),
            ),
            title: Text(
              l10n.logout,
              style:
                  const TextStyle(color: errorColor, fontSize: 14, height: 1),
            ),
          ),
          const SizedBox(height: defaultPadding),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: defaultPadding, vertical: defaultPadding / 2),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall,
      ),
    );
  }

  Widget _buildBalanceCard({
    required String title,
    required String amount,
    required String icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(defaultBorderRadious),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 4),
            blurRadius: 8,
            color: Colors.black.withOpacity(0.04),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                icon,
                height: 16,
                width: 16,
                colorFilter: ColorFilter.mode(
                  Theme.of(context).iconTheme.color!,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
