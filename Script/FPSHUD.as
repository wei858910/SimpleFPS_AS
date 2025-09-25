class AFPSHUD : AHUD
{
	UPROPERTY()
	UTexture2D CrosshairTex = nullptr;

	UFUNCTION(BlueprintOverride)
	void ConstructionScript()
	{
		CrosshairTex = Cast<UTexture2D>(LoadObject(nullptr, "/Game/UI/FirstPersonCrosshair.FirstPersonCrosshair"));
	}

	UFUNCTION(BlueprintOverride)
	void DrawHUD(int SizeX, int SizeY)
	{
		check(CrosshairTex == nullptr);

		const FVector2D Center(SizeX * 0.5, SizeY * 0.5);

		const FVector2D CrosshairDrawPosition(Center.X - 8, Center.Y - 8);

		DrawTextureSimple(CrosshairTex, CrosshairDrawPosition.X, CrosshairDrawPosition.Y);
	}
};