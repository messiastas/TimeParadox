package game.common 
{
	public class SharedConst
	{
		
		public static const GAME_SERVICE:String = "GameService";
		public static const MAP_SERVICE:String = "MapService";
		public static const PLAYER:String = "player";
		
		public static const CMD_CREATE_HUMAN:String = "cmd_create_human";
		public static const CMD_CREATE_PLAYER:String = "cmd_create_player";
		public static const CMD_CREATE_MAP:String = "cmd_create_map";
		public static const CMD_TAKE_WEAPON:String = "cmd_take_weapon";
		public static const CMD_NEW_RANDOM_TARGET:String = "cmd_new_random_target";
		public static const CMD_HUMAN_DONE:String = "cmd_human_done";
		public static const CMD_CHECK_NOISE:String = "cmd_chack_noise";
		
		
		public static const ACTION_MOVE_HUMAN:String = "action_move_human";
		public static const ACTION_CHANGE_ANGLE:String = "action_change_angle";
		public static const ACTION_CHANGE_STATE:String = "action_change_state";

		public static const ACTION_GOTO:String = "action_goto";
		public static const ACTION_KILL:String = "action_kill";
		
		public static const NOISE_SHOT:String = "noise_shot";
		
		
		public static const TYPE_HUMAN:String = "type_human";
		public static const TYPE_WAYPOINT:String = "type_waypoint";
		public static const TYPE_WAITING:String = "type_waiting";
		
		
		public static const NEW_ITER:String = "new_iter";
		
		public static const CURRENT_LEVEL:int = 1;
		public static const ACTION_TIME:int = 30;
		public static const MAP_STEP:int = 20;
		
		public static var FRACTIONS_PACIFIC:Array = [SharedConst.FRACTION_CIVIL_POOR, SharedConst.FRACTION_CIVIL_RICH];
		public static var FRACTIONS_ARMED:Array = [SharedConst.FRACTION_POLICE, SharedConst.FRACTION_REBEL];
		
		public static var FRACTION_AGRESSION_LIMIT:int = 50;
		
		public static var FRACTIONS_RELATIONS:Array =  [[100,40,40,100,50],
														[40,100,80,30,50],
														[40,80,100,0,50],
														[100, 30, 0, 100, 50],
														[50,50,50,50,50] ]
		public static const FRACTION_CIVIL_POOR:int = 0;
		public static const FRACTION_CIVIL_RICH:int = 1;
		public static const FRACTION_POLICE:int = 2;
		public static const FRACTION_REBEL:int = 3;
		public static const FRACTION_SCIENTIST:int = 4;
		
		public static const isSound:Boolean = true;
		
		
	}
	
}