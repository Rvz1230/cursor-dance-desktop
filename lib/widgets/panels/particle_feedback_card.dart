import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../models/action_config.dart';
import '../../models/presets/preset_options.dart';
import '../../theme/tokens.dart';
import '../base/panel_card.dart';
import '../base/panel_meta.dart';
import '../base/panel_divider.dart';
import '../base/section_title.dart';
import '../controls/field_row.dart';
import '../controls/small_select.dart';
import '../controls/control_slider.dart';
import '../controls/color_options.dart';

class ParticleFeedbackCard extends StatelessWidget {
  final ActionConfig config;
  final void Function(ActionConfig Function(ActionConfig)) onUpdate;

  const ParticleFeedbackCard({
    super.key,
    required this.config,
    required this.onUpdate,
  });

  bool get _isOrbital => config.particleMotionMode == 'orbital';

  @override
  Widget build(BuildContext context) {
    return PanelCard(
      id: 'particle',
      title: '粒子反馈',
      meta: PanelMetaRegistry.particle,
      summary: config.particle ? '${config.particleStyle} · ${config.particleCount}个' : '未启用',
      defaultOpen: config.particle,
      action: ShadSwitch(
        value: config.particle,
        onChanged: (v) => onUpdate((c) => c.copyWith(particle: v)),
      ),
      child: Opacity(
        opacity: config.particle ? 1.0 : 0.5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(title: '发射'),
            FieldRow(
              label: '运动模式',
              child: SmallSelect(
                value: config.particleMotionMode,
                options: kParticleMotionModeOptions
                    .map((o) => SelectOption(
                          value: o,
                          label: o == 'burst' ? '爆裂' : '轨道',
                        ))
                    .toList(),
                onChanged: (v) {
                  if (v != null) onUpdate((c) => c.copyWith(particleMotionMode: v));
                },
              ),
            ),
            const PanelDivider(),
            FieldRow(
              label: '粒子样式',
              child: SmallSelect(
                value: config.particleStyle,
                options: kParticleStyleOptions.map((o) => SelectOption(value: o, label: o)).toList(),
                onChanged: (v) {
                  if (v != null) onUpdate((c) => c.copyWith(particleStyle: v));
                },
              ),
            ),
            const PanelDivider(),
            FieldRow(
              label: '粒子数量',
              child: ControlSlider(
                value: config.particleCount,
                min: 2,
                max: 60,
                onChanged: (v) => onUpdate((c) => c.copyWith(particleCount: v)),
              ),
            ),
            if (!_isOrbital) ...[
              const PanelDivider(),
              FieldRow(
                label: '扩散范围',
                child: ControlSlider(
                  value: config.particleSpread,
                  min: 10,
                  max: 150,
                  suffix: 'px',
                  onChanged: (v) => onUpdate((c) => c.copyWith(particleSpread: v)),
                ),
              ),
              const PanelDivider(),
              FieldRow(
                label: '扩散方向',
                child: SmallSelect(
                  value: config.particleDirection,
                  options: kParticleDirectionOptions.map((o) => SelectOption(value: o, label: o)).toList(),
                  onChanged: (v) {
                    if (v != null) onUpdate((c) => c.copyWith(particleDirection: v));
                  },
                ),
              ),
            ],
            if (_isOrbital) ...[
              const PanelDivider(),
              FieldRow(
                label: '轨道数量',
                child: ControlSlider(
                  value: config.orbitalCount,
                  min: 2,
                  max: 24,
                  onChanged: (v) => onUpdate((c) => c.copyWith(orbitalCount: v)),
                ),
              ),
              const PanelDivider(),
              FieldRow(
                label: '轨道半径',
                child: ControlSlider(
                  value: config.orbitalRadius,
                  min: 8,
                  max: 80,
                  suffix: 'px',
                  onChanged: (v) => onUpdate((c) => c.copyWith(orbitalRadius: v)),
                ),
              ),
              const PanelDivider(),
              FieldRow(
                label: '轨道速度',
                child: ControlSlider(
                  value: config.orbitalSpeed,
                  min: 1,
                  max: 10,
                  onChanged: (v) => onUpdate((c) => c.copyWith(orbitalSpeed: v)),
                ),
              ),
            ],
            const SizedBox(height: Spacing.lg),
            const SectionTitle(title: '样式'),
            FieldRow(
              label: '粒子大小',
              child: ControlSlider(
                value: config.particleSize,
                min: 4,
                max: 32,
                suffix: 'px',
                onChanged: (v) => onUpdate((c) => c.copyWith(particleSize: v)),
              ),
            ),
            if (!_isOrbital) ...[
              const PanelDivider(),
              FieldRow(
                label: '持续时长',
                child: ControlSlider(
                  value: config.particleDuration,
                  min: 200,
                  max: 2000,
                  divisions: 9,
                  suffix: 'ms',
                  onChanged: (v) => onUpdate((c) => c.copyWith(particleDuration: v)),
                ),
              ),
            ],
            const PanelDivider(),
            FieldRow(
              label: '透明度',
              child: ControlSlider(
                value: config.particleOpacity,
                min: 10,
                max: 100,
                suffix: '%',
                onChanged: (v) => onUpdate((c) => c.copyWith(particleOpacity: v)),
              ),
            ),
            const PanelDivider(),
            FieldRow(
              label: '颜色模式',
              child: SmallSelect(
                value: config.particleColorMode,
                options: kParticleColorModeOptions.map((o) => SelectOption(value: o, label: o)).toList(),
                onChanged: (v) {
                  if (v != null) onUpdate((c) => c.copyWith(particleColorMode: v));
                },
              ),
            ),
            if (config.particleColorMode == '自定义色板') ...[
              const PanelDivider(),
              FieldRow(
                label: '色板',
                child: _PaletteEditor(
                  palette: config.particlePalette,
                  onChanged: (v) => onUpdate((c) => c.copyWith(particlePalette: v)),
                ),
              ),
            ],
            if (!_isOrbital) ...[
              const SizedBox(height: Spacing.lg),
              const SectionTitle(title: '物理'),
              FieldRow(
                label: '重力',
                child: ControlSlider(
                  value: config.particleGravity,
                  min: -20,
                  max: 40,
                  suffix: '%',
                  onChanged: (v) => onUpdate((c) => c.copyWith(particleGravity: v)),
                ),
              ),
              const PanelDivider(),
              FieldRow(
                label: '风力',
                child: ControlSlider(
                  value: config.particleWind,
                  min: 0,
                  max: 40,
                  suffix: '%',
                  onChanged: (v) => onUpdate((c) => c.copyWith(particleWind: v)),
                ),
              ),
              const PanelDivider(),
              FieldRow(
                label: '弹跳',
                child: ControlSlider(
                  value: config.particleBounce,
                  min: 0,
                  max: 50,
                  suffix: '%',
                  onChanged: (v) => onUpdate((c) => c.copyWith(particleBounce: v)),
                ),
              ),
              const PanelDivider(),
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
      ),
    );
  }
}

class _PaletteEditor extends StatelessWidget {
  final List<String> palette;
  final ValueChanged<List<String>> onChanged;

  const _PaletteEditor({required this.palette, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: Spacing.xs,
      runSpacing: Spacing.xs,
      children: [
        for (var i = 0; i < palette.length; i++)
          ColorOptions(
            value: palette[i],
            onChanged: (v) {
              final updated = [...palette];
              updated[i] = v;
              onChanged(updated);
            },
          ),
      ],
    );
  }
}
