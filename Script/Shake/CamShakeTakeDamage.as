// 定义了一个名为 UCamShakeTakeDamage 的摄像机震动类，继承自 ULegacyCameraShake
class UCamShakeTakeDamage : ULegacyCameraShake
{
	// ==================== 基本时间设置 ====================
	// 震荡效果的总持续时间（0.5秒） - 整个震动效果从开始到结束的时间
	default OscillationDuration = 0.5f;
	// 震荡效果的淡入时间（0.1秒） - 震动强度从0逐渐增强到最大值的时间
	default OscillationBlendInTime = 0.1f;
	// 震荡效果的淡出时间（0.4秒） - 震动强度从最大值逐渐减弱到0的时间
	default OscillationBlendOutTime = 0.4f;

	// ==================== 旋转震荡参数（控制相机角度抖动） ====================

	// 俯仰角（Pitch - 上下点头）震动设置
	default RotOscillation.Pitch.Amplitude = -2.282308f;									 // 震动幅度：负值表示向下震动更强烈
	default RotOscillation.Pitch.Frequency = 10.0f;											 // 震动频率：每秒震动10次（10Hz）
	default RotOscillation.Pitch.InitialOffset = EInitialOscillatorOffset::EOO_OffsetRandom; // 初始偏移随机：每次震动起始点不同，增加自然感
	default RotOscillation.Pitch.Waveform = EOscillatorWaveform::SineWave;					 // 震动波形：正弦波，平滑的周期性运动

	// 偏航角（Yaw - 左右摇头）震动设置 - 当前设置为无震动
	default RotOscillation.Yaw.Amplitude = 0.f; // 震动幅度为0：不在左右方向产生角度震动
	default RotOscillation.Yaw.Frequency = 0.f; // 震动频率为0：不进行左右震动
	default RotOscillation.Yaw.InitialOffset = EInitialOscillatorOffset::EOO_OffsetRandom;
	default RotOscillation.Yaw.Waveform = EOscillatorWaveform::SineWave;

	// 滚动角（Roll - 左右倾斜）震动设置
	default RotOscillation.Roll.Amplitude = 4.581119f;	// 震动幅度：相机左右倾斜的强度
	default RotOscillation.Roll.Frequency = 16.881689f; // 震动频率：每秒震动约16.88次，快速抖动效果
	default RotOscillation.Roll.InitialOffset = EInitialOscillatorOffset::EOO_OffsetRandom;
	default RotOscillation.Roll.Waveform = EOscillatorWaveform::SineWave;

	// ==================== 位置震荡参数（控制相机位置移动） ====================

	// X轴（左右水平移动）位置震动设置
	default LocOscillation.X.Amplitude = 4.133221f;	 // 震动幅度：相机左右移动的距离
	default LocOscillation.X.Frequency = 32.312283f; // 震动频率：每秒约32.31次，非常快速的抖动
	default LocOscillation.X.InitialOffset = EInitialOscillatorOffset::EOO_OffsetRandom;
	default LocOscillation.X.Waveform = EOscillatorWaveform::SineWave;

	// Y轴（前后移动）位置震动设置
	default LocOscillation.Y.Amplitude = 2.305766f;	 // 震动幅度：相机前后移动的距离
	default LocOscillation.Y.Frequency = 51.512878f; // 震动频率：每秒约51.51次，极快速的震动
	default LocOscillation.Y.InitialOffset = EInitialOscillatorOffset::EOO_OffsetRandom;
	default LocOscillation.Y.Waveform = EOscillatorWaveform::SineWave;

	// Z轴（上下垂直移动）位置震动设置 - 当前设置为无震动
	default LocOscillation.Z.Amplitude = 0.f; // 震动幅度为0：不在垂直方向产生位置移动
	default LocOscillation.Z.Frequency = 0.f; // 震动频率为0：不进行上下震动
	default LocOscillation.Z.InitialOffset = EInitialOscillatorOffset::EOO_OffsetRandom;
	default LocOscillation.Z.Waveform = EOscillatorWaveform::SineWave;
};