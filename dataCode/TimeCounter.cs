using Godot;
using System;

public class TimeCounter : Label{
	private uint time_start = 0;
	private uint time_now = 0;
	private bool run = false;

	public override void _Ready(){
		time_start = (uint)OS.GetSystemTimeSecs();
	}

	 public override void _Process(float delta){
		if(run){
			time_now = (uint)OS.GetSystemTimeSecs();
			uint elapsed = time_now - time_start;
			string str_elapsed = (elapsed / 60).ToString("D2") + ":"+ (elapsed % 60).ToString("D2");
			this.Text = str_elapsed;
		}
	}

	public void reset(){
		time_start = (uint)OS.GetSystemTimeSecs();
	}
}
