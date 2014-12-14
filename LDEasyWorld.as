package ldEasyBox2D
{
	import flash.display.Sprite;
	
	import Box2D.Common.b2internal;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2World;
	import Box2D.Dynamics.Joints.b2JointEdge;
	import Box2D.Dynamics.Joints.b2MouseJoint;
	import Box2D.Dynamics.Joints.b2MouseJointDef;
	import Box2D.Dynamics.Joints.b2RevoluteJointDef;

	use namespace b2internal;
	public class LDEasyWorld
	{
		public function LDEasyWorld()
		{
		}
		private static const VER:String = "LDEasyBox2D 2014-07-15";
		//当使用startDragBody()方法时，自动实例化这个鼠标关节
		private static var mouseJoint:b2MouseJoint;
		private static var mouseVector:b2Vec2 = new b2Vec2();
		private static var debugSprite : Sprite;
		
		public static var world:b2World;
		//每米转换成多少像素
		public static var pixelPerMeter:Number = 30;
		public static var stepPositionDelta:Number = 10;
		public static var stepVelocityDelta:Number = 10;
		public static var stepDelta:Number = 1/30;
		/**
		 * 创建并返回一个重力为10牛的Box2D世界
		 * @return 返回创建好的Box2D世界
		 * @link http://www.ladeng6666.com/blog/index.php/2012/05/31/%e8%ae%a4%e8%af%86box2d%e4%b8%96%e7%95%8c/
		 */
		public static function createWorld(gravityX:Number=0, gravityY:Number=10,doSleep:Boolean=true):b2World {
			var gravity:b2Vec2 = new b2Vec2(gravityX, gravityY);
			var world:b2World = new b2World(gravity, doSleep);
			LDEasyWorld.world = world;
			return world;
		}
		/**
		 * 更新Box2D世界。世界里刚体的useData也会同步更新；用startDragBody创建的鼠标关节也会自动更新
		 * @param	world，承载所有刚体的Box2D世界
		 * @link	http://www.ladeng6666.com/blog/index.php/2012/06/05/%e6%8e%89%e8%90%bd%e7%9a%84%e8%8b%b9%e6%9e%9c-b2body%e5%88%9a%e4%bd%93/
		 */
		public static function updateWorld(isDrawDebug:Boolean = true):void {
			world.Step(stepDelta, stepPositionDelta, stepVelocityDelta);
			//world.ClearForces();
			if(isDrawDebug) world.DrawDebugData();
			
		}
		/**
		 * 创建Box2D Debug对象，调试Box2D应用
		 * @param	world Box2D的世界
		 * @return Sprite，用来绘制Box2D调试图的sprite对象
		 * @link	http://www.ladeng6666.com/blog/index.php/2012/06/05/%E6%8E%89%E8%90%BD%E7%9A%84%E8%8B%B9%E6%9E%9C-b2body%E5%88%9A%E4%BD%93/
		 */
		public static function createDebug(debugSprite:Sprite):b2DebugDraw 
		{
			LDEasyWorld.debugSprite = debugSprite;
			
			var debugDraw:b2DebugDraw = new b2DebugDraw();
			debugDraw.SetSprite(debugSprite);
			debugDraw.SetDrawScale(pixelPerMeter);
			debugDraw.SetFillAlpha(0.5);
			debugDraw.SetLineThickness(1.0);
			debugDraw.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit);
			LDEasyDebug.debug = debugDraw;
			
			world.SetDebugDraw(debugDraw);
			return debugDraw;
		}
		/**
		 * 获取Box2D世界中鼠标下的刚体
		 * @return	返回鼠标位置的刚体
		 * @link	http://www.ladeng6666.com/blog/index.php/2012/08/18/drag-b2body-with-mousejointdef/
		 */
		public static function getBodyAt(px:Number,py:Number):b2Body {
			px /= pixelPerMeter;
			py /= pixelPerMeter;
			
			//转换鼠标坐标单位，除以30从m该为px
			var mouseVector:b2Vec2 = new b2Vec2(px,py);
			//鼠标下的刚体
			var bodyAtMouse:b2Body = null;
			//queryPoint函数中要用到的回调函数，注意，它必须有一个b2Fixture参数
			function callBack(fixture:b2Fixture):void {
				if ( fixture == null) return;
				//如果fixture不为null，设置为鼠标下的刚体
				bodyAtMouse = fixture.GetBody();
			}
			//利用QueryPoint方法查找鼠标滑过的刚体
			world.QueryPoint(callBack, mouseVector);
			//返回找到的刚体
			return bodyAtMouse;
		}
		/**
		 * 用鼠标关节拖动刚体
		 * @param	world	承载所有刚体和关节的Box2D世界
		 * @param	body		要拖动的刚体
		 * @param	maxForce	鼠标关节允许的最大作用力，默认为1000
		 * @link	http://www.ladeng6666.com/blog/index.php/2012/08/18/drag-b2body-with-mousejointdef/
		 */
		public static function dragBodyTo(
			body:b2Body,
			mouseX:Number,
			mouseY:Number,
			isStrictDrag:Boolean=false
		):void {
			if (body == null) return;//如果鼠标下的刚体不为空
			if (body.GetType() != b2Body.b2_dynamicBody) return;
			mouseX /=pixelPerMeter;
			mouseY /= pixelPerMeter;
			
			if(mouseJoint==null){
				//创建鼠标关节需求
				var mouseJointDef:b2MouseJointDef = new b2MouseJointDef();
				mouseJointDef.bodyA = world.GetGroundBody();//设置鼠标关节的一个节点为空刚体，GetGroundBody()可以理解为空刚体
				mouseJointDef.bodyB = body;//设置鼠标关节的另一个刚体为鼠标点击的刚体
				mouseJointDef.target.Set(mouseX, mouseY);//更新鼠标关节拖动的点
				mouseJointDef.maxForce = 1000*body.GetMass();//设置鼠标可以施加的最大的力
				
				//创建鼠标关节
				mouseJoint=world.CreateJoint(mouseJointDef) as b2MouseJoint;
			}
			
			mouseVector.x = mouseX;
			mouseVector.y = mouseY;
			if(isStrictDrag || body.GetJointList()==null){
				body.SetPosition(mouseVector);
			}
			mouseJoint.SetTarget(mouseVector);
			
		}
		/**
		 * 停止拖动world中的刚体
		 * @param	world
		 * @link	http://www.ladeng6666.com/blog/index.php/2012/08/18/drag-b2body-with-mousejointdef/
		 */
		public static function stopDragBody():void {
			if (mouseJoint != null) {
				world.DestroyJoint(mouseJoint);
				mouseJoint=null;
			}
		}
		public static function fixBodyAt(body:b2Body,posX:Number, posY:Number, force:Number=0):void {
			posX /= pixelPerMeter;
			posY /= pixelPerMeter;
			var fixedPoint:b2Vec2 = new b2Vec2(posX,posY);
			var revoluteJointDef:b2RevoluteJointDef = new b2RevoluteJointDef();
			revoluteJointDef.Initialize(world.GetGroundBody(), body, fixedPoint);
			revoluteJointDef.localAnchorB = body.GetLocalPoint(fixedPoint);
			revoluteJointDef.enableMotor = true;
			revoluteJointDef.motorSpeed = 0;
			revoluteJointDef.maxMotorTorque = force;
			world.CreateJoint(revoluteJointDef);
		}
		public static function releaseBody(body:b2Body):void{
			if(body==null) return;
			if(body.GetJointList()==null) return;
			var jointEdge:b2JointEdge = body.GetJointList();
			while(jointEdge){
				world.DestroyJoint(jointEdge.joint);
				jointEdge = jointEdge.next;
			}
		}
		public static function version():void {
			trace(VER);
		}
	}
}