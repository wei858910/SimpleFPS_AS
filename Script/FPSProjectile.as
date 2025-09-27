class AFPSProjectile : AActor
{
	UPROPERTY(DefaultComponent, RootComponent, Category = "Components")
	protected USphereComponent CollisionComp;
	default CollisionComp.SetSphereRadius(20.0f);
	default CollisionComp.SetCollisionProfileName(n"Projectile");
	default CollisionComp.SetWalkableSlopeOverride(FWalkableSlopeOverride());
	default CollisionComp.CanCharacterStepUpOn = ECanBeCharacterBase::ECB_No;

	UPROPERTY(DefaultComponent, Category = "Components")
	protected UProjectileMovementComponent ProjectileMovement;
	default ProjectileMovement.SetUpdatedComponent(CollisionComp);
	default ProjectileMovement.InitialSpeed = 6000.f;
	// 最大速度为0.f（无限制）
	default ProjectileMovement.MaxSpeed = 0.f;
	default ProjectileMovement.bRotationFollowsVelocity = true;
	// 开启弹跳效果
	default ProjectileMovement.bShouldBounce = true;
	default ProjectileMovement.ProjectileGravityScale = 0.5f;

	UPROPERTY(EditDefaultsOnly, Category = "Movement")
	protected UParticleSystem ExplosionFX;

	UFUNCTION(BlueprintOverride)
	void BeginPlay()
	{
		System::SetTimer(this, n"Explode", 3.f, false);
	}

	UFUNCTION()
	protected void Explode()
	{
		check(ExplosionFX != nullptr, "AFPSProjectile ExplosionFX is nullptr");
		Gameplay::SpawnEmitterAtLocation(ExplosionFX, GetActorLocation(), FRotator::ZeroRotator, FVector(5.f));

		// 播放世界范围内的相机抖动效果
		// 参数说明：
		// 1. UCamShakeTakeDamage - 相机抖动效果类，定义了受伤时的震动效果
		// 2. GetActorLocation() - 震动源位置
		// 3. 500.f - 震动影响范围的内半径  在此距离内的摄像机会受到完整强度的震动效果
		// 4. 3000.f - 从内半径到外半径，震动强度会逐渐衰减，超出此距离后震动强度为0
		Gameplay::PlayWorldCameraShake(UCamShakeTakeDamage, GetActorLocation(), 500.f, 3000.f);

		DestroyActor();
	}

	UFUNCTION(BlueprintOverride)
	void ConstructionScript()
	{
		CollisionComp.OnComponentHit.AddUFunction(this, n"OnHit");
	}

	UFUNCTION()
	private void OnHit(UPrimitiveComponent HitComponent, AActor OtherActor, UPrimitiveComponent OtherComp, FVector NormalImpulse, const FHitResult&in Hit)
	{
		if (IsValid(OtherActor) && OtherActor != this && IsValid(OtherComp) && OtherComp.IsSimulatingPhysics())
		{
			float RandomIntensity = Math::RandRange(200.f, 500.f);
			OtherComp.AddImpulseAtLocation(GetVelocity() * RandomIntensity, GetActorLocation());

			FVector Scale = OtherActor.GetActorScale3D();
			Scale *= 0.8f;
			if (Scale.GetMin() < 0.5f)
			{
				OtherActor.DestroyActor();
			}
			else
			{
				OtherActor.SetActorScale3D(Scale);
			}

			UMaterialInstanceDynamic MatInst = OtherComp.CreateDynamicMaterialInstance(0);
			if (IsValid(MatInst))
			{
				MatInst.SetVectorParameterValue(n"Color", FLinearColor::MakeRandomColor());
			}

			Explode();
		}
	}

	USphereComponent GetCollisioncomp() const
	{
		return CollisionComp;
	}

	UProjectileMovementComponent GetProjectileMovement() const
	{
		return ProjectileMovement;
	}
};