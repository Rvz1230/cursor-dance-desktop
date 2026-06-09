import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../models/action_config.dart';
import '../../models/action_config_presets.dart';
import '../../theme/app_tokens.dart';
import '../controls/color_options.dart';
import '../controls/control_slider.dart';
import '../controls/field_row.dart';
import '../controls/small_select.dart';
import '../controls/config_section.dart';
import '../panels/panel_card.dart';
import '../panels/panel_meta.dart';

class ParticleFeedbackCard extends StatelessWidget {
  final ActionConfig config;
  final void Function(ActionConfig Function(ActionConfig)) onUpdate;

  const ParticleFeedbackCard({
    super.key,
    required this.config,
    required this.onUpdate,
  });

  bool get _isOrbital => config.particleMotionMode == 'orbital';

  String _buildSummary() {
    if (!config.particle) return '已关闭';
    final mode = _isOrbital ? '轨道' : '喷射';
    final style = config.particleStyle;
    return '$mode - ${config.particleCount}粒子 · $style';
  }

  @override
  Widget build(BuildContext context) {
    final enabled = config.particle;

    return PanelCard(
      id: 'particle',
      title: '粒子反馈',
      meta: PanelMetaRegistry.particle,
      summary: _buildSummary(),
      action: ShadSwitch(
        value: enabled,
        onChanged: (v) => onUpdate((c) => c.copyWith(particle: v)),
      ),
      collapsible: true,
      defaultOpen: enabled,
      enabled: enabled,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(title: '发射'),
          FieldRow(
            label: '运动模式',
            child: SmallSelect(
              label: '运动模式',
              value: config.particleMotionMode,
              options: kParticleMotionModeOptions.map((m) => m['value'] as String).toList(),
              onChanged: (v) => onUpdate((c) => c.copyWith(particleMotionMode: v)),
            ),
          ),
          _divider(),
          FieldRow(
            label: '粒子样式',
            child: SmallSelect(
              label: '粒子样式',
              value: config.particleStyle,
              options: kParticleStyleOptions,
              onChanged: (v) => onUpdate((c) => c.copyWith(particleStyle: v)),
            ),
          ),
          _divider(),
          FieldRow(
            label: '粒子数量',
            child: ControlSlider(
              label: '粒子数量',
              value: config.particleCount.toDouble(),
              min: 2,
              max: 60,
              divisions: 29,
              onChanged: (v) => onUpdate((c) => c.copyWith(particleCount: v.round())),
            ),
          ),
          if (!_isOrbital) ...[
            _divider(),
            FieldRow(
              label: '扩散范围',
              child: ControlSlider(
                label: '扩散范围',
                value: config.particleSpread.toDouble(),
                min: 10,
                max: 150,
                divisions: 14,
                suffix: 'px',
                onChanged: (v) => onUpdate((c) => c.copyWith(particleSpread: v.round())),
              ),
            ),
          ],
          if (!_isOrbital) ...[
            _divider(),
            FieldRow(
              label: '扩散方向',
              child: SmallSelect(
                label: '扩散方向',
                value: config.particleDirection,
                options: kParticleDirectionOptions,
                onChanged: (v) => onUpdate((c) => c.copyWith(particleDirection: v)),
              ),
            ),
          ],
          if (_isOrbital) ...[
            _divider(),
            FieldRow(
              label: '轨道数量',
              child: ControlSlider(
                label: '轨道数量',
                value: config.orbitalCount.toDouble(),
                min: 2,
                max: 24,
                divisions: 11,
                onChanged: (v) => onUpdate((c) => c.copyWith(orbitalCount: v.round())),
              ),
            ),
          ],
          if (_isOrbital) ...[
            _divider(),
            FieldRow(
              label: '轨道半径',
              child: ControlSlider(
                label: '轨道半径',
                value: config.orbitalRadius.toDouble(),
                min: 8,
                max: 80,
                divisions: 18,
                suffix: 'px',
                onChanged: (v) => onUpdate((c) => c.copyWith(orbitalRadius: v.round())),
              ),
            ),
          ],
          if (_isOrbital) ...[
            _divider(),
            FieldRow(
              label: '轨道速度',
              child: ControlSlider(
                label: '轨道速度',
                value: config.orbitalSpeed.toDouble(),
                min: 1,
                max: 10,
                divisions: 9,
                onChanged: (v) => onUpdate((c) => c.copyWith(orbitalSpeed: v.round())),
              ),
            ),
          ],
          const SizedBox(height: 20),
          const SectionTitle(title: '样式'),
          FieldRow(
            label: '粒子大小',
            child: ControlSlider(
              label: '粒子大小',
              value: config.particleSize.toDouble(),
              min: 4,
              max: 32,
              divisions: 14,
              suffix: 'px',
              onChanged: (v) => onUpdate((c) => c.copyWith(particleSize: v.round())),
            ),
          ),
          _divider(),
          if (!_isOrbital) ...[
            FieldRow(
              label: '持续时长',
              child: ControlSlider(
                label: '持续时长',
                value: config.particleDuration.toDouble(),
                min: 200,
                max: 2000,
                divisions: 18,
                suffix: 'ms',
                onChanged: (v) => onUpdate((c) => c.copyWith(particleDuration: v.round())),
              ),
            ),
            _divider(),
          ],
          FieldRow(
            label: '透明度',
            child: ControlSlider(
              label: '透明度',
              value: config.particleOpacity.toDouble(),
              min: 10,
              max: 100,
              divisions: 9,
              suffix: '%',
              onChanged: (v) => onUpdate((c) => c.copyWith(particleOpacity: v.round())),
            ),
          ),
          _divider(),
          FieldRow(
            label: '颜色模式',
            child: SmallSelect(
              label: '颜色模式',
              value: config.particleColorMode,
              options: kParticleColorModeOptions,
              onChanged: (v) => onUpdate((c) => c.copyWith(particleColorMode: v)),
            ),
          ),
          _divider(),
          FieldRow(
            label: '色板',
            child: ColorOptions(
              value: config.particlePalette.isNotEmpty ? config.particlePalette.first : '#FBBF24',
              swatches: ['#FBBF24', '#14B8A6', '#A78BFA', '#334155', '#F97316', '#F43F5E'],
              onChanged: (v) => onUpdate((c) {
                final palette = c.particlePalette;
                if (palette.isEmpty) return c.copyWith(particlePalette: [v]);
                final updated = [v, ...palette.skip(1)];
                return c.copyWith(particlePalette: updated);
              }),
            ),
          ),
          if (!_isOrbital) ...[
            const SizedBox(height: 20),
            const SectionTitle(title: '物理'),
            FieldRow(
              label: '重力',
              child: ControlSlider(
                label: '重力',
                value: config.particleGravity.toDouble(),
                min: -20,
                max: 40,
                divisions: 15,
                suffix: '%',
                onChanged: (v) => onUpdate((c) => c.copyWith(particleGravity: v.round())),
              ),
            ),
            _divider(),
            FieldRow(
              label: '风力',
              child: ControlSlider(
                label: '风力',
                value: config.particleWind.toDouble(),
                min: 0,
                max: 40,
                divisions: 10,
                suffix: '%',
                onChanged: (v) => onUpdate((c) => c.copyWith(particleWind: v.round())),
              ),
            ),
            _divider(),
            FieldRow(
              label: '弹跳',
              child: ControlSlider(
                label: '弹跳',
                value: config.particleBounce.toDouble(),
                min: 0,
                max: 50,
                divisions: 10,
                suffix: '%',
                onChanged: (v) => onUpdate((c) => c.copyWith(particleBounce: v.round())),
              ),
            ),
            _divider(),
            FieldRow(
              label: '拖尾',
              child: ShadSwitch(
                value: config.particleTrail,
                onChanged: (v) => onUpdate((c) => c.copyWith(particleTrail: v)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(height: 1, color: AppColors.muted);
  }
}
