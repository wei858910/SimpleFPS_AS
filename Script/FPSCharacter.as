class AFPSCharacter : ACharacter
{
	// Camera
	UPROPERTY(DefaultComponent, BlueprintReadOnly, Category = "Camera")
	UCameraComponent CameraComponent;

	default CameraComponent.bUsePawnControlRotation = true;

	// Mesh
	UPROPERTY(DefaultComponent, BlueprintReadOnly, Attach = CameraComponent, Category = "Mesh")
	USkeletalMeshComponent Mesh1PCompoent;

	UPROPERTY(DefaultComponent, BlueprintReadOnly, Attach = Mesh1PCompoent, AttachSocket = "GripPoint", Category = "Mesh")
	USkeletalMeshComponent GunMeshComponent;

	UPROPERTY(EditDefaultsOnly, Category = "Projectile")
	TSubclassOf<AFPSProjectile> ProjectileClass;

	UPROPERTY(EditDefaultsOnly, Category = "Projectile")
	USoundBase FireSound;

	UPROPERTY(EditDefaultsOnly, Category = "Projectile")
	UParticleSystem MuzzleFlash;

	UPROPERTY(EditDefaultsOnly, Category = "Camera")
	TSubclassOf<UCameraShakeBase> LandedCameraShake;

	UPROPERTY(EditDefaultsOnly, Category = "Camera")
	TSubclassOf<UCameraShakeBase> JumpCameraShake;

	UPROPERTY(EditDefaultsOnly, Category = "Gameplay")
	UAnimSequence FireAnimation;

	void Fire()
	{
		check(ProjectileClass != nullptr, "ProjectileClass is nullptr");

		FVector MuzzleLocation = GunMeshComponent.GetSocketLocation(n"Muzzle");
		FRotator MuzzleRotation = GetControlRotation();

		SpawnActor(ProjectileClass, MuzzleLocation, MuzzleRotation);

		check(FireSound != nullptr, "FireSound is nullptr");
		Gameplay::PlaySoundAtLocation(FireSound, MuzzleLocation, MuzzleRotation);

		check(FireAnimation != nullptr, "FireAnimation is nullptr");
		UAnimInstance AnimInstance = Mesh1PCompoent.GetAnimInstance();
		if (IsValid(AnimInstance))
		{
			// 以动态蒙太奇方式播放开火动画
			AnimInstance.PlaySlotAnimationAsDynamicMontage(
				FireAnimation, // 开火动画资源
				n"Arms",	   // 动画插槽名称（手臂插槽）
				0.f			   // 混合时间（立即混合）
			);
		}

		check(MuzzleFlash != nullptr, "MuzzleFlash is nullptr");
		Gameplay::SpawnEmitterAttached(MuzzleFlash, GunMeshComponent, n"Muzzle");
	}

	UFUNCTION(BlueprintOverride)
	void OnLanded(FHitResult Hit)
	{
		check(LandedCameraShake != nullptr);
		AFPSPlayerController PC = Cast<AFPSPlayerController>(GetController());
		if (IsValid(PC))
		{
			PC.PlayerCameraManager.StartCameraShake(LandedCameraShake);
		}
	}

	UFUNCTION(BlueprintOverride)
	void OnJumped()
	{
		check(JumpCameraShake != nullptr);
		AFPSPlayerController PC = Cast<AFPSPlayerController>(GetController());
		if (IsValid(PC))
		{
			PC.PlayerCameraManager.StartCameraShake(JumpCameraShake);
		}
	}
};