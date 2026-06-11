// ── Trigger options (per actionId) ────────────────────────

const kTriggerTimingOptions = {
  'leftClick': ['按下时', '抬起时'],
  'rightClick': ['按下时', '抬起时'],
  'doubleClick': ['抬起时'],
  'longPress': ['按下时', '抬起时'],
  'wheel': ['滚动时'],
  'hover': ['进入时', '离开时'],
};

const kTriggerZoneOptions = {
  'leftClick': ['当前页面可点击区域', '全屏'],
  'rightClick': ['当前页面可点击区域', '全屏'],
  'doubleClick': ['当前页面可点击区域', '全屏'],
  'longPress': ['当前页面可点击区域', '全屏'],
  'wheel': ['当前页面', '全屏'],
  'hover': ['当前页面', '全屏'],
};

// ── Text options ──────────────────────────────────────────

const kTextKindOptions = ['数字飘字', '文案飘字'];
const kTextStyleOptions = ['阿拉伯数字 (1, 2, 3)', '罗马数字 (I, II, III)', '中文数字 (一, 二, 三)'];
const kTextModeOptions = ['默认模式 (+1)', '模板模式'];
const kTextTagPlayModeOptions = ['按顺序显示', '随机'];
const kTextEasingOptions = ['线性', '缓入', '缓出', '缓入缓出', '弹跳', '弹性'];
const kTextFontFamilyOptions = ['系统默认', 'Menlo', 'Monaco', 'Helvetica Neue', 'PingFang SC'];
const kTextWeightOptions = ['常规', '中等', '加粗', '特粗'];
const kTextShadowOptions = ['无', '柔和', '硬边'];

// ── Particle options ─────────────────────────────────────

const kParticleStyleOptions = ['点状粒子', '圆形粒子', '方形粒子', '星形粒子'];
const kParticleDirectionOptions = ['四周扩散', '向上', '向下', '向左', '向右'];
const kParticleColorModeOptions = ['跟随主题', '自定义色板', '随机'];
const kParticleMotionModeOptions = ['burst', 'orbital'];

// ── Ripple options ────────────────────────────────────────

const kRippleStyleOptions = ['单环', '双环', '填充圆'];
const kRippleEasingOptions = ['线性', '缓入', '缓出', '缓入缓出'];

// ── Audio options ─────────────────────────────────────────

const kSoundFileOptions = ['click.wav', 'pop.wav', 'snap.wav', 'bubble.wav', 'ding.wav'];
const kSoundTriggerModeOptions = ['每次触发', '冷却模式', '连击模式'];
const kSoundBlendModeOptions = ['叠加', '独占', '队列'];

// ── Animation options ─────────────────────────────────────

const kAnimationStyleOptions = ['缩放脉冲', '淡入淡出', '抖动', '旋转', '弹跳'];
const kAnimationEasingOptions = ['线性', '缓入', '缓出', '缓入缓出', '弹性'];

// ── Image options ─────────────────────────────────────────
// (imageDataUrl uses file picker, no preset list)

// ── Cursor options ────────────────────────────────────────

const kCursorOverrideOptions = ['none', 'pointer', 'crosshair', 'beam'];
const kCursorSizeOptions = ['24', '32', '48', '64'];

// ── Easing options (shared) ───────────────────────────────

const kEasingOptions = ['线性', '缓入', '缓出', '缓入缓出', '弹跳', '弹性'];
