using Godot;
using System;

public class Asteroid : RigidBody2D{

	[Signal]
	public delegate void asteroid_exploded_signal();
	[Signal]
	public delegate void score_changed();

	private PackedScene asteroid_small_scene = (PackedScene)ResourceLoader.Load("res://Objects/AsteroidSmall.tscn");
	private PackedScene explosion_particles_scene = (PackedScene)ResourceLoader.Load("res://Objects/ParticlesAsteroidExplosion.tscn");
	private PackedScene points_scored_scene = (PackedScene)ResourceLoader.Load("res://UI/PointsScored.tscn");

	private bool is_exploded = false;
	private byte score_value = 100;

	private Texture smallTexture;
	private Vector2 smallVector2;
	private Color ParticlesColor;


	public override void _Ready(){
		Camera2D main_cameraNode = (Camera2D)GetNode("/root/Main/Game/MainCamera");
		Connect("asteroid_exploded_signal", main_cameraNode, "asteroid_exploded");
		Label labelNode = (Label)GetNode("/root/Main/Game/GUI/MarginContainer/HBoxContainer/VBoxContainer/Score");
		Connect("score_changed", labelNode, "update_score");
	}

	public void explode(){
		if(is_exploded){return;}
		is_exploded = true;
		EmitSignal("asteroid_exploded_signal");
		EmitSignal("score_changed", score_value);
		_explosion_particles();
		_spawn_score();
		Random randomizer = new Random();
		_spawn_asteroid_smalls((byte)(randomizer.Next(3, 6)));
		CallDeferred("free");
	}

	private void _spawn_score(){
		Node2D points_scored = (Node2D)points_scored_scene.Instance();
		points_scored.GetNode<Label>("Label").Text = score_value.ToString();
		points_scored.Position = this.Position;
		GetParent().CallDeferred("add_child", points_scored);
	}

	private void _explosion_particles(){
		Particles2D explosion_particles = (Particles2D)explosion_particles_scene.Instance();
		explosion_particles.Position = this.Position;
		explosion_particles.ProcessMaterial.Set("color", ParticlesColor);
		explosion_particles.Emitting = true;
		GetParent().CallDeferred("add_child", explosion_particles);
	}
	private void _spawn_asteroid_smalls(byte num){
		for(int i = 0;i < num;i++){
			_spawn_asteroid_small();
		}
	}

	private void _spawn_asteroid_small(){
		RigidBody2D asteroid_small = (RigidBody2D)asteroid_small_scene.Instance();
		Random randomizer = new Random();
		asteroid_small.Position = this.Position;
		asteroid_small.AngularVelocity = randomizer.Next(-4, 4);
		asteroid_small.AngularDamp = 0;
		asteroid_small.LinearVelocity = new Vector2(((randomizer.Next(0, 2) == 0) ? -1 : 1) * randomizer.Next(250, 350), ((randomizer.Next(0, 2) == 0) ? -1 : 1) * randomizer.Next(250, 350));
		asteroid_small.LinearDamp = 0;
		asteroid_small.GetNode<Sprite>("Sprite").Texture = smallTexture;
		asteroid_small.GetNode<CollisionShape2D>("CollisionShape2D").Scale = smallVector2;
		asteroid_small.Set("ParticlesColor", ParticlesColor);
		GetParent().CallDeferred("add_child", asteroid_small);
	}

	private void _on_VisibilityNotifier2D_viewport_exited(object viewport){
		if(is_exploded){return;}
		is_exploded = true;
		CallDeferred("free");
	}

	private void _on_LifeTimer_timeout(){
		if(!is_exploded){
			is_exploded = true;
			CallDeferred("free");
		}
	}
}
