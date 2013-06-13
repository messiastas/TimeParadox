package game.common.interfaces 
{
	
	/**
	 * ...
	 * @author messia_s
	 */
	public interface IGameService 
	{
		function setRandomTarget(forwho:IHuman):void ;
		function getHuman(hName:String): IHuman;
	}
	
}