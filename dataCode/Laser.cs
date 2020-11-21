using Godot;
using System;

public class Laser : Area2D{

	public short projectile_speed = 1100;
	private byte color_type = 0;
	private bool is_exploded = false;
	public byte internal_lifes = 1;
	public Vector2 direction = new Vector2(0, -1);

	//Textures
	private Texture Blue_laser = (Texture)ResourceLoader.Load("res://dataFile/lasers/laserBlue16.png");
	private Texture Red_laser = (Texture)ResourceLoader.Load("res://dataFile/lasers/laserRed16.png");
	private Texture Green_laser = (Texture)ResourceLoader.Load("res://dataFile/lasers/laserGreen10.png");
	//

	 public override void _Ready(){
		if(color_type == 0){
			(GetNode("Sprite") as Sprite).Texture = Blue_laser;
			(GetNode("Sprite") as Sprite).Modulate = new Color(1, 1, 1.12f);
			(GetNode("Particles2D") as Particles2D).ProcessMaterial.Set("color", new Color("1eb1be"));
			internal_lifes = 1;
		}else if(color_type == 1){
			(GetNode("Sprite") as Sprite).Texture = Red_laser;
			(GetNode("Sprite") as Sprite).Modulate = new Color(1.12f, 1, 1);
			(GetNode("Particles2D") as Particles2D).ProcessMaterial.Set("color", new Color("913333"));
			internal_lifes = 2;
		}else if(color_type == 2){
			(GetNode("Sprite") as Sprite).Texture = Green_laser;
			(GetNode("Sprite") as Sprite).Modulate = new Color(1, 1.12f, 1);
			(GetNode("Particles2D") as Particles2D).ProcessMaterial.Set("color", new Color("5B9C2F"));
			internal_lifes = 2;
		}
	}

	public override void _PhysicsProcess(float _delta){
		this.Position += direction * projectile_speed * _delta;
	}

	private void _on_Laser_body_shape_entered(int body_id, Node body, int body_shape, int area_shape){
		if (!this.IsQueuedForDeletion() && body.IsInGroup("asteroids")){
			body.Call("explode");
			internal_lifes -= 1;
			if(internal_lifes == 0){
				if(!is_exploded){
					is_exploded = true;
					CallDeferred("free");
				}
			}
		}
	}

	private void _on_VisibilityNotifier2D_viewport_exited(object viewport){
		if(!is_exploded){
			is_exploded = true;
			CallDeferred("free");
		}
	}
}
