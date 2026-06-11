class TimingFieldMeta {
  final bool showTiming;
  final bool showZone;
  final bool showHold;

  const TimingFieldMeta({
    required this.showTiming,
    required this.showZone,
    required this.showHold,
  });
}

const _timingMetaMap = {
  'leftClick': TimingFieldMeta(showTiming: true, showZone: true, showHold: true),
  'rightClick': TimingFieldMeta(showTiming: true, showZone: true, showHold: true),
  'doubleClick': TimingFieldMeta(showTiming: false, showZone: true, showHold: false),
  'longPress': TimingFieldMeta(showTiming: true, showZone: true, showHold: true),
  'wheel': TimingFieldMeta(showTiming: false, showZone: true, showHold: false),
  'hover': TimingFieldMeta(showTiming: true, showZone: true, showHold: false),
};

TimingFieldMeta timingFieldMeta(String actionId) =>
    _timingMetaMap[actionId] ?? const TimingFieldMeta(showTiming: true, showZone: true, showHold: false);
