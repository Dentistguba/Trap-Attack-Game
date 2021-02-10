package
{
	import flash.display.MovieClip;
	import flash.display.Shape;
	
	public class Node
	{
		private var _x;
		private var _y;
		private var _tempConnections:Array;
		private var _connections:Vector.<Connection> = new Vector.<Connection>();
		private var _backwardsConnections:Vector.<Connection> = new Vector.<Connection>();
		
		public function Node(X = 0,Y = 0,Connections:Array = null)
		{
			_x=X;
			_y=Y;
			
			if (Connections != null)
				_tempConnections = Connections.concat();
		}
		
		public function get connections():Vector.<Connection>
		{
			return _connections;
		}
		
		public function get backwardsConnections():Vector.<Connection>
		{
			return _backwardsConnections;
		}
		
		public function get x():Number
		{
			return _x;
		}
		
		public function get y():Number
		{
			return _y;
		}
		
		public function createConnections(nodeList:Vector.<Node>):void
		{
			if (_tempConnections != null && _tempConnections.length > 0)
			{
				for (var i:int = 0; i < _tempConnections.length; i++)
				{
					if (_tempConnections[i][0] != null && _tempConnections[i][1] != null)
					{
						_connections.push(new Connection(this,nodeList[_tempConnections[i][0]],_tempConnections[i][1]));
					}
				}
				
				for (var i:int = 0; i < _connections.length; i++)
				{
					if (_connections[i].type == 1)
						_connections[i].nodeB.backwardsConnections.push(new Connection(_connections[i].nodeB,this,0));
				}
			}
		}
	}
}