var app = require('express')();
var http = require('http').Server(app);



var gameManager = require("./gamesManager.js");
var gameRoom = require("./gameRoom.js");
var playa = require("./player.js");
var game = require("./game.js");

//give it the index name space so it is accessible by other scripts and we can export it to the modules
var index ={};
	index.currentGames = [];
	index.playerPool = [];
	index.io  = require('socket.io')(http);
	index.ss = require('socket.io-stream');
	index.path = require('path'); 
	index.wav = require('wav');
	index.fs = require("fs");
	
	
app.get('/', function(req, res){
  res.sendfile('play.html');
});



var fileWriter = null;
index.io.on('connection', function(socket){
//io.setMaxListeners(0);

  socket.on('chat message', function(msg){
   index.io.emit('chat message', msg);
  });
  
   
 index.ss(socket).on('file', function(stream, data,game_id) {
console.log("getting stream");
console.log(stream);
//index.io.emit('streamin',stream);
socket.emit('streamin', { audio: true, buffer: stream });
//index.ss(socket).emit("back",stream,stream);


});

index.io.on('close', function() {
  if (fileWriter != null) {
    fileWriter.end();
  }
  });
  
  //when a user connects, I want them to send me all their user information so I can create a new player object. 
  socket.on("user_information",function(info){
		//when the user sends me their user information lets create a new object. 
		var isPlayerHere = 	checkIfPlayerExistsInMap(info.user_id);
		if(isPlayerHere)
		{
			socket.emit("boot","");
		//	bootOtherPlayer(info.user_id);
		}
		
			//create new player
			var player =  new playa.playa();
			player.name = info.name;
			player.picture = info.picture;
			player.email = info.email;
			player.user_id = info.user_id;
		
			player.socket = socket;
			//map the player to my object array. 
			index.playerPool[String(info.user_id)] = player;
			socket.emit('player_in_pool', info.user_id);
		
	});

//when the client sends the "search game" command 
 socket.on("search_game",function(info)
  {
  
  function goToGame()
  {
		//player object and I am making it a pre existing player object that is in the pool.
		var p = index.playerPool[String(info.user_id)];
		//iterate through all open games. I want to find one that has not started and still has room for another player. 
		var my_game_id = getOpenGame();
		//the id of the game came back false meaning we cannot join a current game, so we have to create an object and add it to the array, then add the player to that game.
		if(!my_game_id)
		{
		// no current game make one and add to the list
			var ngame = new game.game();
			var id = getNewGameId();
			p.current_game_id = id;
			ngame.created = id;
			ngame.addPlayer(p);
			ngame.game_id = id;
	
			index.currentGames[String(id)] = ngame;
			var ng = index.currentGames[String(id)];
		
			socket.join(String(id));
			socket.emit("game_entered",id);
		}
		else{
			
			//otherwise the game does exist and we got one from the function so lets add someone to the game
			var g = index.currentGames[my_game_id];
			var isAdded = g.addPlayer(p);
			if(isAdded)
			{	
				p.current_game_id = my_game_id;
				socket.join(String(my_game_id));
				socket.emit("game_entered",g.created);
			}
			else
			{
				//if we find a new game and by some chance there is another device logged in with the same account we are going to just create a new game to avoid issues.
					var ngame = new game.game();
					var id = getNewGameId();
					p.current_game_id = id;
					ngame.created = id;
					ngame.addPlayer(p);
					ngame.game_id = id;
	
					index.currentGames[String(id)] = ngame;
					var ng = index.currentGames[String(id)];
		
					socket.join(String(id));
					socket.emit("game_entered",id);
			}
		
		}
}

	goToGame();
	});
	
socket.on("get_game_info",function(game_id)	
{
	//index.io.to(String(game_id)).emit('player_died',"D");
	//the client has connected to the game so now we want to get a list of all the current players in the game.
	//to populate the lobby
	var g = index.currentGames[String(game_id)];
	var curr_players = g.getCurrentPlayers();
	socket.emit("other_players",curr_players);
	});
	

	
//when user wants to leave game
socket.on("leave_game",function(game_information)
{
	var user_id = game_information.user_id;
	var game_id = game_information.game_id;
	var p = index.playerPool[String(user_id)];
	var g_id = p.current_game_id;
	var g = index.currentGames[String(game_id)];
	if(g)
	{
		g.removePlayer(user_id);
	}
		socket.leave(String(game_id));
	if(p)
	{
		p.leaveGame();
	}
});
	
//game is in motion and the player has now lost.
socket.on("u_lose",function(game_information)
{
	var user_id = game_information.user_id;
	var game_id = game_information.game_id;
	var p = index.playerPool[String(user_id)];
	var g_id = p.current_game_id;
	var g = index.currentGames[String(game_id)];
	if(g)
	{
		g.diePlayer(user_id);
	}
	socket.leave(String(game_id));
	p.leaveGame();
	

});
socket.on("utlimatum_done",function(game_information)
{
	socket.emit("ultimatum_met","");
	var user_id = game_information.user_id;
	var game_id = game_information.game_id;
	var g = index.currentGames[String(game_id)];
	g.meetUltimatum(user_id);
});
	
	
});
//checks for open games
function getOpenGame()
{
	//if there are no current games, lets return false so we can open a new game and then add the player to it.
	if(index.currentGames.length == 0)
	{
		return false;
	}
	else
	{
	//otherwise lets set the game id at zero(game id will be millis so it will never be zero)
		var game_id = 0;
		index.currentGames.forEach(function(game) {
		//Over here you get each player in the array

			//reference the games in the currentGames array. if the game is open, then break the loop and set the
			// game id as the game id of the game
			//checks if the game class has the open flag(It has not reached max players.
			if(game.gameIsOpen)
			{
				game_id = game.created;
				return true;
			}
		});
		//at the end of the loop if the game id is still zero(no open games), then we return false so we can add a new game.
		if(game_id == 0)
		{
			return false;
		}
		else
		{
		//other wise lets return the game id.
			return game_id;
		}
	}


}


http.listen(3000, function(){
  console.log('listening on *:3000');
});






//gives me a unique game id
function getNewGameId()
{
	var d = new Date();
	var n = d.getMilliseconds();
	if(gameExists(n))
	{
		getNewGameId();
	}
	else
	{
		return n;
	}
}

//exports the index class which holds all the players and all the current games
module.exports.index = index;


//going to check if player exists if he does we check if he is in a game that exists and deletes him everywhere
//if player exists chjeck if in game
//if in game if the player is still in game remove it)
function checkIfPlayerExistsInMap(user_id)
{
	var isPlayerHere = index.playerPool[String(user_id)];
	if(isPlayerHere)
	{
		var isPlayerInGame = isPlayerHere.is_in_game;
			if(isPlayerInGame)
			{
				var g_id = isPlayerHere.current_game_id;
				if(gameExists(g_id))
				{
					var g = index.currentGames[String(g_id)];
					if(g.is_playing)
					{
						g.diePlayer(user_id);
						isPlayerHere.socket.emit("leave_game_and_lobby_playing","no shake");
						isPlayerHere.socket.leave(String(g_id));
						p.leaveGame();
					}
					else
					{
						g.removePlayer(user_id);
						isPlayerHere.socket.emit("leave_game_and_lobby","no shake");
					}
						
				}
			
			}
			else
			{
				isPlayerHere.socket.emit("leave_lobby","no shake");
			}
		
		return true;
	}
	else
	{
		return false;
	}

}

//checks if game exists
function gameExists(game_id)
{
	var doesGame = index.currentGames[String(game_id)];
	
	return doesGame;

}

