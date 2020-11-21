using Godot;
using System;

public class Score : Label{
	public uint score_1 = 0;
	public void update_score(uint points_scored){
		uint score_0 = score_1;
		score_0 += (points_scored / 50);
		score_1 = score_0;
		this.Text = (score_0 * 50).ToString();
	}

	public void reset(){
		score_1 = 0;
		this.Text = "0";
	}
}
