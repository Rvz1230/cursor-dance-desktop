// ═══════════════════════════════════════════════════════════════
// Option Lists — used across panel cards via action_config_presets.dart
// ═══════════════════════════════════════════════════════════════

const kTriggerOptions = {
  'leftClick': {
    'timing': ['按下时', '抬起时'],
    'zones': ['当前页面可点击区域', '仅按钮和链接', '全部可交互元素'],
  },
  'rightClick': {
    'timing': ['按下时', '菜单弹出前'],
    'zones': ['右键菜单前', '可交互元素', '空白区域'],
  },
  'doubleClick': {
    'timing': ['第二次按下时', '第二次抬起后'],
    'zones': ['双击命中区域', '主操作按钮', '内容卡片'],
  },
  'longPress': {
    'timing': ['按住达到阈值', '松开后触发'],
    'zones': ['按住后释放', '长按可交互元素', '全局长按区'],
  },
  'wheel': {
    'timing': ['滚动开始时', '连续滚动中'],
    'zones': ['向上 / 向下滚轮', '仅向上滚动', '仅向下滚动'],
  },
  'hover': {
    'timing': ['进入时', '停留后'],
    'zones': ['进入可交互元素', '仅按钮和链接', '全页面 hover'],
  },
};

const kSoundFileOptions = [
  'woodfish-soft.wav',
  'woodfish-deep.wav',
  'tick-light.wav',
  'chime-bright.wav',
  'pop-soft.wav',
  'swipe-whoosh.wav',
];

const kCursorOverrideOptions = [
  '跟随当前状态',
  '木鱼（继承默认）',
  '木鱼（增强态）',
  '木鱼（按压态）',
  '切换到 pointer',
];

const kTextKindOptions = ['数字飘字', '文本飘字'];
const kNumberStyleOptions = [
  '阿拉伯数字 (1, 2, 3)',
  '中文数字 (一, 二, 三)',
  '英文单词 (one, two, three)',
];
const kTextModeOptions = ['默认模式 (+1)', '模板模式'];
const kTextTagPlayOptions = ['按顺序显示', '随机显示'];
const kTextEasingOptions = ['线性', '缓入', '缓出', '缓入缓出', '弹跳', '弹性'];
const kTextWeightOptions = ['常规', '中等', '加粗'];
const kTextShadowOptions = ['无', '柔和', '清晰'];
const kTextFontPresets = [
  '系统默认',
  '苹方 / 微软雅黑',
  '宋体',
  '黑体',
  '楷体',
  '等宽字体',
  '自定义',
];

const kParticleStyleOptions = [
  '点状粒子',
  '碎屑粒子',
  '火花',
  '星光',
  '钻石',
  '心形',
  '方块',
  '三角',
];
const kParticleDirectionOptions = ['四周扩散', '旋转扫射', '向上喷发', '随机散射'];
const kParticleColorModeOptions = ['跟随主题', '跟随飘字色', '随机轻变化'];
const kParticleMotionModeOptions = [
  {'value': 'burst', 'label': '喷射扩散'},
  {'value': 'orbital', 'label': '轨道呼吸'},
];

const kRippleStyleOptions = [
  '单环',
  '双环',
  '柔和面波',
  '脉冲波纹',
  '回声环',
  '能量脉冲',
];
const kRippleEasingOptions = ['线性', '缓出', '缓入缓出', '弹性'];

const kAudioTriggerOptions = ['每次触发', '连击叠加', '节流播放'];
const kAudioBlendOptions = ['保持原音量', '压低页面音频', '仅插件音效'];

const kCursorSizeOptions = ['32 × 32', '40 × 40', '48 × 48', '56 × 56', '64 × 64'];

const kAnimationStyleOptions = [
  '聚焦脉冲',
  '斜切闪片',
  '弹跳徽记',
  '漩涡旋转',
  '星光闪耀',
  '轨道环绕',
  '螺旋上升',
];
const kAnimationEasingOptions = ['线性', '缓出', '缓入缓出', '弹性'];

const kParticlePalettePresets = {
  '暖金': ['#FBBF24', '#F59E0B', '#FDE68A', '#FCD34D', '#FEF3C7'],
  '青绿': ['#14B8A6', '#0F766E', '#5EEAD4', '#99F6E4', '#CCFBF1'],
  '紫韵': ['#A78BFA', '#7C3AED', '#C4B5FD', '#DDD6FE', '#EDE9FE'],
  '水墨': ['#334155', '#475569', '#64748B', '#94A3B8', '#CBD5E1'],
  '糖果': ['#F43F5E', '#FB923C', '#FACC15', '#34D399', '#60A5FA', '#C084FC'],
  '樱花': ['#FDA4AF', '#F9A8D4', '#FBCFE8', '#FCE7F3', '#FDF2F8'],
  '霓虹': ['#06B6D4', '#22D3EE', '#818CF8', '#A78BFA', '#38BDF8'],
  '日落': ['#F97316', '#FB923C', '#FBBF24', '#F59E0B', '#FCD34D'],
  '森林': ['#14532D', '#166534', '#22C55E', '#86EFAC', '#DCFCE7'],
  '海洋': ['#1E3A5F', '#1E40AF', '#3B82F6', '#93C5FD', '#DBEAFE'],
  '暮光': ['#4C1D95', '#7C3AED', '#C084FC', '#F59E0B', '#FDE68A'],
};
