var index = require("./index.js");
var game = require("./game.js");
var playa = require("./player.js");
var assert = require('assert');
/*
var gameUpdate = new database();
gameUpdate.connectDatabase();
gameUpdate.updateGame(player_id,game_id);
*/


var database = function(){

   this.mysql = index.index.mysql;
   this.connection = false;
   this.player  = null;


 this.connectDataBase = function(){
   	 this.connection = this.mysql.createConnection({
     		  host     : 'combustioninnovation.com',
      		  user     : 'dan_pushV2User',
     		  password : ')(&JsyhyT?ro',
     		  database : 'dan_pushV2'
     	 });
     	 
	this.connection.connect();
	 
	 }



this.createNewGame = function()
{



}

this.setPlayer = function(player)
{
	this.player = player;

}


this.updateGame = function(unique_game,user_id,score,time_passed,created,type,done)
{
var self = this;

	var table='games';
	var result=true;
	var rows   = new Array();
	var query =this.connection.query("SELECT * FROM ?? WHERE user_id=? AND unique_game=?",[table,user_id,unique_game], function(err, rows, fields) {
		 query.on('result', function (_rows) {
			rows.push(_rows);
		  });
		  if(rows.length>0)
		  {
			self.updateMyGame(unique_game,user_id,score,time_passed,created,type,done);
			self.getRankOfGame(score,unique_game);
		  }
		  else
		  {
			self.insertNewGame(unique_game,user_id,score,time_passed,created,type,done);
			self.getRankOfGame(score,unique_game);
		  }

		});


}

//	this.playa.notifyNewRank(rank);
this.getRankOfGame = function(score,unique_game)
{
var self = this;

	var table='games';
	var result=true;
	var query =this.connection.query("SELECT * FROM ?? WHERE score>=? AND unique_game!=?",[table,score,unique_game], function(err, rows, fields) {
		 query.on('result', function (_rows) {
			rows.push(_rows);
		  });
		//  console.log(rows.length+" "+self.playa);
		  console.log(self.player);
		  self.player.notifyNewRank(rows.length);
		});


}

this.insertNewGame = function(unique_game,user_id,score,time_passed,created,type,done){

	var table='games';
	var self = this;
	var curDate=this.getDate();

	
		//insert into 
		this.connection.query('INSERT INTO ?? SET ?,?,?,?,?,?', [table, {user_id:user_id},{score:score},{created:curDate},{unique_game:unique_game},{time_passed:time_passed},{type:type}], function (err, result) {
			//console.log(err);
		});
			//assert.ifError(err);
}


this.updateMyGame = function(unique_game,user_id,score,time_passed,created,type,done)
{
	var table='games';
	var self = this;
	game_ended='';
		if(done)
		{
			game_ended=created;
		}
		this.connection.query('UPDATE ?? SET score=?, time_passed=? , game_ended=? WHERE user_id=? AND unique_game=?', [table,score,time_passed,game_ended,user_id,unique_game], function (err) {
			console.log(err);
		});
  		console.log('updating game');

}

this.getDate=function(){
	var t = new Date();
	var year =  t.getFullYear();
	var month =  t.getMonth();
	var day =  t.getDate();
	var hours =  t.getHours();
	var minutes =  t.getMinutes();
	var seconds =  t.getSeconds();
	var curDate=year+'-'+month+'-'+day+' '+hours+':'+minutes+':'+seconds;
	return curDate;
	}

this.playerGameExist = function(unique_game,user_id)
{

	var table='games';
	var result=true;
	//var result=false;
	//var fields = [];
	//select from games where player id  = theplayer id and game id = the game id 
	//if rows = 0 return false else return true;'
	var rows   = new Array();
	var query =this.connection.query("SELECT * FROM ?? WHERE user_id=? AND unique_game=?",[table,user_id,unique_game], function(err, rows, fields) {
		 query.on('result', function (_rows) {
			rows.push(_rows);
		  });
		  if(rows.length>0)
		  {
		  
		  }
		  else
		  {
		  
		  }

		});

}


this.lastUpdate = function(){

	this.connection.query('SELECT * FROM games WHERE user_id='+user_id+' AND unique_game='+unique_game+';', function(err, rows, fields) {
  		if (err) throw err;

  		console.log('The solution is: ', rows[0].solution);
	});
	connection.end();
}


}


module.exports.database = database;