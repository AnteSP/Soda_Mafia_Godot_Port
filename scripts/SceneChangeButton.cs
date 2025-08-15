using Godot;
using System;

public partial class SceneChangeButton : Button
{
	public override void _EnterTree() => Pressed += OnButtonPressed;
	public override void _ExitTree() => Pressed -= OnButtonPressed;
	private void OnButtonPressed() => GetTree().ChangeSceneToFile("res://playable.tscn");
}
