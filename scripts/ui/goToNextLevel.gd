extends Button

func _on_pressed():
	SoundManager.playUiClickButton()
	GlobalInfo.goToNextLevel()
