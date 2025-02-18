import 'package:flutter/material.dart';
import 'package:shop/constants.dart';
import 'package:shop/utils/storage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shop/components/network_image_with_loader.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: _userInfo == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                // 背景图
                Positioned.fill(
                  child: NetworkImageWithLoader(
                    _userInfo!['avatar'] ?? 'https://i.imgur.com/IXnwbLk.png',
                    fit: BoxFit.cover,
                  ),
                ),
                // 背景模糊
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                    child: Container(
                      color: theme.scaffoldBackgroundColor.withOpacity(0.7),
                    ),
                  ),
                ),
                // 主要内容
                CustomScrollView(
                  slivers: [
                    // 头像和用户基本信息
                    SliverToBoxAdapter(
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                            defaultPadding,
                            defaultPadding * 1.5,
                            defaultPadding,
                            defaultPadding,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: theme.scaffoldBackgroundColor,
                                  border: Border.all(
                                    color: theme.colorScheme.primary,
                                    width: 1.5,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 36,
                                  backgroundImage: NetworkImage(
                                    _userInfo!['avatar'] ??
                                        'https://i.imgur.com/IXnwbLk.png',
                                  ),
                                ),
                              ),
                              const SizedBox(width: defaultPadding * 0.75),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _getUserDisplayName(),
                                      style:
                                          theme.textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    if (_userInfo!['username'] != null) ...[
                                      const SizedBox(height: 2),
                                      Text(
                                        '@${_userInfo!['username']}',
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                          color:
                                              theme.textTheme.bodySmall?.color,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                    if (_userInfo!['email']?.isNotEmpty ==
                                        true) ...[
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.email_outlined,
                                            size: 14,
                                            color: theme
                                                .textTheme.bodySmall?.color,
                                          ),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              _userInfo!['email']!,
                                              style: theme.textTheme.bodyMedium
                                                  ?.copyWith(
                                                color: theme
                                                    .textTheme.bodySmall?.color,
                                                fontSize: 13,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                    if (_userInfo!['phoneNumber']?.isNotEmpty ==
                                        true) ...[
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.phone_outlined,
                                            size: 14,
                                            color: theme
                                                .textTheme.bodySmall?.color,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            _userInfo!['phoneNumber']!,
                                            style: theme.textTheme.bodyMedium
                                                ?.copyWith(
                                              color: theme
                                                  .textTheme.bodySmall?.color,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // 个人简介（如果有）
                    if (_userInfo!['description']?.isNotEmpty == true)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                            defaultPadding,
                            0,
                            defaultPadding,
                            defaultPadding,
                          ),
                          child: Text(
                            _userInfo!['description']!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 14,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ),

                    // 用户统计
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          defaultPadding,
                          0,
                          defaultPadding,
                          defaultPadding,
                        ),
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(defaultBorderRadious),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: defaultPadding * 0.7,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.white.withOpacity(0.1)
                                    : Colors.black.withOpacity(0.05),
                                borderRadius:
                                    BorderRadius.circular(defaultBorderRadious),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildStatItem(
                                    'LV${_userInfo!['level']?.toString() ?? '1'}',
                                    '等级',
                                    'assets/icons/level.svg',
                                  ),
                                  _buildVerticalDivider(),
                                  _buildStatItem(
                                    _userInfo!['creditScore']?.toString() ??
                                        '0',
                                    '信用分',
                                    'assets/icons/credit.svg',
                                  ),
                                  _buildVerticalDivider(),
                                  _buildStatItem(
                                    _userInfo!['orderCount']?.toString() ?? '0',
                                    '订单',
                                    'assets/icons/Order.svg',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // 其他信息卡片（地址信息等）
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          if (_userInfo!['usdtAddress']?.isNotEmpty == true)
                            _buildInfoSection(
                              'USDT信息',
                              [
                                _buildInfoTile(
                                    'USDT地址', _userInfo!['usdtAddress']!,
                                    icon:
                                        Icons.account_balance_wallet_outlined),
                              ],
                            ),
                          if (_hasAddressInfo()) ...[
                            const SizedBox(height: defaultPadding / 2),
                            _buildInfoSection(
                              '地址信息',
                              [
                                _buildInfoTile(
                                    l10n.address, _userInfo!['address'] ?? '',
                                    icon: Icons.home_outlined),
                                _buildInfoTile(
                                    l10n.city, _userInfo!['city'] ?? '',
                                    icon: Icons.location_city_outlined),
                                _buildInfoTile(
                                    l10n.state, _userInfo!['state'] ?? '',
                                    icon: Icons.map_outlined),
                                _buildInfoTile(l10n.postalCode,
                                    _userInfo!['postalCode'] ?? '',
                                    icon: Icons.local_post_office_outlined),
                                _buildInfoTile(
                                    l10n.country, _userInfo!['country'] ?? '',
                                    icon: Icons.public_outlined),
                              ],
                            ),
                          ],
                        ]),
                      ),
                    ),
                  ],
                ),
                // 返回按钮
                Positioned(
                  top: MediaQuery.of(context).padding.top,
                  left: defaultPadding,
                  child: IconButton.filledTonal(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ClipRRect(
      borderRadius: BorderRadius.circular(defaultBorderRadious),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withOpacity(0.1)
                : Colors.black.withOpacity(0.05),
            borderRadius: BorderRadius.circular(defaultBorderRadious),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              ...children,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 24,
      width: 1,
      color: Theme.of(context).dividerColor.withOpacity(0.2),
    );
  }

  Widget _buildStatItem(String value, String label, String iconPath) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          iconPath,
          height: 18,
          width: 18,
          colorFilter: ColorFilter.mode(
            Theme.of(context).iconTheme.color!,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 12,
              ),
        ),
      ],
    );
  }

  Widget _buildInfoTile(String label, String value, {required IconData icon}) {
    if (value.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: defaultPadding,
        vertical: defaultPadding / 3,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: Theme.of(context).iconTheme.color?.withOpacity(0.7),
          ),
          const SizedBox(width: defaultPadding / 2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _hasAddressInfo() {
    return [
      _userInfo!['address'],
      _userInfo!['city'],
      _userInfo!['state'],
      _userInfo!['postalCode'],
      _userInfo!['country'],
    ].any((value) => value?.isNotEmpty == true);
  }

  // 添加获取显示名称的方法
  String _getUserDisplayName() {
    if (_userInfo!['nickname']?.isNotEmpty == true) {
      return _userInfo!['nickname']!;
    }
    if (_userInfo!['username']?.isNotEmpty == true) {
      return _userInfo!['username']!;
    }
    return '未设置昵称'; // 默认显示文本
  }
}
