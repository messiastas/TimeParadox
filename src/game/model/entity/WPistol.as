package game.model.entity 
{
	/**
	 * ...
	 * @author messia_s
	 */
	public class WPistol extends BasicWeapon 
	{
		
		public function WPistol() :void
		{
			power = 60;
			distance = 50;
			noise = 200;
			maxBullets = 9;
			currentBullets = 9;
			reloadTime = 30;
		}
		
	}

}