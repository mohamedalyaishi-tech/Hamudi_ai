import 'dart:async';
import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/time_utils.dart';

// ويدجت الساعة الحية للقسم الخامس
class LiveClockWidget extends StatefulWidget {
  const LiveClockWidget({super.key});

  @override
  State<LiveClockWidget> createState() => _LiveClockWidgetState();
}

class _LiveClockWidgetState extends State<LiveClockWidget> {
  String _time = TimeUtils.formatLiveClock();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          _time = TimeUtils.formatLiveClock();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _time,
      style: TextStyle(
        color: AppTheme.matteGold.withOpacity(0.8),
        fontFamily: 'Cairo',
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
