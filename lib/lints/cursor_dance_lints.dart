import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// 插件入口 — 注册所有 CursorDance 设计令牌规则
class CursorDanceLintPlugin extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
        const _NoHardcodedFontSize(),
        const _NoHardcodedBorderRadius(),
        const _NoHardcodedSpacing(),
      ];
}

// ── 工具函数 ──

/// 判断节点是否为一个 IntegerLiteral 或 DoubleLiteral
bool _isNumericLiteral(Expression node) =>
    node is IntegerLiteral || node is DoubleLiteral;

/// 检查 MethodInvocation 的 staticType 是否包含期望的类型名
bool _returnsType(MethodInvocation node, String typeName) {
  final type = node.staticType?.getDisplayString(withNullability: false) ?? '';
  return type == typeName;
}

// ── 规则 1：禁止硬编码 fontSize ──

class _NoHardcodedFontSize extends DartLintRule {
  const _NoHardcodedFontSize() : super(code: _code);

  static const _code = LintCode(
    name: 'no_hardcoded_font_size',
    problemMessage: '禁止硬编码 fontSize。请使用 FontSizes.* 令牌。',
    correctionMessage:
        '将数字替换为 FontSizes 中的常量。\n'
        '  fontSize:  9 → FontSizes.micro\n'
        '  fontSize: 11 → FontSizes.caption\n'
        '  fontSize: 12 → FontSizes.small\n'
        '  fontSize: 13 → FontSizes.body\n'
        '  fontSize: 14 → FontSizes.base (或 FontSizes.h4)\n'
        '  fontSize: 16 → FontSizes.h3\n'
        '  fontSize: 18 → FontSizes.h2',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      final type = node.staticType?.toString() ?? '';
      if (!type.contains('TextStyle')) return;

      for (final arg in node.argumentList.arguments) {
        if (arg is NamedExpression &&
            arg.name.label.name == 'fontSize' &&
            _isNumericLiteral(arg.expression)) {
          reporter.reportErrorForNode(_code, arg.expression);
        }
      }
    });
  }
}

// ── 规则 2：禁止硬编码圆角 ──

class _NoHardcodedBorderRadius extends DartLintRule {
  const _NoHardcodedBorderRadius() : super(code: _code);

  static const _code = LintCode(
    name: 'no_hardcoded_border_radius',
    problemMessage: '禁止硬编码圆角值。请使用 RadiusTokens.* 令牌。',
    correctionMessage:
        '将数字替换为 RadiusTokens 中的常量。\n'
        '  4  → RadiusTokens.sm\n'
        '  6  → RadiusTokens.md\n'
        '  8  → RadiusTokens.lg\n'
        '  12 → RadiusTokens.xl\n'
        '  16 → RadiusTokens.xl2',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addMethodInvocation((node) {
      // 匹配 .circular(N) 调用（BorderRadius.circular / Radius.circular）
      if (node.methodName.name != 'circular') return;

      final type = node.staticType?.toString() ?? '';
      if (!type.contains('BorderRadius') && !type.contains('Radius')) return;

      for (final arg in node.argumentList.arguments) {
        if (_isNumericLiteral(arg)) {
          reporter.reportErrorForNode(_code, arg);
        }
      }
    });
  }
}

// ── 规则 3：禁止硬编码间距 ──

class _NoHardcodedSpacing extends DartLintRule {
  const _NoHardcodedSpacing() : super(code: _code);

  static const _code = LintCode(
    name: 'no_hardcoded_spacing',
    problemMessage: '禁止硬编码间距值。请使用 Spacing.* 令牌。',
    correctionMessage:
        '将数字替换为 Spacing 中的常量。\n'
        '  4  → Spacing.xs\n'
        '  8  → Spacing.sm\n'
        ' 12  → Spacing.md\n'
        ' 16  → Spacing.lg\n'
        ' 24  → Spacing.xl\n'
        ' 32  → Spacing.xxl\n'
        ' 48  → Spacing.xxxl',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addMethodInvocation((node) {
      final methodName = node.methodName.name;

      // 匹配 EdgeInsets 静态方法
      // EdgeInsets.all(N) / EdgeInsets.only(...) / EdgeInsets.symmetric(...) / EdgeInsets.fromLTRB(...)
      if (![
        'all',
        'only',
        'symmetric',
        'fromLTRB',
        'fromWindowPadding',
      ].contains(methodName)) return;

      // 验证返回值是 EdgeInsets 类型
      if (!_returnsType(node, 'EdgeInsets')) return;

      for (final arg in node.argumentList.arguments) {
        if (arg is NamedExpression) {
          // EdgeInsets.symmetric(horizontal: 12, vertical: 8)
          final value = arg.expression;
          if (_isNumericLiteral(value)) {
            reporter.reportErrorForNode(_code, value);
          }
        } else if (_isNumericLiteral(arg)) {
          // EdgeInsets.all(8)
          reporter.reportErrorForNode(_code, arg);
        }
      }
    });

    // 也匹配 SizedBox / Container 中的硬编码 width/height
    // SizedBox(width: 32) — 这个太宽泛，先只锁定 EdgeInsets
  }
}
