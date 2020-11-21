using Godot;
using System;

public class AsteroidSpawner : Node{

	private PackedScene asteroid_scene = (PackedScene)ResourceLoader.Load("res://Objects/Asteroid.tscn");
	private const byte asteroid_spawn_interval = 2;
	private float difficulty_index = 1.20f;
	private RigidBody2D asteroid;

	//Grey asteroids:
	////Big and Medium
	Texture[] tempGreyAsteroids = new Texture[]{
		(Texture)ResourceLoader.Load("res://dataFile/obstacles/asteroidsGrey0.png"),
		(Texture)ResourceLoader.Load("res://dataFile/obstacles/asteroidsGrey1.png"),
		(Texture)ResourceLoader.Load("res://dataFile/obstacles/asteroidsGrey2.png"),
		(Texture)ResourceLoader.Load("res://dataFile/obstacles/asteroidsGrey3.png")
	};
	////Small
	Texture[] tempSmallGreyAsteroids = new Texture[]{
		(Texture)ResourceLoader.Load("res://dataFile/obstacles/smallAsteroidsGrey2.png"),
		(Texture)ResourceLoader.Load("res://dataFile/obstacles/smallAsteroidsGrey3.png")
	};
	//

	//Brown asteroids:
	//Big and Medium
	Texture[] tempBrownAsteroids = new Texture[]{
		(Texture)ResourceLoader.Load("res://dataFile/obstacles/asteroidsBrown0.png"),
		(Texture)ResourceLoader.Load("res://dataFile/obstacles/asteroidsBrown1.png"),
		(Texture)ResourceLoader.Load("res://dataFile/obstacles/asteroidsBrown2.png"),
		(Texture)ResourceLoader.Load("res://dataFile/obstacles/asteroidsBrown3.png")
	};
	////Small
	Texture[] tempSmallBrownAsteroids = new Texture[]{
		(Texture)ResourceLoader.Load("res://dataFile/obstacles/smallAsteroidsBrown2.png"),
		(Texture)ResourceLoader.Load("res://dataFile/obstacles/smallAsteroidsBrown3.png")
	};
	//

	//Sizes for RigidBody2D collision:
	////Big
	private Vector2[] BigSize = new Vector2[]{
		new Vector2(0.90f, 0.80f),
		new Vector2(1.00f, 0.85f),
		new Vector2(0.80f, 0.75f),
		new Vector2(0.88f, 0.88f)
	};
	////Small
	private Vector2[] SmallSize = new Vector2[]{
		new Vector2(1.60f, 1.5f),
		new Vector2(1.00f, 1.00f),
		new Vector2(1.00f, 1.00f)
	};
	//

	//Color
	private Color GreyColor = new Color("9AAAB1");
	private Color BrownColor = new Color("997055");
	//

	public override void _Ready(){
		_spawn_asteroid();
	}
	
	private void _spawn_asteroid(){
		Random randomizer = new Random();
		if (randomizer.Next(2) == 0){
			asteroid = (RigidBody2D)asteroid_scene.Instance();
			byte IndexRandom = (byte)randomizer.Next(tempGreyAsteroids.Length);
			asteroid.GetNode<Sprite>("Sprite").Texture = tempGreyAsteroids[IndexRandom];
			asteroid.GetNode<CollisionShape2D>("CollisionShape2D").Scale = BigSize[IndexRandom];
			IndexRandom = (byte)randomizer.Next(tempSmallGreyAsteroids.Length);
			asteroid.Set("smallTexture", tempSmallGreyAsteroids[IndexRandom]);
			asteroid.Set("ParticlesColor", GreyColor);
			asteroid.Set("smallVector2", SmallSize[IndexRandom]);
		}else{
			asteroid = (RigidBody2D)asteroid_scene.Instance();
			byte IndexRandom = (byte)randomizer.Next(tempBrownAsteroids.Length);
			asteroid.GetNode<Sprite>("Sprite").Texture = tempBrownAsteroids[IndexRandom];
			asteroid.GetNode<CollisionShape2D>("CollisionShape2D").Scale = BigSize[IndexRandom];
			IndexRandom = (byte)randomizer.Next(tempSmallBrownAsteroids.Length);
			asteroid.Set("smallTexture", tempSmallBrownAsteroids[IndexRandom]);
			asteroid.Set("ParticlesColor", BrownColor);
			asteroid.Set("smallVector2", SmallSize[IndexRandom]);
		}
		asteroid.Position = new Vector2(10, -100);
		Vector2 ScreenRect = GetViewport().Size;
		
		asteroid.Position = new Vector2(randomizer.Next((int)(ScreenRect.x / 12), (int)(ScreenRect.x - (ScreenRect.x / 12))), -100);
		asteroid.AngularVelocity = randomizer.Next(-3, 3);
		asteroid.AngularDamp = 0;
		asteroid.LinearVelocity = new Vector2(randomizer.Next(-300, 300), randomizer.Next(280, 420));
		CallDeferred("add_child", asteroid);
	}

	private void _on_SpawnTimer_timeout(){
		_spawn_asteroid();
	}

	private void _on_DifficultyTimer_timeout(){
		if ((float)asteroid_spawn_interval / difficulty_index < 0.30){
			(GetNode("SpawnTimer") as Timer).WaitTime = 0.35f;
		}else{
			(GetNode("SpawnTimer") as Timer).WaitTime = (float)asteroid_spawn_interval / difficulty_index;
			difficulty_index += 0.9f;
		}
	}
}
