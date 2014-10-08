var database = require("./database.js");

var playa = function ()
{
	this.name;
	this.email;
	this.user_id;
	this.username;
	this.picture;
	this.high_score;
	this.best_time;
	this.is_in_game;
	this.is_playing;
	this.push_id;
	this.current_game_id;
	this.socket = new Object();
	

	this.joinGame = function(game_id)
	{
		this.is_in_game = true;
		this.current_game_id = game_id;
	}
	
	this.updateScore = function(gameId,score,time)
	{
	
	
	}
	
	
	this.playaLeft = function()
	{
		var self = this;
		self.socket.emit("player_died","DDD");
		console.log("tried");
	
	}
	
	this.leaveGame = function()
	{
		this.current_game_id = false;
		this.is_in_game = false;
	}
	
	this.sendIt = function()
	{
		this.socket.emit("prompt_user",0);
	}
	
	
	this.logFinalScore = function(game_id,score)
	{
	
	
	}
	
	this.notifyGameScore = function(gameScoreObject,islast)
	{
	
	var self = this;
		console.log("updating score");
		var position = 0;
		if(islast)
		{
			position = gameScoreObject.position;
		}
		var score = gameScoreObject.score;
		var time = gameScoreObject.time;
		var game_id = gameScoreObject.game_id;
		var game_place  = position;
		var uid = self.user_id;
		var game_type  = 2;
		var db = new database.database();
		db.setPlayer(self);
		db.connectDataBase();
		db.updateGame(game_id,uid,score,time,game_id,game_type,islast);
		
	}
	
	

	this.notifyNewRank = function(rank)
	{
	var self = this;
		if(self.is_in_game)
		{
			this.socket.emit("multi_rank",rank);
		}
	
	}
	


}
module.exports.playa = playa;