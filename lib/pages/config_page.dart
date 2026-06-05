import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../bridge/overlay_bridge.dart';
import '../effects/particle_burst.dart';
import '../models/particle_config.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> with TickerProviderStateMixin {
  final ParticleBurst _burst = ParticleBurst();
  final OverlayBridge _bridge = OverlayBridge();
  final ShadSliderController _sizeController = ShadSliderController(initialValue: 12);
  final ShadSliderController _speedController = ShadSliderController(initialValue: 5);
  Ticker? _ticker;

  bool _enabled = false;
  double get _size => _sizeController.value;
  double get _speed => _speedController.value;
  int _selectedColorIndex = 0;

  ParticleConfig get _config => ParticleConfig(
        color: ParticleConfig.presets[_selectedColorIndex],
        size: _size,
        speed: _speed,
      );

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
  }

  @override
  void dispose() {
    _ticker?.dispose();
    super.dispose();
  }

  void _onTick(Duration elapsed) {
    _burst.update(1.0 / 60);
    if (!_burst.isAlive) {
      _ticker?.stop();
    }
    setState(() {});
  }

  void _onPreviewTap(TapDownDetails details) {
    _burst.spawn(details.localPosition.dx, details.localPosition.dy, _config);
    if (!_ticker!.isActive) {
      _ticker?.start();
    }
    setState(() {});
  }

  void _setColor(int index) {
    setState(() => _selectedColorIndex = index);
    if (_enabled) {
      _bridge.updateConfig(_config);
    }
  }

  void _setSize(double value) {
    _sizeController.value = value;
    if (_enabled) {
      _bridge.updateConfig(_config);
    }
  }

  void _setSpeed(double value) {
    _speedController.value = value;
    if (_enabled) {
      _bridge.updateConfig(_config);
    }
  }

  Future<void> _toggleEnabled() async {
    if (_enabled) {
      await _bridge.stop();
      setState(() => _enabled = false);
    } else {
      await _bridge.start(_config);
      setState(() => _enabled = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              _buildSidebar(context),
              const VerticalDivider(width: 1),
              Expanded(child: _buildPreview(context)),
            ],
          ),
        ),
        const Divider(height: 1),
        _buildBottomBar(context),
      ],
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return SizedBox(
      width: 260,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('粒子颜色', style: ShadTheme.of(context).textTheme.h4),
            const SizedBox(height: 12),
            _buildColorPresets(),
            const SizedBox(height: 28),
            Text('粒子大小', style: ShadTheme.of(context).textTheme.h4),
            const SizedBox(height: 8),
            ShadSlider(
              controller: _sizeController,
              min: 2,
              max: 24,
              divisions: 11,
              label: _size.round().toString(),
              onChanged: _setSize,
            ),
            const SizedBox(height: 28),
            Text('爆发速度', style: ShadTheme.of(context).textTheme.h4),
            const SizedBox(height: 8),
            ShadSlider(
              controller: _speedController,
              min: 1,
              max: 10,
              divisions: 9,
              label: _speed.round().toString(),
              onChanged: _setSpeed,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorPresets() {
    return Row(
      children: [
        for (int i = 0; i < ParticleConfig.presets.length; i++)
          Padding(
            padding: EdgeInsets.only(right: i < 2 ? 12 : 0),
            child: GestureDetector(
              onTap: () => _setColor(i),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: ParticleConfig.presets[i],
                  shape: BoxShape.circle,
                  border: _selectedColorIndex == i
                      ? Border.all(
                          color: Colors.white,
                          width: 3,
                        )
                      : null,
                  boxShadow: _selectedColorIndex == i
                      ? [
                          BoxShadow(
                            color: ParticleConfig.presets[i].withValues(alpha: 0.5),
                            blurRadius: 8,
                          ),
                        ]
                      : null,
                ),
                child: _selectedColorIndex == i
                    ? const Icon(Icons.check, color: Colors.white, size: 18)
                    : null,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPreview(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ShadTheme.of(context).colorScheme.muted,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: GestureDetector(
          onTapDown: _onPreviewTap,
          child: Stack(
            children: [
              Center(
                child: Text(
                  '点击此处预览动效',
                  style: ShadTheme.of(context).textTheme.p.copyWith(
                        color: ShadTheme.of(context).colorScheme.mutedForeground,
                      ),
                ),
              ),
              CustomPaint(
                painter: ParticlePainter(_burst.particles),
                size: Size.infinite,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: theme.colorScheme.background,
      ),
      child: Row(
        children: [
          Icon(
            _enabled ? Icons.circle : Icons.circle_outlined,
            size: 10,
            color: _enabled
                ? const Color(0xFF22C55E)
                : theme.colorScheme.mutedForeground,
          ),
          const SizedBox(width: 8),
          Text(
            _enabled ? '动效已启用' : '动效已停止',
            style: theme.textTheme.p.copyWith(
              color: _enabled
                  ? const Color(0xFF22C55E)
                  : theme.colorScheme.mutedForeground,
            ),
          ),
          const Spacer(),
          ShadButton(
            onPressed: _toggleEnabled,
            backgroundColor: _enabled
                ? theme.colorScheme.destructive
                : theme.colorScheme.primary,
            child: Text(_enabled ? '停止' : '启用'),
          ),
        ],
      ),
    );
  }
}
