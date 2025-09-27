class AFPSPlayerController : APlayerController
{
	// Input
	UPROPERTY(EditDefaultsOnly, Category = "Input")
	UInputMappingContext DefaultInputMapping;

	UPROPERTY(EditDefaultsOnly, Category = "Input")
	UInputAction Input_Move;

	UPROPERTY(EditDefaultsOnly, Category = "Input")
	UInputAction Input_Look;

	UPROPERTY(EditDefaultsOnly, Category = "Input")
	UInputAction Input_Jump;

	UPROPERTY(EditDefaultsOnly, Category = "Input")
	UInputAction Input_Fire;

	UEnhancedInputComponent InputComponent;

	UFUNCTION(BlueprintOverride)
	void BeginPlay()
	{
		InitEnhancedInputComponent();
		BindAction();
	}

	void InitEnhancedInputComponent()
	{
		check(DefaultInputMapping != nullptr);

		InputComponent = UEnhancedInputComponent::Create(this);
		PushInputComponent(InputComponent);

		UEnhancedInputLocalPlayerSubsystem EnhancedInputSubsystem = UEnhancedInputLocalPlayerSubsystem::Get(this);
		EnhancedInputSubsystem.AddMappingContext(DefaultInputMapping, 0, FModifyContextOptions());
	}

	void BindAction()
	{
		check(InputComponent != nullptr);

		check(Input_Move != nullptr);
		InputComponent.BindAction(Input_Move, ETriggerEvent::Triggered, FEnhancedInputActionHandlerDynamicSignature(this, n"MoveInput"));

		check(Input_Look != nullptr);
		InputComponent.BindAction(Input_Look, ETriggerEvent::Triggered, FEnhancedInputActionHandlerDynamicSignature(this, n"LookInput"));

		check(Input_Jump != nullptr);
		InputComponent.BindAction(Input_Jump, ETriggerEvent::Triggered, FEnhancedInputActionHandlerDynamicSignature(this, n"JumpInput"));

		check(Input_Fire != nullptr);
		InputComponent.BindAction(Input_Fire, ETriggerEvent::Triggered, FEnhancedInputActionHandlerDynamicSignature(this, n"FireInput"));
	}

	UFUNCTION()
	private void MoveInput(FInputActionValue ActionValue, float32 ElapsedTime, float32 TriggeredTime, const UInputAction SourceAction)
	{
		FVector2D MoveValue = ActionValue.GetAxis2D();
		AFPSCharacter FPSCharacter = Cast<AFPSCharacter>(GetControlledPawn());
		if (IsValid(FPSCharacter))
		{
			FPSCharacter.AddMovementInput(GetActorForwardVector(), MoveValue.X);
			FPSCharacter.AddMovementInput(GetActorRightVector(), MoveValue.Y);
		}
	}

	UFUNCTION()
	private void LookInput(FInputActionValue ActionValue, float32 ElapsedTime, float32 TriggeredTime, const UInputAction SourceAction)
	{
		FVector2D LookValue = ActionValue.GetAxis2D();
		// Print(LookValue.ToString());
		AFPSCharacter FPSCharacter = Cast<AFPSCharacter>(GetControlledPawn());
		if (IsValid(FPSCharacter))
		{
			FPSCharacter.AddControllerYawInput(LookValue.X);
			FPSCharacter.AddControllerPitchInput(LookValue.Y);
		}
	}

	UFUNCTION()
	private void JumpInput(FInputActionValue ActionValue, float32 ElapsedTime, float32 TriggeredTime, const UInputAction SourceAction)
	{
		AFPSCharacter FPSCharacter = Cast<AFPSCharacter>(GetControlledPawn());
		if (IsValid(FPSCharacter))
		{
			FPSCharacter.Jump();
		}
	}

	UFUNCTION()
	private void FireInput(FInputActionValue ActionValue, float32 ElapsedTime, float32 TriggeredTime, const UInputAction SourceAction)
	{
		AFPSCharacter FPSCharacter = Cast<AFPSCharacter>(GetControlledPawn());
		if (IsValid(FPSCharacter))
		{
			FPSCharacter.Fire();
		}
	}
};