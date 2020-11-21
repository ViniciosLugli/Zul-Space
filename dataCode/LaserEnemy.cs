using Godot;
using System;

public class LaserEnemy : RigidBody2D{

	public short projectile_speed = 1200;
	private bool is_exploded = false;
	public Vector2 direction = new Vector2(0, 1);
	private uint initTime = (uint)OS.GetSystemTimeSecs();

	//Textures
	private Texture Green_laser = (Texture)ResourceLoader.Load("res://dataFile/lasers/laserGreen10.png");
	//

	 public override void _Ready(){
		(GetNode("Sprite") as Sprite).Texture = Green_laser;
		(GetNode("Sprite") as Sprite).Modulate = new Color(1, 1.12f, 1);
		(GetNode("Particles2D") as Particles2D).ProcessMaterial.Set("color", new Color("5B9C2F"));
	}

	public override void _PhysicsProcess(float _delta){
		this.Position += direction * projectile_speed * _delta;
	}

	public void explode(){
		if(is_exploded){return;}
		is_exploded = true;
		CallDeferred("free");
	}

	private void _on_VisibilityNotifier2D_viewport_exited(object viewport){
		if(!is_exploded && (((uint)OS.GetSystemTimeSecs() - initTime) > 1)){
			is_exploded = true;
			CallDeferred("free");
		}
	}

	private void _on_LifeTimer_timeout(){
		if(!is_exploded){
			is_exploded = true;
			CallDeferred("free");
		}
	}
}
