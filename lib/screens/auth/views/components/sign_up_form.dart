import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../utils/http_client.dart';
import '../../../../route/route_constants.dart';

import '../../../../constants.dart';

/// 注册表单组件
/// 处理用户注册相关的表单输入和验证
class SignUpForm extends StatefulWidget {
  const SignUpForm({
    super.key,
    required this.formKey,
  });

  /// 表单 Key,用于表单验证
  final GlobalKey<FormState> formKey;

  @override
  State<SignUpForm> createState() => SignUpFormState();
}

class SignUpFormState extends State<SignUpForm> {
  /// 用户名输入控制器
  final _usernameController = TextEditingController();

  /// 密码输入控制器
  final _passwordController = TextEditingController();

  /// 邮箱输入控制器
  final _emailController = TextEditingController();

  /// 是否正在处理注册请求
  bool _isLoading = false;

  /// 处理注册逻辑
  /// 验证表单数据并调用注册 API
  Future<void> handleSignUp() async {
    final l10n = AppLocalizations.of(context)!;

    // 验证表单
    if (widget.formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        // 调用注册 API
        final response = await HttpClient.post(
          '/user/register',
          data: {
            'username': _usernameController.text,
            'password': _passwordController.text,
            'email': _emailController.text,
          },
        );

        if (response.statusCode == 200) {
          if (!mounted) return;

          // 显示注册成功提示
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.registerSuccess),
              backgroundColor: Colors.green,
            ),
          );

          // 注册成功后延迟1秒再跳转，让用户看到成功提示
          await Future.delayed(const Duration(seconds: 1));
          if (!mounted) return;
          Navigator.pushReplacementNamed(context, loginScreenRoute);
        }
      } catch (e) {
        if (!mounted) return;

        String errorMessage = l10n.registerFailed;

        if (e is DioException) {
          switch (e.type) {
            case DioExceptionType.connectionTimeout:
            case DioExceptionType.sendTimeout:
            case DioExceptionType.receiveTimeout:
              errorMessage = '网络连接超时，请检查网络后重试';
              break;
            case DioExceptionType.connectionError:
              errorMessage = '网络连接失败，请检查网络设置';
              break;
            default:
              if (e.response != null) {
                // 处理服务器返回的错误信息
                switch (e.response?.statusCode) {
                  case 400:
                    // 处理业务逻辑错误
                    final data = e.response?.data;
                    if (data != null && data['message'] != null) {
                      errorMessage = data['message'];
                    } else {
                      errorMessage = '请求参数错误';
                    }
                    break;
                  case 409:
                    errorMessage = '用户名已存在';
                    break;
                  case 500:
                    errorMessage = '服务器错误，请稍后重试';
                    break;
                  default:
                    errorMessage = '注册失败，请稍后重试';
                }
              }
          }
        }

        // 显示错误提示
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: '确定',
              textColor: Colors.white,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  void dispose() {
    // 释放控制器资源
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          // 用户名输入框
          TextFormField(
            controller: _usernameController,
            textInputAction: TextInputAction.next,
            enabled: !_isLoading,
            decoration: InputDecoration(
              hintText: l10n.username,
              prefixIcon: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: defaultPadding * 0.75),
                child: SvgPicture.asset(
                  "assets/icons/User.svg",
                  height: 24,
                  width: 24,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .color!
                        .withOpacity(0.3),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.usernameRequired;
              }
              if (value.length < 4) {
                return l10n.usernameTooShort;
              }
              if (value.length > 10) {
                return l10n.usernameTooLong;
              }
              return null;
            },
          ),

          const SizedBox(height: defaultPadding),

          // 邮箱输入框
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            enabled: !_isLoading,
            decoration: InputDecoration(
              hintText: l10n.email,
              prefixIcon: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: defaultPadding * 0.75),
                child: SvgPicture.asset(
                  "assets/icons/Message.svg",
                  height: 24,
                  width: 24,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .color!
                        .withOpacity(0.3),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.emailRequired;
              }
              // 邮箱格式验证
              final emailRegExp =
                  RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
              if (!emailRegExp.hasMatch(value)) {
                return l10n.emailInvalid;
              }
              return null;
            },
          ),

          const SizedBox(height: defaultPadding),

          // 密码输入框
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            enabled: !_isLoading,
            decoration: InputDecoration(
              hintText: l10n.password,
              prefixIcon: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: defaultPadding * 0.75),
                child: SvgPicture.asset(
                  "assets/icons/Lock.svg",
                  height: 24,
                  width: 24,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .color!
                        .withOpacity(0.3),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.passwordRequired;
              }
              if (value.length < 6) {
                return l10n.passwordTooShort;
              }
              return null;
            },
          ),

          // 加载状态指示器
          if (_isLoading) ...[
            const SizedBox(height: defaultPadding),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(width: 12),
                  Text(l10n.processingRequest),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
