package;

import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import networking.Network;
import networking.utils.NetworkEvent;
import networking.utils.NetworkMode;

class PlayState extends FlxState
{
	var serverStartedText:FlxText;
	var playerJoined:FlxText;
	var players:FlxTypedGroup<FlxSprite>;
	var newestID:Int;

	override public function create()
	{
		playerJoined = new FlxText(0, 30, 500, "History:\n");
		players = new FlxTypedGroup<FlxSprite>();
		newestID = 0;
		var server = Network.registerSession(NetworkMode.SERVER, {ip: "0.0.0.0", port: 8888, flash_policy_file_port: 9999});
		server.addEventListener(NetworkEvent.CONNECTED, function(event:NetworkEvent)
		{
			playerJoined.text += "Player joined!\n";
			players.add(new FlxSprite());
		});
		server.addEventListener(NetworkEvent.MESSAGE_RECEIVED, function(event:NetworkEvent)
		{
			switch (event.data.case1)
			{
				case "player_joined":
					var previousPlayers = players.members.slice(0, players.members.length - 1);
					trace("Previous players: " + previousPlayers);
					server.send({case1: "new_player", players1: previousPlayers, playerID: newestID});
					trace("Sended");
					newestID++;
			}
		});
		server.start();
		serverStartedText = new FlxText(0, 0, 500);
		serverStartedText.text = "Server started!";
		add(serverStartedText);
		add(playerJoined);
		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
