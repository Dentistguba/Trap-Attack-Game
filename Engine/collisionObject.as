package
{
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	public class collisionObject
	{
		public var pointList:Vector.<Point> = new Vector.<Point>();
		public var normalList:Array = new Array();
		public var x:Number = 0;
		public var y:Number = 0;
		
		public function collisionObject():void
		{
		}
	}
}