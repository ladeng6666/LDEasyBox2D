/**
 * CHANGE LOG
 * 2013-02-15 v5.0
 * 	1.增加pixelPerMeter静态属性，便于缩放屏幕时，修改像素和米的转换关系
 * 	2.修改API函数，与LDEasyNape统一
 * 4.0<<
 * 	添加getBodyAtMouse方法
 * 	添加startDragBody方法
 * 	添加stopDragBody方法
 * >>3.0<<
 * 	添加createPolygon方法
 * 	添加updateWorld方法
 * >>2.0<<
 * 	添加createWrapWall方法
 * >>1.0<<
 * 	Box2D 2.0.1实现LDEasyBox2D
 */

package  ldEasyBox2D
{
	
	import flash.geom.Point;
	
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FilterData;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.plus.b2Separator;

	/**
	 * ...
	 * @author ladeng6666
	 */
	public class LDEasyBody 
	{
		

		public function LDEasyBody() 
		{
			
		}
		private static var pixelPerMeter:int = LDEasyWorld.pixelPerMeter;
		
		public static function getEmptyBody(posX:Number=0,posY:Number=0,type:uint=2):b2Body
		{
			posX /= pixelPerMeter;
			posY /= pixelPerMeter;
			var bodyDefine:b2BodyDef = new b2BodyDef();
			bodyDefine.type = type;
			bodyDefine.position.Set(posX , posY);
			return LDEasyWorld.world.CreateBody(bodyDefine);
		}
		private static function getFixtureDef():b2FixtureDef
		{
			var fixtureDefine:b2FixtureDef = new b2FixtureDef();
			fixtureDefine.density = 3;
			fixtureDefine.friction = 0.3;
			fixtureDefine.restitution = 0.2;
			
			return fixtureDefine;
		}
		public static function createBodyFromShape(posX:Number, posY:Number, shape:b2Shape, type:uint=2):b2Body
		{
			var fixtureDefine:b2FixtureDef = getFixtureDef();
			fixtureDefine.shape = shape;
			
			var body:b2Body = getEmptyBody(posX,posY,type);
			body.CreateFixture(fixtureDefine);
			
			return body;
		}

		/**
		 * 创建并返回一个标准矩形刚体
		 * @param posX	坐标x
		 * @param posY	坐标y
		 * @param boxWidth	宽度
		 * @param boxHeight 高度
		 * @param type	刚体类型，b2Body中刚体类型常量之一
		 * @return 
		 * 
		 */		
		public static function createBox(
				posX:Number, 
				posY:Number, 
				boxWidth:Number, 
				boxHeight:Number, 
				type:uint = 2
			):b2Body {
			var shape:b2PolygonShape = LDEasyShape.createBox(boxWidth,boxHeight);
			var body:b2Body = createBodyFromShape(posX,posY,shape,type);
			
			return body;
		}
		public static function createEdge(
			v1:Point,
			v2:Point,
			type:uint=2
		):b2Body {
			var shape:b2PolygonShape = LDEasyShape.createEdge(v1,v2);
			var body:b2Body = createBodyFromShape(0,0,shape,type);
			
			return body;
		}
		public static function createTrapezium(
			posX:Number,
			posY:Number,
			tw:Number,
			bw:Number,
			h:Number,
			type:uint=2
		):b2Body {
			var shape:b2PolygonShape = LDEasyShape.createTrapezium(tw,bw,h);
			var body:b2Body = createBodyFromShape(posX,posY,shape,type);
			
			return body;
		}
		public static function createChain(points:Vector.<Point>,isloop:Boolean=false,type:int=0):b2Body
		{
			var body:b2Body = getEmptyBody(0,0,type);
			var shape:b2PolygonShape;
			var startPoint:b2Vec2 = new b2Vec2(points[0].x/30,points[0].y/30);
			var prePoint:b2Vec2 = startPoint.Copy();
			var p:b2Vec2 = new b2Vec2();
			for (var i:int = 1; i < points.length; i++) 
			{
				p.x = points[i].x/30;
				p.y = points[i].y/30;
				shape = b2PolygonShape.AsEdge(prePoint, p);
				body.CreateFixture2(shape,1).SetFriction(1);
				prePoint = p.Copy();
			}
			if(isloop){
				shape = b2PolygonShape.AsEdge(prePoint, startPoint);
				body.CreateFixture2(shape,1).SetFriction(1);
			}
			return body;
		}
		
		/**
		 *	创建一个圆形刚体 
		 * @param posX
		 * @param posY
		 * @param radius
		 * @param type
		 * @return 
		 * 
		 */		
		public static function createCircle(
				posX:Number, 
				posY:Number, 
				radius:Number, 
				type:uint = 2
			):b2Body {
			var shape:b2CircleShape = LDEasyShape.createCircle(radius);
			var body:b2Body = createBodyFromShape(posX,posY,shape,type);
			return body;
		}
		public static function createSemiCircle(
			posX:Number, 
			posY:Number, 
			w:Number,
			h:Number,
			type:uint = 2
			):b2Body {
			var shape:b2PolygonShape = LDEasyShape.createSemiCircle(w,h);
			var body:b2Body = createBodyFromShape(posX,posY,shape,type);
			
			return body;
		}
		public static function createFan(
			posX:Number,
			posY:Number,
			radius:Number,
			angle:Number,
			type:uint = 2
		):b2Body {
			var shape:b2PolygonShape = LDEasyShape.createFan(radius,angle);
			var body:b2Body = createBodyFromShape(posX,posY,shape,type);
			
			return body;
		}
		public static function createEllipse(
			posX:Number, 
			posY:Number, 
			w:Number,
			h:Number,
			type:uint = 2
			):b2Body {
			var shape:b2PolygonShape = LDEasyShape.createEllipse(w,h);
			var body:b2Body = createBodyFromShape(posX,posY,shape,type);
			
			return body;
		}

		public static function createRegular(
						posX:Number, 
						posY:Number, 
						radius:Number, 
						verticesCount:uint = 5, 
						type:uint = 2):b2Body {
			var shape:b2PolygonShape = LDEasyShape.createRegular(radius,verticesCount);
			var body:b2Body = createBodyFromShape(posX,posY,shape,type);
			
			return body;
		}
		public static function createPlatform(
			posX:Number, 
			posY:Number, 
			w:Number, 
			h:Number = 20, 
			type:uint = 0):b2Body
		{
			var shape:b2PolygonShape = LDEasyShape.createPlatform(w,h);
			var body:b2Body = createBodyFromShape(posX,posY,shape,type);
			
			return body;
		}
		/**
		 * 根据一组顶点数据，创建多边形刚体，可以是顺时针绘制，也可以逆时针绘制，但不能出现交叉
		 * @param	world Box2D世界
		 * @param	vertices 顶点数组，顶点之间不能有交叉
		 * @param	isStatic	是否为静止的刚体
		 * @param	fillData	刚体的填充纹理，一个BitmapData对象，请确保整个BitmapData的尺寸大于舞台的尺寸
		 * @param	stage	添加userData的舞台,若不指定该属性,将无法看到刚体的外观
		 * @return 返回一个多边形刚体
		 * @link	http://www.ladeng6666.com/blog/index.php/2012/08/10/box2d%e5%a4%9a%e8%be%b9%e5%bd%a2%e5%88%9a%e4%bd%93%e8%b4%b4%e5%9b%be/
		 */
		public static function createPolygon(
				vertices:Vector.<b2Vec2>,
				type:uint=2
			):b2Body {
			var fixtureDefine:b2FixtureDef = getFixtureDef();

			var separator:b2Separator = new b2Separator();
			//验证顶点是否符合创建多边形的标准
			var validate:int = separator.Validate(vertices);
			//如果是顶点因非顺时针不符标准，则反转数组中的顶点顺序
			if (validate == 2) {
				vertices.reverse();
			}else if (validate != 0) {
				//如果不符合多边形标准，跳出
				return null;
			}
			//2.Box2D世界工厂更具需求创建createBody()生产刚体
			var body:b2Body= getEmptyBody(0,0,type);
			//将顶点分解成多个凸多边形，组合成复杂的多边形
			separator.Separate(body, fixtureDefine, vertices);
			
			return body;
		}
		/**
		 * 在Box2D世界中创建围绕canvas四周的静态墙体，
		 * @param	world 承载所有刚体的Box2D世界
		 * @param	canvas	要用静态墙体包围的舞台
		 */
		public static function createRectangle(x:Number,y:Number,w:Number,h:Number,topOpen:Boolean=false,type:uint=0,thinkness:Number=20,isFullFilter:Boolean=true):void {
			//设置filterData，让该Rectangle对所有刚体进行碰撞检测
			var fullFilter:b2FilterData = new b2FilterData();
			if(isFullFilter){
				fullFilter.categoryBits=0xffff;
				fullFilter.maskBits=0xffff;
			}
			var wall:b2Body;
			
			//top
			if(!topOpen){
				wall = createBox( x+w / 2, y, w , thinkness, type);
				wall.GetFixtureList().SetFilterData(fullFilter);
			}
			//bottom
			wall = createBox( x+w / 2, y+h, w , thinkness, type);
			wall.GetFixtureList().SetFilterData(fullFilter);
			//left
			wall = createBox( x, y+h / 2, thinkness, h , type);
			wall.GetFixtureList().SetFilterData(fullFilter);
			//right
			wall = createBox( x+w, y+h / 2, thinkness, h , type);
			wall.GetFixtureList().SetFilterData(fullFilter);
		}
	}

}