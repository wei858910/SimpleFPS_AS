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

	void Fire()
	{
		check(ProjectileClass != nullptr, "ProjectileClass is nullptr");

		FVector MuzzleLocation = GunMeshComponent.GetSocketLocation(n"Muzzle");
		FRotator MuzzleRotation = GetControlRotation();

		SpawnActor(ProjectileClass, MuzzleLocation, MuzzleRotation);

		check(FireSound != nullptr, "FireSound is nullptr");

		Gameplay::PlaySoundAtLocation(FireSound, MuzzleLocation, MuzzleRotation);

		check(MuzzleFlash != nullptr, "MuzzleFlash is nullptr");
		Gameplay::SpawnEmitterAttached(MuzzleFlash, GunMeshComponent, n"Muzzle");
	}
};