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
};