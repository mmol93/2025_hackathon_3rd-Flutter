import 'package:flutter/material.dart';

class CommonCardWidget {
  // 카드 컨테이너
  static Widget buildBasicCard({
    required Widget child,
    double borderRadius = 24,
    List<BoxShadow>? boxShadow,
    Color? backgroundColor,
    Border? border,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        border:
            border ?? Border.all(color: Colors.grey.withOpacity(0.1), width: 1),
        boxShadow:
            boxShadow ??
            [
              BoxShadow(
                color: Colors.grey.withOpacity(0.08),
                spreadRadius: 0,
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
      ),
      child: child,
    );
  }

  // 헤더가 있는 컨텐츠 카드
  static Widget buildContentCard({
    required String title,
    required String content,
    required IconData icon,
    required BuildContext context,
    required List<Color> gradientColors,
    double borderRadius = 24,
    EdgeInsets? headerPadding,
    EdgeInsets? contentPadding,
  }) {
    return buildBasicCard(
      borderRadius: borderRadius,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더
          Container(
            padding:
                headerPadding ??
                const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(borderRadius),
                topRight: Radius.circular(borderRadius),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 0,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(icon, size: 24, color: gradientColors[1]),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 내용
          Padding(
            padding: contentPadding ?? const EdgeInsets.all(24),
            child: Text(
              content,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[800],
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 헤더가 있는 커스텀 바디 카드
  static Widget buildCustomBodyCard({
    required String title,
    required Widget body,
    required IconData icon,
    required BuildContext context,
    required List<Color> gradientColors,
    Widget? headerSuffix, // 헤더 오른쪽 추가 위젯
    double borderRadius = 24,
    EdgeInsets? headerPadding,
    EdgeInsets? bodyPadding,
  }) {
    return buildBasicCard(
      borderRadius: borderRadius,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더
          Container(
            padding:
                headerPadding ??
                const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(borderRadius),
                topRight: Radius.circular(borderRadius),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 0,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(icon, size: 24, color: gradientColors[1]),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                if (headerSuffix != null) headerSuffix,
              ],
            ),
          ),
          // 커스텀 바디
          Padding(
            padding: bodyPadding ?? const EdgeInsets.all(24),
            child: body,
          ),
        ],
      ),
    );
  }

  // 특별한 스타일의 카드 (신뢰도 점수용)
  static Widget buildSpecialCard({
    required Widget child,
    required List<Color> gradientColors,
    double borderRadius = 32,
    EdgeInsets? padding,
    List<BoxShadow>? boxShadow,
  }) {
    return Container(
      padding: padding ?? const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow:
            boxShadow ??
            [
              BoxShadow(
                color: gradientColors[1].withOpacity(0.25),
                spreadRadius: 0,
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
      ),
      child: child,
    );
  }
}
