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
	var players:Array<Array<Int>>;
	var newestID:Int;

	override public function create()
	{
		playerJoined = new FlxText(0, 30, 500, "History:\n");
		newestID = 0;
		var server = Network.registerSession(NetworkMode.SERVER, {ip: "0.0.0.0", port: 8888, flash_policy_file_port: 9999});
		server.addEventListener(NetworkEvent.CONNECTED, function(event:NetworkEvent)
		{
			playerJoined.text += "Player joined!\n";
			players.push([0, 0]);
		});
		server.addEventListener(NetworkEvent.MESSAGE_RECEIVED, function(event:NetworkEvent)
		{
			switch (event.data.case1)
			{
				case "player_joined":
					players[-1] = [event.data.location_x, event.data.location_y];
					server.send({case1: "new_player", players: players, playerID: newestID});
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
