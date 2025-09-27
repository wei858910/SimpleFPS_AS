// FPS动画实例类，继承自UAnimInstance
class UFPSAnimInstance : UAnimInstance
{
	// 存储上一帧的控制旋转，用于计算视角变化量
	private FRotator SwayOldRotation;

	// ==================== 蓝图可读变量 ====================
	UPROPERTY(BlueprintReadOnly)
	bool bIsInAir; // 角色是否在空中（跳跃/下落状态）

	UPROPERTY(BlueprintReadOnly)
	bool bIsMoving; // 角色是否在移动

	// 武器摇摆相关参数
	UPROPERTY(BlueprintReadOnly, Category = "Arm Sway")
	float MaxSwayRotation = 8.f; // 最大摇摆旋转角度（度）

	UPROPERTY(BlueprintReadOnly, Category = "Arm Sway")
	float SwaySpeed = 3.f; // 摇摆插值速度

	UPROPERTY(BlueprintReadOnly, Category = "Arm Sway")
	FRotator SwayDeltaRotation; // 计算出的旋转摇摆量（用于动画蓝图）

	UPROPERTY(BlueprintReadOnly, Category = "Arm Sway")
	FVector SwayDeltaTranslation; // 计算出的位移摇摆量（用于动画蓝图）

	// ==================== 武器摇摆计算函数 ====================
	UFUNCTION()
	void CalcWeaponSway(float DeltaTimeX)
	{
		// 获取所属的Pawn对象
		const APawn MyPawn = Cast<APawn>(TryGetPawnOwner());
		if (MyPawn == nullptr)
			return;

		// 1. 计算视角旋转变化引起的武器摇摆
		FRotator CharControlRotation = MyPawn.GetControlRotation(); // 获取当前控制器的旋转
		FRotator RawDelta = SwayOldRotation - CharControlRotation;	// 计算与上一帧的旋转差值
		RawDelta.Normalize();										// 规范化角度（保持在-180到180度范围内）

		// 使用插值平滑过渡摇摆效果
		SwayDeltaRotation = Math::RInterpTo(SwayDeltaRotation, RawDelta, DeltaTimeX, SwaySpeed);
		SwayOldRotation = CharControlRotation; // 更新为当前旋转，供下一帧使用

		// 特殊处理：将偏航角（Yaw）转换为滚转角（Roll），模拟真实武器倾斜效果
		// -1.35f是倾斜系数，MaxSwayRotation限制最大倾斜角度
		SwayDeltaRotation.Roll = Math::Clamp(SwayDeltaRotation.Yaw * -1.35f, MaxSwayRotation * -1.0f, MaxSwayRotation);

		// 2. 计算移动输入引起的武器位置摇摆
		// 获取移动输入向量并转换到角色局部空间
		FVector InputDirection = MyPawn.GetActorTransform().InverseTransformVectorNoScale(MyPawn.GetLastMovementInputVector());
		InputDirection.Normalize(); // 标准化向量

		// 应用摇摆系数：X轴反向0.5倍，Y轴反向0.55倍，Z轴1倍，整体放大6倍
		InputDirection = InputDirection * FVector(-0.50f, -0.55f, 1.0f) * 6.0f;

		// 使用线性插值平滑位置摇摆
		SwayDeltaTranslation = Math::Lerp(SwayDeltaTranslation, InputDirection, DeltaTimeX * SwaySpeed);
	}

	// ==================== 更新角色状态函数 ====================
	void UpdatePawnState()
	{
		const APawn MyPawn = Cast<APawn>(TryGetPawnOwner());
		if (MyPawn == nullptr)
			return;

		// 检测是否在空中（跳跃或下落状态）
		bIsInAir = MyPawn.GetMovementComponent().IsFalling();

		// 检测是否在移动（速度大于0）
		bIsMoving = MyPawn.GetVelocity().Size() > 0.f;
	}

	// ==================== 动画蓝图更新函数 ====================
	UFUNCTION(BlueprintOverride)
	void BlueprintUpdateAnimation(float DeltaTimeX)
	{
		// 每帧更新武器摇摆计算
		CalcWeaponSway(DeltaTimeX);

		// 每帧更新角色状态
		UpdatePawnState();
	}
};