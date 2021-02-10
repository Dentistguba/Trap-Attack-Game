package
{
	public class simpleProximityTree
	{
		//private var quadGround:ProximityManager;
		private var grid:ProximityManager;
		//private var particles:ProximityManager;
		
		public function simpleProximityTree(groundCellSize/*, maxParticleSize*/)
		{
			grid = new ProximityManager(groundCellSize);
			//quadGround = new ProximityManager(groundCellSize * 2);
			//particles = new ProximityManager(maxParticleSize);
		}
		
		public function addObject(object:Object)
		{
			grid.addItem(object);
		}
		
		public function removeObject(object:Object)
		{
			grid.removeItem(object);
		}
		
		public function refresh()
		{
			//quadGround.refresh();
			grid.refresh();
		}
		
		public function getNeighbors(object:Object):Array
		{
			return (grid.getNeighbors(object));
		}
	}
}