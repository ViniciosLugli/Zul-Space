using Godot;
using System;

public class ParticlesExplosion : Particles2D{
	private bool is_exploded = false;
	public override void _Process(float delta){
		if(!this.Emitting){
			if(is_exploded) {return;}
			is_exploded = true;
			CallDeferred("free");
		}
	}
}
