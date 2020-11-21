using Godot;
using System;

public class AsteroidSmall : RigidBody2D{

	[Signal]
	public delegate void score_changed();

	private PackedScene explosion_particles_sceneSmall = (PackedScene)ResourceLoader.Load("res://Objects/ParticlesAsteroidExplosionSmall.tscn");
	private PackedScene points_scored_scene = (PackedScene)ResourceLoader.Load("res://UI/PointsScored.tscn");

	private bool is_exploded = false;
	private byte score_value = 50;
	private Color ParticlesColor;

	public override void _Ready(){
		Label labelNode = (Label)GetNode("/root/Main/Game/GUI/MarginContainer/HBoxContainer/VBoxContainer/Score");
		Connect("score_changed", labelNode, "update_score");
	}

	private void _spawn_score(){
		Node2D points_scored = (Node2D)points_scored_scene.Instance();
		points_scored.GetNode<Label>("Label").Text = score_value.ToString();
		points_scored.Position = this.Position;
		GetParent().CallDeferred("add_child", points_scored);
	}

	private void _explosion_particles(){
		Particles2D explosion_particles = (Particles2D)explosion_particles_sceneSmall.Instance();
		explosion_particles.Position = this.Position;
		explosion_particles.ProcessMaterial.Set("color", ParticlesColor);
		explosion_particles.Emitting = true;
		GetParent().CallDeferred("add_child", explosion_particles);
	}

	public void explode(){
		if (is_exploded){return;}
		is_exploded = true;
		EmitSignal("score_changed", score_value);
		_explosion_particles();
		_spawn_score();
		CallDeferred("free");
	}

	private void _on_VisibilityNotifier2D_viewport_exited(object viewport){
		if(!is_exploded){
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
