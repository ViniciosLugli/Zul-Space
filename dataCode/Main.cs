using Godot;
using System;

public class Main : Node{

	public const string Version = "1.3.1";

	private PackedScene Menu_Scene = (PackedScene)ResourceLoader.Load("res://mainScenes/Menu.tscn");
	private PackedScene ConfigMenu_Scene = (PackedScene)ResourceLoader.Load("res://mainScenes/ConfigMenu.tscn");
	private PackedScene Game_Scene = (PackedScene)ResourceLoader.Load("res://mainScenes/Game.tscn");
	private PackedScene Login_Scene = (PackedScene)ResourceLoader.Load("res://mainScenes/LoginPage.tscn");

	private bool musicOn = false;
	private string inOn = "";

	public bool Version_verified = false;
	public bool Config_verified = false;
	public string ServerVersion = "";	

	//User variables
	public string User_account = "";
	public uint User_zulcoins = 0;
	public string User_Name = "";
	public uint User_HighScore = 0;
	//config
	public sbyte Volume_master = 1;
	public string Quality_select = "low";
	//

	public override void _Ready(){
		OS.SetWindowSize(OS.GetWindowSize());
		Vector2 screen_size = OS.GetScreenSize(OS.GetCurrentScreen());
		Vector2 window_size = OS.GetWindowSize();
		Vector2 centered_pos = (screen_size - window_size) / 2;
		OS.SetWindowPosition(centered_pos);
		OS.WindowMaximized = true;
		GoToLogin();
	}

	public void GoToMenu(){
		if (!musicOn){
			musicOn = true;
			(GetNode("BackgroundSong") as AudioStreamPlayer).Play();
		}
		if(inOn == "menu"){return;}
		inOn = "menu";
		CallDeferred("add_child", Menu_Scene.Instance());
	}

	public void GoToConfigMenu(){
		if(!musicOn){
			musicOn = true;
			(GetNode("BackgroundSong") as AudioStreamPlayer).Play();
		}
		if(inOn == "configmenu"){return;}
		inOn = "configmenu";
		CallDeferred("add_child", ConfigMenu_Scene.Instance());
	}

	public void GoToGame(){
		if(musicOn){
			musicOn = false;
			(GetNode("BackgroundSong") as AudioStreamPlayer).Stop();
		}
		if(inOn == "game"){return;}
		inOn = "game";
		CallDeferred("add_child", Game_Scene.Instance());
	}

	public void GoToLogin(){
		if(musicOn){
			musicOn = false;
			(GetNode("BackgroundSong") as AudioStreamPlayer).Stop();
		}
		if(inOn == "Login"){return;}
		inOn = "Login";
		CallDeferred("add_child", Login_Scene.Instance());
	}

	public void msgexit(string msg, string title){
		OS.Alert(msg, title);
		GetTree().Quit();
	}
	
}
