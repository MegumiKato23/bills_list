import 'package:flutter/material.dart';

class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFFFF7CC),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: const Text(
        '当前为离线缓存数据',
        style: TextStyle(fontSize: 12, color: Color(0xFF854D0E)),
      ),
    );
  }
}
