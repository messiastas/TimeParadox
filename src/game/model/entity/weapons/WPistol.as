package game.model.entity.weapons 
{
	/**
	 * ...
	 * @author messia_s
	 */
	public class WPistol extends BasicWeapon 
	{
		
		public function WPistol() :void
		{
			power = 15;
			distance = 50;
			noise = 200;
			maxBullets = 9;
			currentBullets = 9;
			reloadTime = 30;
		}
		
	}

}