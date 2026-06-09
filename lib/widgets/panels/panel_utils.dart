import 'package:flutter/material.dart';

import '../../theme/app_tokens.dart';

/// 效果卡片间 1px 分割线
const panelDivider = SizedBox(
  height: 1,
  child: DecoratedBox(decoration: BoxDecoration(color: AppColors.muted)),
);
