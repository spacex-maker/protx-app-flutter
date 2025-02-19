import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../constants.dart';
import '../../../../route/route_constants.dart';
import '../../../../utils/http_client.dart';
import '../../../../utils/storage.dart'; // 需要创建这个文件用于存储token

class LogInForm extends StatefulWidget {
  const LogInForm({
    super.key,
    required this.formKey,
    required this.onLoginSuccess,
  });

  final GlobalKey<FormState> formKey;
  final VoidCallback onLoginSuccess;

  @override
  State<LogInForm> createState() => _LogInFormState();
}

class _LogInFormState extends State<LogInForm> {
  final _usernameController = TextEditingController(text: 'TestAdmin');
  final _passwordController = TextEditingController(text: '123456');
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    if (!widget.formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final l10n = AppLocalizations.of(context)!;

    try {
      // 1. 登录获取token
      final loginResponse = await HttpClient.post(
        '/productx/user/login',
        data: {
          'username': _usernameController.text,
          'password': _passwordController.text,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (loginResponse.statusCode == 200 && loginResponse.data['success']) {
        final token = loginResponse.data['data'];
        // 存储token
        await Storage.setToken(token);

        // 2. 获取用户信息
        final userResponse = await HttpClient.get(
          '/productx/user/user-detail',
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        );

        if (userResponse.statusCode == 200 && userResponse.data['success']) {
          // 存储用户信息
          await Storage.setUserInfo(userResponse.data['data']);

          if (!mounted) return;
          // 显示成功消息
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.loginSuccess),
              backgroundColor: Colors.green,
            ),
          );

          // 修改这里：使用正确的路由名称
          Navigator.pushReplacementNamed(
              context, entryPointScreenRoute); // 使用 entryPointScreenRoute

          // 触发登录成功回调
          widget.onLoginSuccess();
        } else {
          throw Exception(
              userResponse.data['message'] ?? 'Failed to get user info');
        }
      } else {
        throw Exception(loginResponse.data['message'] ?? 'Login failed');
      }
    } catch (e) {
      if (!mounted) return;

      String errorMessage = l10n.loginFailed;

      if (e is DioException) {
        switch (e.type) {
          case DioExceptionType.connectionTimeout:
          case DioExceptionType.sendTimeout:
          case DioExceptionType.receiveTimeout:
            errorMessage = l10n.networkTimeout;
            break;
          case DioExceptionType.connectionError:
            errorMessage = l10n.networkError;
            break;
          default:
            if (e.response != null) {
              // 处理401错误
              if (e.response?.statusCode == 401) {
                errorMessage = '用户名或密码错误';
              } else {
                errorMessage = e.response?.data['message'] ?? l10n.loginFailed;
              }
            }
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          // 用户名输入框
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextFormField(
              controller: _usernameController,
              enabled: !_isLoading,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                hintText: l10n.username,
                prefixIcon: Icon(
                  Icons.person_outline,
                  color: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .color!
                      .withOpacity(0.3),
                ),
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.usernameRequired;
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: defaultPadding),

          // 密码输入框
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextFormField(
              controller: _passwordController,
              enabled: !_isLoading,
              obscureText: true,
              decoration: InputDecoration(
                hintText: l10n.password,
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(12),
                  child: SvgPicture.asset(
                    "assets/icons/Lock.svg",
                    height: 24,
                    width: 24,
                    colorFilter: ColorFilter.mode(
                      theme.primaryColor.withOpacity(0.7),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.passwordRequired;
                }
                return null;
              },
            ),
          ),

          // 登录按钮
          Container(
            width: double.infinity,
            height: 56,
            margin: const EdgeInsets.only(top: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  Colors.white.withOpacity(0.9),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: _isLoading ? null : _handleLogin,
                child: Center(
                  child: _isLoading
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              theme.primaryColor,
                            ),
                          ),
                        )
                      : Text(
                          l10n.signIn,
                          style: TextStyle(
                            color: theme.primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
