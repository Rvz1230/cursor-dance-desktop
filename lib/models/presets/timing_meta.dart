// ═══════════════════════════════════════════════════════════════
// Timing Field Meta — holds metadata for trigger timing sliders
// ═══════════════════════════════════════════════════════════════

class TimingFieldMeta {
  final String label;
  final String hint;
  final int min;
  final int max;

  const TimingFieldMeta(this.label, this.hint, this.min, this.max);
}

TimingFieldMeta timingFieldMeta(String actionId) {
  switch (actionId) {
    case 'longPress':
      return TimingFieldMeta('长按阈值', '按住多久以后才算长按。', 200, 900);
    case 'doubleClick':
      return TimingFieldMeta('双击间隔', '两次点击之间允许的最大间隔。', 180, 520);
    case 'hover':
      return TimingFieldMeta('停留阈值', '鼠标停多久之后再触发 hover 效果。', 80, 700);
    case 'wheel':
      return TimingFieldMeta('合并间隔', '连续滚动时，多久合并为一次反馈。', 80, 520);
    default:
      return TimingFieldMeta('触发延迟', '动作识别后，延迟多久开始反馈。', 0, 320);
  }
}
