import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_music_app/constants/app_colors.dart';

class QrLoginWidget extends StatefulWidget {
  final Future<String> Function() onGetKey;
  final Future<String> Function(String key) onCreateQrCode;
  final Future<Map<String, dynamic>> Function(String key) onCheckStatus;
  final void Function(Map<String, dynamic> result) onLoginSuccess;

  const QrLoginWidget({
    super.key,
    required this.onGetKey,
    required this.onCreateQrCode,
    required this.onCheckStatus,
    required this.onLoginSuccess,
  });

  @override
  State<QrLoginWidget> createState() => _QrLoginWidgetState();
}

class _QrLoginWidgetState extends State<QrLoginWidget> {
  String? _key;
  String? _qrImg;
  String _statusText = '请用网易云 App 扫描二维码';
  bool _loading = true;
  bool _expired = false;
  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();
    _initQr();
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  Future<void> _initQr() async {
    setState(() {
      _loading = true;
      _expired = false;
      _statusText = '请用网易云 App 扫描二维码';
    });
    _pollTimer?.cancel();
    try {
      final key = await widget.onGetKey();
      final img = await widget.onCreateQrCode(key);
      setState(() {
        _key = key;
        _qrImg = img;
        _loading = false;
      });
      _startPolling();
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  void _startPolling() {
    // 每过30秒刷新一遍二维码的状态
    _pollTimer = Timer.periodic(const Duration(seconds: 30), (_) async {
      if (_key == null) return;
      try {
        final res = await widget.onCheckStatus(_key!);
        final code = res['code'] as int;
        if (!mounted) return;
        // 800: 过期  801: 等待扫码  802: 待确认  803: 登录成功
        if (code == 803) {
          _pollTimer?.cancel();
          widget.onLoginSuccess(res);
        } else if (code == 800) {
          _pollTimer?.cancel();
          setState(() {
            _expired = true;
            _statusText = '二维码已过期，请刷新';
          });
        } else if (code == 802) {
          setState(() => _statusText = '扫码成功，请在 App 内确认');
        } else {
          setState(() => _statusText = '请用网易云 App 扫描二维码');
        }
      } catch (_) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _qrImg == null
              ? const Icon(Icons.error_outline, size: 48)
              : ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // 将api返回的base64字符串渲染成图片
                      Image.memory(
                        base64Decode(
                          _qrImg!.replaceFirst(
                            RegExp(r'data:image/[^;]+;base64,'),
                            '',
                          ),
                        ),
                        fit: BoxFit.cover,
                      ),
                      if (_expired)
                        Container(
                          color: Colors.black54,
                          child: Center(
                            child: IconButton(
                              onPressed: _initQr,
                              icon: const Icon(
                                Icons.refresh,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
        ),
        const SizedBox(height: 10),
        Text(
          _statusText,
          style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
      ],
    );
  }
}
