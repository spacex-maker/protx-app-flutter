import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../utils/http_client.dart';
import 'package:flutter/foundation.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  final String countryCode;
  final String locale;

  const PrivacyPolicyScreen({
    super.key,
    required this.countryCode,
    required this.locale,
  });

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  String _content = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  Future<void> _loadContent() async {
    try {
      final url =
          '/base/client-country-config/private-and-service-item/${widget.countryCode}/${widget.locale}';
      final response = await HttpClient.get(url);

      if (response.statusCode == 200 && response.data['success']) {
        setState(() {
          _content = response.data['data']['privacyPolicyContent'];
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Debug - PrivacyPolicyScreen - Error: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.privacyPolicy),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Html(data: _content),
            ),
    );
  }
}
