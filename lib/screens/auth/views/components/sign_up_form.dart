import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../utils/http_client.dart';
import '../../../../route/route_constants.dart';
import 'package:flutter/foundation.dart';

import '../../../../constants.dart';
import 'dart:convert';
import 'dart:ui';

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

  /// 国家列表
  List<Map<String, dynamic>> _countries = [];

  /// 选中的国家代码
  String? _selectedCountryCode;

  /// 是否同意服务条款
  bool _agreedToTerms = false;

  /// 获取选中的国家代码
  String? get selectedCountryCode => _selectedCountryCode;

  /// 添加常量
  static const _minUsernameLength = 4;
  static const _maxUsernameLength = 10;
  static const _minPasswordLength = 6;
  static const _snackBarDuration = Duration(seconds: 3);

  @override
  void initState() {
    super.initState();
    _fetchCountries();
  }

  /// 获取支持的国家列表
  Future<void> _fetchCountries() async {
    try {
      final response = await HttpClient.get('/base/countries/list-all-enable');

      if (response.statusCode == 200) {
        setState(() {
          _countries = List<Map<String, dynamic>>.from(response.data['data']);
          if (_countries.isNotEmpty) {
            _selectedCountryCode = _countries.first['code'];
          }
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.networkError),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// 显示服务条款对话框
  void _showTermsDialog(bool isPrivacyPolicy) {
    if (_selectedCountryCode == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.countryRequired),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    Navigator.pushNamed(
      context,
      isPrivacyPolicy ? privacyPolicyScreenRoute : termsConditionsScreenRoute,
      arguments: _selectedCountryCode,
    );
  }

  /// 处理注册逻辑
  /// 验证表单数据并调用注册 API
  Future<void> handleSignUp() async {
    if (!widget.formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 调用注册 API
      final response = await HttpClient.post(
        '/productx/user/register',
        data: {
          'username': _usernameController.text,
          'password': _passwordController.text,
          'email': _emailController.text,
          'countryCode': _selectedCountryCode,
        },
      );

      if (response.statusCode == 200) {
        if (!mounted) return;

        Navigator.pushNamedAndRemoveUntil(
          context,
          loginScreenRoute,
          (route) => false,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.registerSuccess),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      String errorMessage = AppLocalizations.of(context)!.registerFailed;

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
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// 提取验证器到单独的方法
  String? _validateUsername(String? value, AppLocalizations l10n) {
    if (value == null || value.isEmpty) return l10n.usernameRequired;
    if (value.length < _minUsernameLength) return l10n.usernameTooShort;
    if (value.length > _maxUsernameLength) return l10n.usernameTooLong;
    return null;
  }

  String? _validateEmail(String? value, AppLocalizations l10n) {
    if (value == null || value.isEmpty) return l10n.emailRequired;
    final emailRegExp = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
    if (!emailRegExp.hasMatch(value)) return l10n.emailInvalid;
    return null;
  }

  String? _validatePassword(String? value, AppLocalizations l10n) {
    if (value == null || value.isEmpty) return l10n.passwordRequired;
    if (value.length < _minPasswordLength) return l10n.passwordTooShort;
    return null;
  }

  /// 优化错误处理
  String _handleDioError(DioException e, AppLocalizations l10n) {
    if (e.type.isTimeout) return l10n.networkTimeout;
    if (e.type == DioExceptionType.connectionError) return l10n.networkError;

    final response = e.response;
    if (response != null) {
      switch (response.statusCode) {
        case 400:
          return response.data?['message'] ?? l10n.invalidRequest;
        case 409:
          return l10n.usernameExists;
        case 500:
          return l10n.serverError;
      }
    }
    return l10n.registerFailed;
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
          _buildCountryDropdown(),
          const SizedBox(height: defaultPadding),
          _buildUsernameField(l10n),
          const SizedBox(height: defaultPadding),
          _buildEmailField(l10n),
          const SizedBox(height: defaultPadding),
          _buildPasswordField(l10n),
          if (_isLoading) _buildLoadingIndicator(l10n),
        ],
      ),
    );
  }

  Widget _buildUsernameField(AppLocalizations l10n) {
    return TextFormField(
      controller: _usernameController,
      textInputAction: TextInputAction.next,
      enabled: !_isLoading,
      decoration: InputDecoration(
        hintText: l10n.username,
        prefixIcon: Icon(
          Icons.person_outline,
          color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.3),
        ),
      ),
      validator: (value) => _validateUsername(value, l10n),
    );
  }

  Widget _buildEmailField(AppLocalizations l10n) {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      enabled: !_isLoading,
      decoration: InputDecoration(
        hintText: l10n.email,
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(vertical: defaultPadding * 0.75),
          child: SvgPicture.asset(
            "assets/icons/Message.svg",
            height: 24,
            width: 24,
            colorFilter: ColorFilter.mode(
              Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.3),
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
      validator: (value) => _validateEmail(value, l10n),
    );
  }

  Widget _buildPasswordField(AppLocalizations l10n) {
    return TextFormField(
      controller: _passwordController,
      obscureText: true,
      enabled: !_isLoading,
      decoration: InputDecoration(
        hintText: l10n.password,
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(vertical: defaultPadding * 0.75),
          child: SvgPicture.asset(
            "assets/icons/Lock.svg",
            height: 24,
            width: 24,
            colorFilter: ColorFilter.mode(
              Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.3),
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
      validator: (value) => _validatePassword(value, l10n),
    );
  }

  Widget _buildLoadingIndicator(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.only(top: defaultPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(width: 12),
          Text(l10n.processingRequest),
        ],
      ),
    );
  }

  /// 构建默认的国旗占位图标
  Widget _buildDefaultFlag({bool showContainer = true}) {
    Widget flagIcon = Icon(
      Icons.flag_outlined,
      size: 14,
      color: Colors.grey[400],
    );

    if (!showContainer) return flagIcon;

    return Container(
      width: 24,
      height: 16,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(2),
      ),
      child: flagIcon,
    );
  }

  /// 构建国旗阴影
  List<BoxShadow> _buildFlagShadow() {
    return [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 2,
        offset: const Offset(0, 1),
      ),
    ];
  }

  /// 处理国旗图片，支持base64和URL格式
  Widget _buildFlagImage(String? flagImageUrl) {
    if (flagImageUrl == null || flagImageUrl.isEmpty) {
      return _buildDefaultFlag();
    }

    // 如果是base64格式
    if (flagImageUrl.startsWith('data:image') ||
        flagImageUrl.startsWith('data:img')) {
      try {
        String base64String = flagImageUrl.split(',').last;
        // 验证base64字符串的有效性
        if (!RegExp(r'^[A-Za-z0-9+/=]+$').hasMatch(base64String)) {
          return _buildDefaultFlag();
        }

        return Container(
          width: 24,
          height: 16,
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: MemoryImage(
                base64Decode(base64String),
              ),
              fit: BoxFit.cover,
              onError: (exception, stackTrace) => _buildDefaultFlag(),
            ),
            borderRadius: BorderRadius.circular(2),
            boxShadow: _buildFlagShadow(),
          ),
        );
      } catch (e) {
        return _buildDefaultFlag();
      }
    }

    // 如果是URL格式
    return Container(
      width: 24,
      height: 16,
      margin: const EdgeInsets.only(right: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: Image.network(
          flagImageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildDefaultFlag(showContainer: false);
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: _buildFlagShadow(),
                ),
                child: child,
              );
            }
            return Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(2),
              ),
              child: const Center(
                child: SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
              ),
            );
          },
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded) return child;
            return AnimatedOpacity(
              opacity: frame == null ? 0 : 1,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              child: child,
            );
          },
          cacheWidth: 48, // 优化图片缓存大小
          cacheHeight: 32,
        ),
      ),
    );
  }

  Widget _buildCountryDropdown() {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return DropdownButtonFormField<String>(
      value: _selectedCountryCode,
      decoration: InputDecoration(
        hintText: l10n.selectCountry,
        prefixIcon: Icon(
          Icons.flag_outlined,
          color: theme.textTheme.bodyLarge!.color!.withOpacity(0.3),
        ),
      ),
      items: _countries.map((country) {
        return DropdownMenuItem<String>(
          value: country['code'],
          child: Row(
            children: [
              _buildFlagImage(country['flagImageUrl']),
              Expanded(
                child: Text(
                  '${country['name']} (${country['code']})',
                  style: theme.textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      }).toList(),
      onChanged: _isLoading
          ? null
          : (value) {
              setState(() {
                _selectedCountryCode = value;
              });
            },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return l10n.countryRequired;
        }
        return null;
      },
      icon: const Icon(Icons.arrow_drop_down),
      isExpanded: true,
      dropdownColor: theme.scaffoldBackgroundColor,
      menuMaxHeight: 300,
    );
  }
}

// 添加扩展方法
extension DioExceptionTypeExtension on DioExceptionType {
  bool get isTimeout =>
      this == DioExceptionType.connectionTimeout ||
      this == DioExceptionType.sendTimeout ||
      this == DioExceptionType.receiveTimeout;
}
