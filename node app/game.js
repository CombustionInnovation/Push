//creates a sudo person class to avoid stack size error
var per = function()
{
	this.name;
	this.user_id;
	this.picture;
	this.email;
	this.username;
}

//inports index and player.
var index = require("./index.js");

var game = function(){
	this.playa = require("./player.js");
	this.max_players = 4;
	this.min_players = 2;
	this.is_playing = false;
	this.gameIsOpen = true;
	this.current_game_time = 0;
	this.game_id;
	this.current_players = new Object();
	this.current_players_Array = new Array();
	this.created;
	this.game_ticker = null;
	this.lookup = {};
	this.io;
	this.countDownToGameTimer = false;
	this.gameWillStartTimer = false;
	this.gamePlayersDuringGame = 0;
	this.countUpTimer =false;
	this.ult = false;
	this.current_game_score = 0;
	this.current_game_interval_tick =0;
	this.score_incrementer = 0;
	
	
	this.addPlayer = function(playa)
	{

	//if the amount of players is less than the maximum allotted players.
		if(this.current_players_Array.length< this.max_players && this.gameIsOpen && !this.is_playing && !this.current_players[playa.user_id.toString()])
		{
			//creates a new per object and adds to graph.
			
			playa.is_in_game = true;
			var d = new per();
			d.name = playa.name;
			d.user_id = playa.user_id;
			d.picture = playa.picture;
			d.email = playa.email;
			d.username = playa.name;
			
			//adds the current player object to the object
			this.current_players[String(d.user_id)]= d;
		
			//adds the person to the array, so we can loop through them and we can keep track of our players.
			this.current_players_Array.push(this.current_players[String(d.user_id)]);
			
			console.log(this.current_players[String(d.user_id)]);
			
			
			var self = this;
			for(var i=0;i< this.current_players_Array.length;i++)
			{
				//gets the user id of all the players. if it does not match the new players id lets notify them of
				//a new player
				var id = self.current_players_Array[i]["user_id"];
				var da = self.current_players_Array[i];
				if(id != d.user_id)
				{
					console.log(id);
					//send the notification to everyone
				
				}
			}
				
				
				
					console.log("the game id is " + self.created); 
					self.send_playerNotification(id,d);
					
				//checks if we can start the lobby countdown and checks if we can close the game
					self.checkIfClosed();
					
					setTimeout(function(){
						self.checkGameCountdown();
					},500);
					
					
					
					return true;
				
		}
		else
		{
			return false;
			console.log("could not connect");
		}
	
			
		
	}
	
	//a new player has been added to lobby before game start
	this.send_playerNotification = function(id,d)
	{
		var self = this;
		console.log(id + "ashoud haCW sent");
		//this sends a notification to all current players that a new player has joined the lobby
		//var p = index.index.playerPool[id];
		index.index.io.to(self.created.toString()).emit('curr_players',d);
	}

	//gets an array of all the current players
	this.getCurrentPlayers = function()
	{
		//gets the array of current_players
		var self = this;
		return self.current_players_Array;
	}
	
	//removes a player when we are still in the lobby
	this.removePlayer = function(player_id)
	{
		//remove them from the player list && perform search for game again.
		var self = this;
		//deletes player by object id
		var idGoodBye = 0;
		for(var i=0;i< self.current_players_Array.length;i++)
		{

			var id = self.current_players_Array[i]["user_id"];
			if(id == player_id)
			{
				//splice thje array and get rid of that person
				console.log(id);
				idGoodBye = i;
			}
			else
			{
				console.log("the player leaviing is "  + player_id);
				console.log("player noti is " + id);
				//send a notification to the others that the player has left
				self.sendPlayerLeftNotification(id,player_id);
			}
		
		}
		//wait until the loop is over before splicing other wise it stops our loop and we wont be able to notify everyone
		self.current_players_Array.splice(idGoodBye,1);
		var pid = self.current_players[player_id];
		if(pid)
		{
			delete self.current_players[player_id];
		}
	
		//makes the game open
		self.gameIsOpen = true;
		//if there are no more players, close the room
		if(this.current_players_Array.length == 0)
		{
			self.gameIsNowOver();
			self.gameIsOpen = false;
		}
		
		//check if the countdown timer can start. 
		//check if the maximum number of players are in the room

		 this.playerHasLeft();
	}
	
	//player left noticiation to all players to remove them crmo the lobby UI
	this.sendPlayerLeftNotification = function(my_id,player_id_leaving)
	{
			//let other players know that the player has left so game updates.
			var p = index.index.playerPool[String(my_id)];
		    p.socket.emit("player_left",player_id_leaving);	
	}
	
	
	

	this.playerHasLeft = function()
	{
			var self = this;
			if(!this.is_playing)
			{
				self.gameIsOpen = true;
				
				//if the number of current minimum players is greater than number of players check lobby to stop timer
				if(self.min_players > self.current_players_Array.length)
				{
					self.countDownToGameHasCanceled();
				}
			}
	}
	
	
	//checks if the game cane start
	this.checkIfCanStart = function()
	{
		var self = this;
		if(this.min_players <= this.current_players_Array.length)
		{

		}
	
	}
	
	//checks if the max amount of people have been added
	this.checkIfClosed = function()
	{
		 var self = this;
		//checks if the maxium amount of players is in the game
		if(this.max_players <= this.current_players_Array.length)
		{
			self.gameIsOpen = false;
		}
		else
		{
			self.gameIsOpen = true;
		}
	
	
	}
	
	//checks if there is enough people to play if there is lets start the game timer . send the players a notification that the timer is about to start
	//initialize the game lobby timer
	this.checkGameCountdown = function()
	{
		var self = this;
				if(this.current_players_Array.length >= this.min_players)
				{
					if(!self.countDownToGameTimer  && !self.is_playing)
					{
						self.countDownToGameTimer = new prettyTimer();
						self.countDownToGameTimer.game = self;
						self.countDownToGameTimer.startCountDown();
				
						index.index.io.to(self.created.toString()).emit('lobby_timer_started',"");
						
					}
				}
	
	}
	
	
	//lobby timer
	//this is a call back function from the pretty timer class that happens everytime the timer is ticked
	//when the timer ticks, the players get a notification.
	this.CountDownToGameHasTicked = function(timeleft)
	{
			var self = this;
	//		console.log(timeleft);
	
			index.index.io.to(self.created.toString()).emit('lobby_timer_ticked',timeleft);
	
	}
	
	//the timer is ended successfully and there is still enough people to play (two);.. time to bring them to the game screen
	this.countDownToGameHasEnded = function()
	{
			var self = this;
			if(self.countDownToGameTimer)
			{
				clearInterval(self.countDownToGameTimer.interval);
				clearImmediate(self.countDownToGameTimer.interval);
				self.countDownToGameTimer = null;
				
			}
			//gameisinmotion
			self.gameIsOpen = false;
			self.is_playing = true;
			
			self.gamePlayersDuringGame = self.current_players_Array.length;
			
			index.index.io.to(self.created.toString()).emit('game_will_start',"");
		//start game operations in the actual game room
		//at this point if people leave we do not re start the game lobby, they just lose
		
			self.startGameOperations();
		
		
	}
	
	//something happened such as the number of players is not enough (only one player left), so lets cancel the timer and let the player wait for more people
	this.countDownToGameHasCanceled = function()
	{
		
			var self = this;
			if(self.countDownToGameTimer)
			{
				clearInterval(self.countDownToGameTimer.interval);
				clearImmediate(self.countDownToGameTimer.interval);
				self.countDownToGameTimer = null;
			}
			

			index.index.io.to(self.created.toString()).emit('lobby_timer_canceled',"");
	}


	//game start operations
	 this.startGameOperations = function()
	 {				
					var self = this;
					if(!self.gameWillStartTimer)
					{
						self.gameWillStartTimer = new prettyGameTimer();
						self.gameWillStartTimer.game = self;
						self.gameWillStartTimer.startCountDown();
					}
	 
	 
	 }
	 
	 this.CountDownToStartHasTicked = function(tleft)
	 {
		var self = this;
		index.index.io.to(self.created.toString()).emit('gameStartTimerHasTicked',tleft);
	 }
	 
	 
	this.countDownToStartHasEnded = function()
	{
			var self = this;
			if(self.gameWillStartTimer)
			{
				clearInterval(self.gameWillStartTimer.interval);
				clearImmediate(self.gameWillStartTimer.interval);
				self.gameWillStartTimer = null;
			}
	
			
			//start the game and start the count up timer
			index.index.io.to(self.created.toString()).emit('s_game',"");
			self.startUpTimer();
	
	
		//	setInterval(function(){
		//			index.index.io.to(self.created.toString()).emit('stfu',"");
		//	},1000);
	
	}
	
	
	//gameupwards timer so we know how much time has been passed
	
	this.startUpTimer = function()
	{
		var upT = this.countUpTimer;
		var self =  this;
		if(!this.countUpTimer)
		{
			self.countUpTimer = new countUpTimer();
			self.countUpTimer.game = self;
			self.countUpTimer.gameStart = self.created;
			self.countUpTimer.startTicking();
			//creates new shake ultimatum.
			self.ult = new ultimatum();
			self.ult.game = this;
			for(var i = 0;i < self.current_players_Array.length;i++)
			{
				self.ult.players.push(self.current_players_Array[i]);
			}
			self.ult.setNextChoice();
			console.log("cometopass");
		}
	
	}
	
	//the game timer has ticked
	this.upTimerTicked = function(timeObj)
	{
		var self = this;
		//for every second we get the score incrementer to get greater so when the player looses we can get the score
		this.current_game_interval_tick++;
		if(this.current_game_interval_tick > 9)
		{
		
			
			self.current_game_interval_tick = 0;
			self.current_game_score++;
		}
		
		//if the score incrementer reaches ten seconds we want to update game progress real time
		self.score_incrementer++;
		if(self.score_incrementer > 100)
		{
				for(var i=0;i<self.current_players_Array.length;i++)
			{
					var id = self.current_players_Array[i]["user_id"];
					self.notifyPlayerScore(id,false);	
			}
			self.score_incrementer = 0;
		}
		
		
		//console.log("TICK");
		index.index.io.to(self.created.toString()).emit('upTimerClicked',timeObj);
	}
	//starts the ultimatum
	this.UltimatiumWillStart = function()
	{
		var self = this;
		index.index.io.to(self.created.toString()).emit("utlimatum_will_start","");
	
	}
	
	//a player shook the damn thing
	this.meetUltimatum = function(player_id)
	{
		var self = this;
		if(self.ult)
		{
			self.ult.playerMetRequirements(player_id);
			console.log(player_id + " that was the player");
		
		}
		else
		{
			console.log("Fuck u");
		}
	
	
	}
	
	this.allUltimatumsMet = function()
	{
		
	
	
	}
	
	this.ultimatumIsComplete = function()
	{
		
	
	}
	
	//ultimatum timer ticked
	this.UltTimerTicked = function(tleft)
	{
		var self = this;
		index.index.io.to(self.created.toString()).emit('utlimatum_timer_ticked',tleft);
	
	}
	
	this.playersToDestroy = function(player_id)
	{
	
		console.log("@");
		var self = this;
		if(self.current_players[player_id.toString()])
		{
			self.diePlayer(player_id);
			var p =index.index.playerPool[player_id.toString()];
			p.socket.emit("force_game_over","no shake");
		}
	}
	
	
	
	//we end it because the game is over.
	this.upTimerHasEnded = function()
	{	
		var self = this;
			if(self.countUpTimer)
			{	
				clearInterval(self.countUpTimer.clickInterval);
				clearImmediate(self.countUpTimer.clickInterval);
				self.gameWillStartTimer = null;
			}
	
	}
	
	
	
	
	this.diePlayer = function(player_id)
	{
	
		var self = this;
			
		//remove them from the player list && perform search for game again.
			//remove them from the player list && perform search for game again.
		
		//deletes player by object id
		var idGoodBye=0;
		
		
		for(var i=0;i<self.current_players_Array.length;i++)
		{
		
			var id = self.current_players_Array[i]["user_id"];
			if(id == player_id)
			{
					idGoodBye = i;
					
			}
	
		}
		self.current_players_Array.splice(idGoodBye,1);
		//wait until the loop is over before splicing other wise it stops our loop and we wont be able to notify everyone
		
		delete self.current_players[player_id];
		
		//send final score to the player to report to the database
		
		self.notifyPlayerScore(player_id,true);
		
		var personPlace = {
			"player_gone":player_id,
			"position":self.gamePlayersDuringGame,
		}
		index.index.io.to(self.created.toString()).emit('player_has_lost_game',personPlace);
		
		
		self.gamePlayersDuringGame = self.current_players_Array.length;
		
		
		console.log("players left " + self.current_players_Array.length);
		//makes the game open

		//if there are no more players, close the room
		if(self.current_players_Array.length == 0)
		{
			console.log("deleting game");
		
			self.gameIsOpen = false;
			self.gameIsNowOver();
		}
		
	}
	
	
	this.notifyPlayerScore = function(player_id,isDead)
	{
		//gets the time from the up timer. tells me if player is dead because the i need to give a position what place they came in plus score time and game id
		var self = this;
		var currtime = "00:00:00";
		if(self.countUpTimer)
		{
			currtime = self.countUpTimer.getCurrentUpTime();
		}
		var position = 0;
		if(isDead)
		{
			position = self.current_players_Array.length;
		}
	
		var playerStat ={
			"score":this.current_game_score,
			"time":currtime,
			"game_id":this.created,
			"position":position,
		};
		var myPlayer = index.index.playerPool[player_id.toString()];
		myPlayer.notifyGameScore(playerStat,isDead);
	
	}
	

	this.sendPlayerDiedNotification = function(my_id,player_id_leaving)
	{
			//let other players know that the player has left so game updates.
		
	
	}
	

	this.gameIsNowOver = function()
	{
		this.endGameOperations();
	}
	
	this.endGameOperations = function()
	{	
	
	//lobby timer, game countdown timer, count up timer, ultimatum timers
		 var self = this;
		 index.index.currentGames[self.created.toString()] = null;
		 delete index.index.currentGames[self.game_id];
		self.gameIsOpen = false;
		
		//if these are in existence we have to get rid of all instances of them
		this.countDownToGameTimer = false;
		
		if(self.countDownToGameTimer)
		{
			clearInterval(self.countDownToGameTimer.interval);
			clearImmediate(self.countDownToGameTimer.interval);
			self.countDownToGameTimer = null;
		}
		if(self.gameWillStartTimer)
		{
			clearInterval(self.gameWillStartTimer.interval);
			clearImmediate(self.gameWillStartTimer.interval);
			self.gameWillStartTimer = null;
		}
		if(self.countUpTimer)
		{
			self.upTimerHasEnded();
			self.countUpTimer = null;
		}
		if(self.ult)
		{
			clearTimeout(self.setTimeoutToCounter);
			clearImmediate(self.setTImeoutCounter);
			self.ult.ultimatumFailed();
			
			if(self.ult.pt)
			{
				if(self.ult.pt.interval)
				{
					clearInterval(self.ult.pt.interval);
					clearImmediate(self.ult.pt.interval);
				}
			}
				
			self.ult = null;
		}
		index.index.currentGames[self.created.toString()] = null;
		delete index.index.currentGames[self.created.toString()];

	}
	
};

//simple count down timer to game
var prettyGameTimer = function()
{
    this.timeToPlayWith = 0;
    this.delegate;
    this.interval;
    this.numberOfMillis = 10000;
    this.game;

    this.setTimeAmount = function(numberInMillis)
    {
        this.numberOfMillis = numberInMillis;
    }

    this.startCountDown = function()
    {
        var self = this;
        this.interval = setInterval(this.onTick,1000,self);
    }

    this.pauseCountDown = function()
    {
        var self = this;
        window.clearInterval(self.interval);
        window.clearTimeout(self.interval);
    }

    this.onTick = function(self)
    {

        self.numberOfMillis = self.numberOfMillis - 1000;
        console.log(self.numberOfMillis);
		var tleft = self.addZeros(self.numberOfMillis/1000);
		self.game.CountDownToStartHasTicked(tleft);
        if(self.numberOfMillis < 1)
        {
            self.timerHasEnded(self);

        }

    }

    this.addZeros = function(num)
    {
        if(num < 10)
        {
            return "0" + num;
        }
        else
        {
            return num;
        }

    }


    this.timerHasEnded = function(self)
    {
		self.game.countDownToStartHasEnded();
      //  this.pauseCountDown();
    //    prettyTimerHasEnded();


    }



}

//simple count down timer for lobby
var prettyTimer = function()
{
    this.timeToPlayWith = 0;
    this.delegate;
    this.interval;
    this.numberOfMillis = 3000;
	this.game;

    this.setTimeAmount = function(numberInMillis)
    {

        this.numberOfMillis = numberInMillis;


    }

    this.startCountDown = function()
    {
        var self = this;
        this.interval = setInterval(this.onTick,1000,self);
    }

    this.pauseCountDown = function()
    {
        var self = this;
        window.clearInterval(self.interval);
        window.clearTimeout(self.interval);
    }

    this.onTick = function(self)
    {

        self.numberOfMillis = self.numberOfMillis - 1000;
        console.log(self.numberOfMillis);
		var tleft = self.addZeros(self.numberOfMillis/1000);
		self.game.CountDownToGameHasTicked(tleft);
        if(self.numberOfMillis < 1)
        {
            self.timerHasEnded(self);

        }

    }

    this.addZeros = function(num)
    {
        if(num < 10)
        {
            return "0" + num;
        }
        else
        {
            return num;
        }

    }


    this.timerHasEnded = function(self)
    {
		self.game.countDownToGameHasEnded();
      //  this.pauseCountDown();
    //    prettyTimerHasEnded();


    }



}



var countUpTimer = function(){
	

	this.totalSeconds = 0;
	this.incrementScore = 0;
	//alert(this.totalSeconds);
	this.game;
	this.clickInterval;
	this.secs = '00';
	this.minutes = '00';
	this.hours = '00';
	this.currmills ="00";
	this.scoreIncrementer;
	this.gameStart;
    this.offsettime = 0;
    this.incrementer = 1;
    this.msms = 0;
	
	this.startTicking = function(){
		var self= this;
		this.clickInterval = setInterval(self.setTime, 100,self);
       // countuptimer = this.clickInterval;
	}
	
	//increments time upward every 100th of a second so the timer doesnt seem so slow.
	this.setTime = function(self){
		++self.totalSeconds;
      		  ++self.msms;

			if(self.totalSeconds == self.incrementer * 10)
			 {
				 ++self.incrementer;
				 ++self.offsettime;
				 ++self.incrementScore;
				 self.msms = 0;
				 score = self.offsettime;

			 }

			var secs = self.pad(self.offsettime%60);
			var mins = self.pad(parseInt(self.offsettime/60%60));
			var hours = self.pad(parseInt((self.offsettime/60)/60));
			
			if(self.incrementScore == 10)
			{
				self.incrementScore = 0;
				var timestring = hours + ":" + mins + ":" + secs;
		//		postScore(self.gameStart,self.offsettime,timestring);
			}
			
			self.secs = secs;
			self.minutes = mins;
			self.hours = hours;
			var millis = self.adjustMillis(self.msms * 100).substring(0,2);
			var timeObj = {
				"secs":self.secs,
				"mins":self.minutes,
				"hours":self.hours,
				"millis":millis,
			}
			self.currmills = millis;
			
			self.game.upTimerTicked(timeObj);
	};
	
	
	//returns the current time of the game
	this.getCurrentUpTime = function()
	{
		var string = this.hours +":" + this.minutes + ":" + this.secs;
		return string;
	}
	
	//takes a number and formats it for the timer
	this.pad = function(val)
    {
       var valString = val + "";
            
			if(val == "0" || val < 0)
			{
				return "00";
			}
			if(valString.length < 2)
            {
                return "0" + valString;
            }
            else
            {
                return valString;
            }
     }

	//adjusts millisecodns for timer format
    this.adjustMillis = function(mills)
    {
        if(mills < 1000)
        {
            return "0" + mills;
        }
        else
        {
            return mills;
        }





    }
	 
	 this.upTimerGetStats = function (){
		
		var self = this;
		var obj = {
			"secs":self.secs,
			"minutes" :self.minutes,
			"hours":self.hours,
			"score":self.offsettime,
			"game_id":self.gameStart,
		};
		
	
	 
	 return obj;
		
	 }
	 
	 
	 this.endGame = function()
	 {
         var self = this;

			this.clearMe(this);
         setTimeout(function(){
	     self.minutesLabel.innerHTML ="00:";
             self.secondsLabel.innerHTML = "00:";
             self.hoursLabel.innerHTML ="00:";
             self.milliseconds.innerHTML="00";
         },750);
	 };
	 
	 
	 
	 
	  
	 this.clearMe = function(self)
	{
		window.clearTimeout(self.clickInterval);
		window.clearInterval(self.clickInterval);
		
	};
	
	

}


//ultimatum timer
var ultimatum = function()
{
   // this.timeChoices = [23000,33300,30000,73220,600000,300000,900000,50000];
    this.timeChoices = [50000,50000,50000,50000,50000,50000,50000,50000];
    this.nextChoice = 0;
    this.setTimeOutToCounter = null;
    this.game;
    this.pt = new ultimatumPrettyTimer(); 
    this.players = new Array();
   



    this.setNextChoice = function()
    {
	this.pt.ult = this;
        var number = Math.floor(Math.random() * 6) + 0;
        this.nextChoice = this.timeChoices[number];
        this.setTimeoutUntilUltimatiumStarts();

    }

    this.setTimeoutUntilUltimatiumStarts = function()
    {
        var self = this;
        this.setTimeoutToCounter = setTimeout(self.startUltimatum,self.nextChoice,self);
        console.log(this.nextChoice);

    }

    this.getNextChoice = function()
    {
        return this.nextChoice;
    }

    this.clearTimeoutForDelegationMethod = function()
    {
        this.cancelUltimatum();
    }
	
	
    this.updatePlayerList = function()
    {
	
	
    }

    this.startUltimatum = function(self)
    {
        self.pt.startCountDown();
	self.game.UltimatiumWillStart();
    }

    this.ultimatumWasMet = function()
    {
        var self = this;
        self.cancelUltimatum(self);

        self.pt.pauseCountDown();
        self.cancelUltimatum(self);
        self.pt.setTimeAmount(45000);
        self.players = self.game.current_players_Array;
        self.setNextChoice();
    }

    this.ultimatumFailed = function()
    {

        var self = this;
        self.pt.pauseCountDown();
        self.cancelUltimatum(self);
        self.pt = null;


    }

    this.howLongUtilFailed = function()
    {


    }

    this.cancelUltimatum =  function(self)
    {
      clearTimeout(self.setTimeoutToCounter);
	  clearImmediate(self.setTImeoutCounter);

    }

    //delegation mehtod from pretty timer
    this.timerHasTicked = function(tleft)
    {
		var self = this;
		self.game.UltTimerTicked(tleft);

    }
    //delegation method from prettyTimer
    this.timerHasEnded = function()
    {
		var self = this;
		console.log("polayers is " + self.players.length);
		
		for(var i=0;i<self.players.length;i++)
			{
				//gets the user id of all the players. if it does not match the new players id lets notify them of
				//a new player
				var id = self.players[i]["user_id"];
				self.game.playersToDestroy(id);
				console.log("the id");
			}
			
			
			self.ultimatumWasMet();
    }
	
	
	//playerhas shook phone
	 this.playerMetRequirements = function(player_id)
	 {
	 console.log("will run");
	 var self = this;
	 	for(var i=0;i<self.players.length;i++)
			{
				//gets the user id of all the players. if it does not match the new players id lets notify them of
				//a new player
				var id = self.players[i]["user_id"];
			
				if(id == player_id)
				{
					self.players.splice(i,1);
					console.log("the splice id" + i);
				
				}
				
				console.log(id);
				console.log(player_id);
			}
			
			if(self.players.length == 0)
			{
				self.ultimatumWasMet();
				console.log("No players left");
				
			}
		
	 }


}


var ultimatumPrettyTimer = function()
{
    this.timeToPlayWith = 0;
    this.delegate;
    this.interval;
    this.numberOfMillis = 45000;
    this.ult;

    this.setTimeAmount = function(numberInMillis)
    {

        this.numberOfMillis = numberInMillis;


    }

    this.startCountDown = function()
    {
        var self = this;
        this.interval = setInterval(this.onTick,1000,self);
    }

    this.pauseCountDown = function()
    {
        var self = this;
        clearInterval(self.interval);
        clearTimeout(self.interval);
		clearImmediate(self.interval);
    }

    this.onTick = function(self)
    {
	
        self.numberOfMillis = self.numberOfMillis - 1000;
        console.log(self.numberOfMillis);

		self.ult.timerHasTicked(self.addZeros(self.numberOfMillis/1000)+"s");
     
        if(self.numberOfMillis < 1)
        {
            self.timerHasEnded();

        }

    }

    this.addZeros = function(num)
    {
        if(num < 10)
        {
            return "0" + num;
        }
        else
        {
            return num;
        }

    }


    this.timerHasEnded = function(self)
    {
		var self = this;
		self.ult.timerHasEnded();
    }



}

module.exports.game = game;