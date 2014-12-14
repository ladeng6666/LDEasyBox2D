package ldEasyBox2D
{
	import flash.geom.Point;
	
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;

	public class LDEasyShape
	{
		public function LDEasyShape()
		{
		}
		// pixel per meter
		private static const p2m:Number = 30;
		private static const arcSimulateAnglePrecise:Number = 10 /180*Math.PI;
		public static function createCircle(radius:Number,localX:Number=0,localY:Number=0):b2CircleShape
		{
			radius/=p2m;
			localX/=p2m;
			localY/=p2m;
			var circle:b2CircleShape = new b2CircleShape(radius);
			circle.SetLocalPosition(b2Vec2.Make(localX,localY));
			return circle;
		}
		public static function createBox(w:Number,h:Number,localX:Number=0,localY:Number=0,angle:Number=0):b2PolygonShape
		{
			w/=p2m;
			h/=p2m;
			localX/=p2m;
			localY/=p2m;
			var box:b2PolygonShape = b2PolygonShape.AsOrientedBox(w/2,h/2,new b2Vec2(localX,localY),angle);
			return box;
		}
		public static function createTrapezium(tw:Number,bw:Number,h:Number):b2PolygonShape{
			tw/=p2m;
			bw/=p2m;
			h/=p2m;
			var vertices:Vector.<b2Vec2> = new Vector.<b2Vec2>();
			vertices.push(new b2Vec2(-tw/2,-h/2));
			vertices.push(new b2Vec2(tw/2,-h/2));
			vertices.push(new b2Vec2(bw/2,h/2));
			vertices.push(new b2Vec2(-bw/2,h/2));
			var shape:b2PolygonShape = b2PolygonShape.AsVector(vertices,4);
			return shape;
		}
		public static function createRegular(radius:Number, verticesCount:int):b2PolygonShape
		{
			radius/=p2m;
			
			var angle:Number = Math.PI * 2 / verticesCount;//每个顶点之间的角度间隔
			var vertices:Vector.<b2Vec2> = new Vector.<b2Vec2>();
			var vertix:b2Vec2;
			//移动到第一个顶点
			for (var i:int=0; i< verticesCount; i++){
				//计算每个顶点
				vertix = new b2Vec2(radius * Math.cos( i * angle+ (Math.PI - angle)/2), radius * Math.sin( i * angle+(Math.PI - angle)/2));
				vertices.push(vertix);
			}
			var regularShape:b2PolygonShape = new b2PolygonShape();
			regularShape.SetAsVector(vertices, verticesCount);
			
			return regularShape;
		}
		/**
		 * 
		 * @param radius
		 * @param angleSize 角度
		 * @return 
		 * 
		 */		
		public static function createFan(radius:Number,angleSize:Number):b2PolygonShape
		{
//			if(angleSize>180) throw Error("the angle of fan is over 180");
			radius/=30;
			angleSize = angleSize/180*Math.PI;
			
			var verticesList:Array = new Array();
			var tempVertex:b2Vec2 = new b2Vec2();
			verticesList.push(tempVertex);
			
			var verticesCount:int = int(Math.PI*2/arcSimulateAnglePrecise * angleSize/Math.PI/2)+1;
			
			for (var i:int = 0; i < verticesCount; i++) 
			{
				tempVertex= b2Vec2.Make(
					radius*Math.cos(arcSimulateAnglePrecise*i + (Math.PI-angleSize)/2),
					radius*Math.sin(arcSimulateAnglePrecise*i + (Math.PI-angleSize)/2)
				);
				verticesList.push(tempVertex);
			}
			tempVertex= b2Vec2.Make(
				radius*Math.cos(angleSize + (Math.PI-angleSize)/2),
				radius*Math.sin(angleSize + (Math.PI-angleSize)/2)
			);
			verticesList.push(tempVertex);
			var fanShape:b2PolygonShape = new b2PolygonShape();
			fanShape.SetAsArray(verticesList);
			
			return fanShape;
		}
		public static function createSemiCircle(w:Number,h:Number):b2PolygonShape
		{
			w /= p2m;
			h /= p2m;
			
			
			var r:Number = (h*h+w*w/4)/h/2
			var angleSize:Number = Math.acos((r-h)/r)*2;
			if(angleSize<arcSimulateAnglePrecise) throw Error("the angle of semicircle is too small");
			var verticesList:Array = new Array();
			var tempVertex:b2Vec2 = new b2Vec2();
			var verticesCount:int = Math.floor(Math.PI*2/arcSimulateAnglePrecise * angleSize/Math.PI/2);
			
			for (var i:int = 0; i < verticesCount; i++) 
			{
				tempVertex= b2Vec2.Make(
						r*Math.cos(arcSimulateAnglePrecise*i + (Math.PI-angleSize)/2),
						r*Math.sin(arcSimulateAnglePrecise*i + (Math.PI-angleSize)/2) -r+h
				);
				verticesList.push(tempVertex);
			}
			tempVertex= b2Vec2.Make(
				r*Math.cos(angleSize + (Math.PI-angleSize)/2),
				r*Math.sin(angleSize + (Math.PI-angleSize)/2) -r+h
			);
			verticesList.push(tempVertex);
			
			var shape:b2PolygonShape = new b2PolygonShape();
			shape.SetAsArray(verticesList);
			
			return shape;
		}
		public static function createEdge(v1:Point,v2:Point):b2PolygonShape
		{
			
			var p1:b2Vec2 = new b2Vec2(v1.x/p2m,v1.y/p2m);
			var p2:b2Vec2 = new b2Vec2(v2.x/p2m,v2.y/p2m);
			
			return b2PolygonShape.AsEdge(p1,p2);
		}
		public static function createEllipse(w:Number,h:Number):b2PolygonShape
		{
			w /= p2m;
			h /= p2m;
			
			var px:Number,py:Number;
			var verticesList:Array = new Array();
			var verticesCount:Number = int(Math.PI*2/arcSimulateAnglePrecise);
			for (var i:int = 0; i < verticesCount; i++) 
			{
				px = w/2*Math.cos(arcSimulateAnglePrecise*i);
				py = h/2*Math.sin(arcSimulateAnglePrecise*i);
				verticesList.push(new b2Vec2(px,py));
			}
			
			var shape:b2PolygonShape = new b2PolygonShape();
			shape.SetAsArray(verticesList);
			return shape;
		}
		public static function createPolygon(
			vertices:Vector.<Array>
		):b2PolygonShape {
			var verticesList:Vector.<b2Vec2> = new Vector.<b2Vec2>();
			var tempVec:b2Vec2 = new b2Vec2();
			for each (var v:Array in vertices) 
			{
				tempVec.x = v[0]/p2m;
				tempVec.y = v[1]/p2m;
				verticesList.push(tempVec.Copy());
			}
			
			var shape:b2PolygonShape = new b2PolygonShape();
			shape.SetAsVector(verticesList);
			return shape;

		}
		public static function createPlatform(w:Number,h:Number):b2PolygonShape
		{
			w /= p2m;
			h /= p2m;
			var verticesList:Vector.<b2Vec2> = new Vector.<b2Vec2>();
			verticesList.push(new b2Vec2(-w/2, -h/2));
			verticesList.push(new b2Vec2(w/2, -h/2));
			verticesList.push(new b2Vec2(w/2,h/2));
			verticesList.push(new b2Vec2(0,h/2+10/30));
			verticesList.push(new b2Vec2(-w/2,h/2));
			
			var shape:b2PolygonShape = new b2PolygonShape();
			shape.SetAsVector(verticesList);
			return shape;
		}
	}
}