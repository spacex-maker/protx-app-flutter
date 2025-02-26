import 'package:flutter/material.dart';
import 'package:shop/constants.dart';
import 'package:shop/route/route_constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../../providers/locale_provider.dart';
import '../../../l10n/l10n.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/gestures.dart';
import 'dart:ui';
import 'package:http/http.dart' as http;

import 'components/login_form.dart';
import '../../../screens/auth/views/password_recovery_screen.dart';
import '../../../utils/http_client.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController(text: 'TestAdmin'); // 默认用户名
  final _passwordController = TextEditingController(text: '123456'); // 默认密码
  bool _isObscure = true;
  bool _rememberMe = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // 添加 baseUrl 控制器
  final _baseUrlController =
      TextEditingController(text: 'http://10.0.2.2:8080/');

  // 定义输入框边框样式
  final outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(defaultBorderRadious),
    borderSide: const BorderSide(color: Colors.black12),
  );

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _animationController.forward();

    // 初始化时设置当前的 baseUrl
    _baseUrlController.text = HttpClient.getBaseUrl();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _baseUrlController.dispose(); // 添加释放
    super.dispose();
  }

  // 添加显示设置对话框的方法
  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.settings),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _baseUrlController,
              decoration: InputDecoration(
                labelText: 'API Base URL',
                hintText: 'http://10.0.2.2:8080/',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(defaultBorderRadious),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () async {
              // 使用新方法设置 baseUrl
              await HttpClient.setBaseUrl(_baseUrlController.text);
              if (mounted) Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.confirm),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = Provider.of<LocaleProvider>(context).locale;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          // 添加设置按钮
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.white.withOpacity(0.9),
            ),
            onPressed: _showSettingsDialog,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0, top: 8.0),
            child: PopupMenuButton<Locale>(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 120,
                maxWidth: 200,
              ),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        '${L10n.getFlag(currentLocale.languageCode)} ${L10n.getLanguageName(currentLocale.languageCode)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: const BorderRadius.horizontal(
                          right: Radius.circular(20),
                        ),
                      ),
                      child: const Icon(
                        Icons.language_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              position: PopupMenuPosition.under,
              elevation: 3,
              color: Colors.white.withOpacity(0.95),
              itemBuilder: (context) => L10n.all.map((locale) {
                final flag = L10n.getFlag(locale.languageCode);
                final name = L10n.getLanguageName(locale.languageCode);
                return PopupMenuItem(
                  value: locale,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(flag),
                        const SizedBox(width: 12),
                        Text(
                          name,
                          style: TextStyle(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              onSelected: (locale) {
                final provider =
                    Provider.of<LocaleProvider>(context, listen: false);
                provider.setLocale(locale);
              },
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.primaryColor.withOpacity(0.8),
              const Color(0xFF6C63FF),
              const Color(0xFF3B3363),
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // 主要内容列
                            Column(
                              children: [
                                const SizedBox(height: 20),

                                // Logo
                                Icon(
                                  Icons.shopping_bag_outlined,
                                  size: 40,
                                  color: Colors.white.withOpacity(0.9),
                                ),

                                const SizedBox(height: 20),

                                // 欢迎文本
                                Text(
                                  l10n.welcomeBack,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),

                                const SizedBox(height: 4),
                                Text(
                                  l10n.discover,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.85),
                                  ),
                                ),

                                const SizedBox(height: 24),

                                // 使用 LogInForm 组件
                                LogInForm(
                                  formKey: _formKey,
                                  onLoginSuccess: () {
                                    // 这里不需要做任何事情，因为跳转已经在 LogInForm 中处理了
                                  },
                                ),

                                const SizedBox(height: 24),

                                // 社交媒体登录分隔线
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 24),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 1,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.white.withOpacity(0.01),
                                                Colors.white.withOpacity(0.25),
                                                Colors.white.withOpacity(0.25),
                                                Colors.white.withOpacity(0.01),
                                              ],
                                              stops: const [0.0, 0.3, 0.7, 1.0],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: Text(
                                          l10n.orSignInWith,
                                          style: TextStyle(
                                            color:
                                                Colors.white.withOpacity(0.7),
                                            fontSize: 14,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 1,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.white.withOpacity(0.01),
                                                Colors.white.withOpacity(0.25),
                                                Colors.white.withOpacity(0.25),
                                                Colors.white.withOpacity(0.01),
                                              ],
                                              stops: const [0.0, 0.3, 0.7, 1.0],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // 社交媒体登录按钮
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildSocialButton(
                                      icon: FontAwesomeIcons.google,
                                      onTap: () {},
                                    ),
                                    const SizedBox(width: 20),
                                    _buildSocialButton(
                                      icon: FontAwesomeIcons.facebook,
                                      onTap: () {},
                                    ),
                                    const SizedBox(width: 20),
                                    _buildSocialButton(
                                      icon: FontAwesomeIcons.apple,
                                      onTap: () {},
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            // 底部注册提示
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 24),
                              child: RichText(
                                text: TextSpan(
                                  text: l10n.newToApp,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 14,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: ' ${l10n.joinNow}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.pushNamed(
                                              context, signUpScreenRoute);
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.15),
            Colors.white.withOpacity(0.05),
          ],
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: FaIcon(
              icon,
              color: Colors.white.withOpacity(0.9),
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
