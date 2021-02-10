package
{
	public class Connection
	{
		private var _nodeB:Node;
		private var _nodeA:Node;
		private var _type:int;
		
		public function Connection(nodeA,nodeB:Node,type:int)
		{
			_nodeA = nodeA
			_nodeB = nodeB;
			_type = type;
		}
		
		public function get nodeB():Node
		{
			return _nodeB;
		}
		
		public function get type():int
		{
			return _type;
		}
	}
}