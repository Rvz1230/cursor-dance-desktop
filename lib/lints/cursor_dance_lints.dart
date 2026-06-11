import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class CursorDanceLintPlugin extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
        const _NoHardcodedFontSize(),
        const _NoHardcodedBorderRadius(),
        const _NoHardcodedSpacing(),
      ];
}

bool _isNumericLiteral(Expression node) =>
    node is IntegerLiteral || node is DoubleLiteral;

bool _returnsType(MethodInvocation node, String typeName) {
  final type =
      node.staticType?.getDisplayString(withNullability: false) ?? '';
  return type == typeName;
}

// ── Rule 1: no_hardcoded_fontSize ──

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

// ── Rule 2: no_hardcoded_borderRadius ──

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

// ── Rule 3: no_hardcoded_spacing ──

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
        ' 20  → Spacing.lg\n'
        ' 28  → Spacing.xl\n'
        ' 32  → Spacing.xxl\n'
        ' 40  → Spacing.section',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addMethodInvocation((node) {
      final methodName = node.methodName.name;

      if (![
        'all',
        'only',
        'symmetric',
        'fromLTRB',
        'fromWindowPadding',
      ].contains(methodName)) return;

      if (!_returnsType(node, 'EdgeInsets')) return;

      for (final arg in node.argumentList.arguments) {
        if (arg is NamedExpression) {
          final value = arg.expression;
          if (_isNumericLiteral(value)) {
            reporter.reportErrorForNode(_code, value);
          }
        } else if (_isNumericLiteral(arg)) {
          reporter.reportErrorForNode(_code, arg);
        }
      }
    });
  }
}
