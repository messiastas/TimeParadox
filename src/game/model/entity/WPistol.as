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
			power = 100;
			distance = 50;
			noise = 100;
			maxBullets = 9;
			currentBullets = 9;
			reloadTime = 30;
		}
		
	}

}