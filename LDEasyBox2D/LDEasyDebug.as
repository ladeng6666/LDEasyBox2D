package ldEasyBox2D
{
	import flash.display.Graphics;
	
	import Box2D.Collision.b2AABB;
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.b2Color;
	import Box2D.Common.b2internal;
	import Box2D.Common.Math.b2Math;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.Joints.b2DistanceJoint;
	import Box2D.Dynamics.Joints.b2FrictionJoint;
	import Box2D.Dynamics.Joints.b2GearJoint;
	import Box2D.Dynamics.Joints.b2Joint;
	import Box2D.Dynamics.Joints.b2LineJoint;
	import Box2D.Dynamics.Joints.b2MotorJoint;
	import Box2D.Dynamics.Joints.b2MouseJoint;
	import Box2D.Dynamics.Joints.b2PrismaticJoint;
	import Box2D.Dynamics.Joints.b2PulleyJoint;
	import Box2D.Dynamics.Joints.b2RevoluteJoint;
	import Box2D.Dynamics.Joints.b2RopeJoint;
	import Box2D.Dynamics.Joints.b2WeldJoint;
	import Box2D.Dynamics.Joints.b2WheelJoint;
	import Box2D.plus.b2Rot;

	use namespace b2internal;
	public class LDEasyDebug
	{
		public function LDEasyDebug()
		{
		}
		public static const red:b2Color = new b2Color(1,0,0);
		public static const blue:b2Color = new b2Color(0,0,1);
		public static const green:b2Color = new b2Color(0,1,0);
		public static const black:b2Color = new b2Color(0,0,0);
		public static const gray:b2Color = new b2Color(.9,.9,.9);
		private static var graphic:Graphics;
		public static var debug:b2DebugDraw;

		/**
		 * 用指定的颜色绘制Fixture中所包含的形状边框 
		 * @param debug	box2D应用中的b2DebugDraw对象
		 * @param f	要绘制形状的Fixture
		 * @param color	边框颜色
		 * 
		 */		
		public static function drawFixture(f:b2Fixture,color:b2Color,solid:Boolean=false):void
		{
			if (f.GetShape().GetType()== 0)  // circle shape
			{
				var cb:b2Body = f.GetBody();
				var circle:b2CircleShape = f.GetShape() as b2CircleShape;
				if(solid){
					debug.DrawCircle(cb.GetWorldPoint(circle.GetLocalPosition()),circle.GetRadius(),color);
				}else{
					debug.DrawCircle(cb.GetWorldPoint(circle.GetLocalPosition()),circle.GetRadius(),color);
				}
			}else if(f.GetShape().GetType()==1){ // polygonshape
				var shape:b2PolygonShape = f.GetShape() as b2PolygonShape;
				var verticeGlobal:Vector.<b2Vec2> = VectorToGlobal(shape.GetVertices(),f.GetBody());
				if(solid){
					
					debug.DrawSolidPolygon(verticeGlobal,shape.GetVertexCount(),color);
				}else{
					debug.DrawPolygon(VectorToArray(VectorToGlobal(shape.GetVertices(),f.GetBody())), shape.GetVertexCount(), color);
				}
			}
		}
		/**
		 * 将保存b2PolygonShape顶点的数组类型由Vector转换为Array数组 
		 * @param v	包含顶点的数组
		 * @param b	刚体
		 * @return 对应包含b2PolygonShape顶点的Array数组
		 * 
		 */		
		public static function VectorToArray(v:Vector.<b2Vec2>):Array{
			var arr:Array = [];
			for each (var e:b2Vec2 in v) 
			{
				arr.push(e);
			}
			return arr;
		}
		public static function ArrayToVector(arr:Array):Vector.<b2Vec2>{
			var vertices:Vector.<b2Vec2> =  new Vector.<b2Vec2>();
			for each (var i:b2Vec2 in arr) 
			{
				vertices.push(i);
			}
			return vertices;
		}
		/**
		 * 将保存b2PolygonShape顶点的数组类型由Vector转换为Array数组 
		 * @param v	包含顶点的数组
		 * @param b	刚体
		 * @return 对应包含b2PolygonShape顶点的Array数组
		 * 
		 */		
		public static function VectorToGlobal(v:Vector.<b2Vec2>,b:b2Body):Vector.<b2Vec2>{
			var arr:Vector.<b2Vec2> = new Vector.<b2Vec2>();
			for each (var e:b2Vec2 in v) 
			{
				arr.push(b.GetWorldPoint(e));
			}
			return arr;
		}
		public static function drawVecAt(v:b2Vec2,at:b2Vec2,color:b2Color,markStart:Boolean=true):void
		{
			var p1:b2Vec2 = at.Copy();
			var p2:b2Vec2 = b2Math.AddVV(v,at);
			if(markStart) debug.DrawSolidCircle(p1,3/30,new b2Vec2(),color);
			debug.DrawSegment(p1,p2,color);
		}
		public static function drawVecTo(v:b2Vec2,to:b2Vec2,color:b2Color,markStart:Boolean=true):void
		{
			var p1:b2Vec2 = to.Copy();
			var p2:b2Vec2 = b2Math.SubtractVV(to,v);
			if(markStart) debug.DrawSolidCircle(p2,3/30,new b2Vec2(),color);
			debug.DrawSegment(p1,p2,color);
		}
		public static function drawAABB(aabb:b2AABB,color:b2Color):void
		{
			graphic = debug.GetSprite().graphics;
			graphic.lineStyle(1,color.color);
			graphic.moveTo(aabb.lowerBound.x*30,aabb.lowerBound.y*30);
			graphic.lineTo(aabb.upperBound.x*30,aabb.lowerBound.y*30);
			graphic.lineTo(aabb.upperBound.x*30,aabb.upperBound.y*30);
			graphic.lineTo(aabb.lowerBound.x*30,aabb.upperBound.y*30);
			graphic.lineTo(aabb.lowerBound.x*30,aabb.lowerBound.y*30);
		}
		public static function drawRect(center:b2Vec2,w:Number,h:Number,color):void{
			graphic = debug.GetSprite().graphics;
			graphic.lineStyle(1,color.color,debug.GetAlpha());
			graphic.drawRect(center.x*30-w*30,center.y*30-h*30,2*w*30,2*h*30);
		}
		private static var localAnchorA:b2Vec2, localAnchorB:b2Vec2, anchorA:b2Vec2,anchorB:b2Vec2;
		private static var jointType:int;
		private static var bodyA:b2Body,bodyB:b2Body;
		private static var posA:b2Vec2,posB:b2Vec2,axis:b2Vec2;
		public static function drawJoint(joint:b2Joint):void
		{
			jointType = joint.GetType();
			bodyA = joint.GetBodyA();
			bodyB = joint.GetBodyB();
			anchorA = joint.GetAnchorA();
			anchorB = joint.GetAnchorB();
			posA = bodyA.GetPosition();
			posB = bodyB.GetPosition();
			switch(jointType)
			{
				case b2Joint.e_revoluteJoint:
				{
					var revolute:b2RevoluteJoint = joint as b2RevoluteJoint;
					localAnchorA = bodyA.GetWorldPoint(revolute.m_localAnchor1);
					localAnchorB = bodyB.GetWorldPoint(revolute.m_localAnchor2);
					//local anchor
					debug.DrawCircle(localAnchorA,5/30,blue);
					debug.DrawCircle(localAnchorB,4/30,green);
					debug.DrawSegment(localAnchorA,posA,blue);
					debug.DrawSegment(localAnchorB,posB,green);
					//anchor
					debug.DrawPoint(anchorA,.1,black);
					break;
				}
				case b2Joint.e_distanceJoint:
				{
					var distance:b2DistanceJoint = joint as b2DistanceJoint;
					localAnchorA = bodyA.GetWorldPoint(distance.m_localAnchor1);
					localAnchorB = bodyB.GetWorldPoint(distance.m_localAnchor2);
					//local anchor
					debug.DrawCircle(localAnchorA,5/30,blue);
					debug.DrawCircle(localAnchorB,4/30,green);
					debug.DrawSegment(localAnchorA,posA,blue);
					debug.DrawSegment(localAnchorB,posB,green);
					
					anchorB.Subtract(anchorA);
					anchorB.Multiply(distance.m_length/anchorB.Length());
					anchorB.Add(anchorA);
					//anchor
					debug.DrawSegment(anchorA,anchorB,black);
					debug.DrawPoint(anchorA,.1,black);
					debug.DrawPoint(anchorB,.1,black);
					//frequency
					debug.DrawSegment(anchorB,localAnchorB,red);
					break;
				}
				case b2Joint.e_frictionJoint:
				{
					var friction:b2FrictionJoint = joint as b2FrictionJoint;
					localAnchorA = bodyA.GetWorldPoint(friction.m_localAnchorA);
					localAnchorB = bodyB.GetWorldPoint(friction.m_localAnchorB);
					//local anchor
					debug.DrawCircle(localAnchorA,5/30,blue);
					debug.DrawCircle(localAnchorB,4/30,green);
					debug.DrawSegment(localAnchorA,posA,blue);
					debug.DrawSegment(localAnchorB,posB,green);
					//anchor
					debug.DrawSegment(anchorA,anchorB,black);
					debug.DrawPoint(anchorA,.1,black);
					debug.DrawPoint(anchorB,.1,black);
					//frequency
					debug.DrawSegment(anchorB,localAnchorB,red);
					break;
				}
				case b2Joint.e_motorJoint:
				{
					var motor:b2MotorJoint = joint as b2MotorJoint;
					localAnchorA = posA;
					localAnchorB = posB;
					//local anchor
					debug.DrawCircle(localAnchorA,5/30,blue);
					debug.DrawCircle(localAnchorB,4/30,green);
					
					var r:b2Rot = new b2Rot(bodyA.GetAngle());
					anchorA = b2Math.AddVV(posA,b2Math.MulQV(r,motor.m_linearOffset));
					//anchor
					debug.DrawSegment(anchorA,localAnchorA,black);
					debug.DrawPoint(anchorA,.1,black);
					debug.DrawPoint(localAnchorA,.1,black);
					//frequency
					debug.DrawSegment(anchorA,localAnchorB,red);
					break;
				}
				case b2Joint.e_mouseJoint:
				{
					var mouse:b2MouseJoint = joint as b2MouseJoint;
					localAnchorA = mouse.m_target;
					localAnchorB = bodyB.GetWorldPoint(mouse.m_localAnchor);
					//local anchor
					debug.DrawCircle(localAnchorA,5/30,blue);
					debug.DrawCircle(localAnchorB,4/30,green);
					debug.DrawSegment(posB,localAnchorB,green);
					//anchor
					debug.DrawPoint(anchorA,.1,black);
					//frequency
					debug.DrawSegment(localAnchorB,localAnchorA,red);
					break;
				}
				case b2Joint.e_prismaticJoint:
				{
					var prismatic:b2PrismaticJoint = joint as b2PrismaticJoint;
					localAnchorA = bodyA.GetWorldPoint(prismatic.m_localAnchor1);
					localAnchorB = bodyB.GetWorldPoint(prismatic.m_localAnchor2);
					//local anchor
					drawRect(localAnchorA,5/30,5/30,blue);
					drawRect(localAnchorB,4/30,4/30,green);
					debug.DrawSegment(localAnchorA,posA,blue);
					debug.DrawSegment(localAnchorB,posB,green);
					//axis
					var pr:b2Rot = new b2Rot(bodyA.GetAngle());
					axis = b2Math.MulQV(pr,prismatic.m_localXAxis1);
					axis.Multiply(50);
					drawVecAt(axis,anchorA,gray,false);
					drawVecTo(axis,anchorA,gray,false);
					//anchor
					debug.DrawSegment(anchorA,anchorB,black);
					debug.DrawPoint(anchorA,.1,black);
					//limit
					if(prismatic.IsLimitEnabled()){
						axis.Normalize();
						axis.Multiply(prismatic.GetUpperLimit());
						drawVecAt(axis,anchorA,black,false);
						axis.Normalize();
						axis.Multiply(prismatic.GetLowerLimit());
						drawVecAt(axis,anchorA,black,false);
					}					
					break;
				}
				case b2Joint.e_lineJoint:
				{
					var line:b2LineJoint = joint as b2LineJoint;
					localAnchorA = bodyA.GetWorldPoint(line.m_localAnchor1);
					localAnchorB = bodyB.GetWorldPoint(line.m_localAnchor2);
					//local anchor
					debug.DrawCircle(localAnchorA,5/30,blue);
					debug.DrawCircle(localAnchorB,4/30,green);
					debug.DrawSegment(localAnchorA,posA,blue);
					debug.DrawSegment(localAnchorB,posB,green);
					//axis
					axis = line.m_localXAxis1.Copy();
					axis.Multiply(50);
					drawVecAt(axis,anchorA,gray,false);
					drawVecTo(axis,anchorA,gray,false);
					//anchor
					debug.DrawSegment(anchorA,anchorB,black);
					debug.DrawPoint(anchorA,.1,black);
					debug.DrawPoint(anchorB,.1,black);
					//limit
					if(line.IsLimitEnabled()){
						axis.Normalize();
						axis.Multiply(line.GetUpperLimit());
						drawVecAt(axis,anchorA,black,false);
						axis.Normalize();
						axis.Multiply(line.GetLowerLimit());
						drawVecAt(axis,anchorA,black,false);
					}					
					break;
				}
				case b2Joint.e_pulleyJoint:
				{
					var pulley:b2PulleyJoint = joint as b2PulleyJoint;
					var gAnchorA:b2Vec2 = pulley.GetGroundAnchorA();
					var gAnchorB:b2Vec2 = pulley.GetGroundAnchorB();
					localAnchorA = bodyA.GetWorldPoint(pulley.m_localAnchor1);
					localAnchorB = bodyB.GetWorldPoint(pulley.m_localAnchor2);
					//local anchor
					debug.DrawCircle(localAnchorA,5/30,blue);
					debug.DrawCircle(localAnchorB,4/30,green);
					debug.DrawSegment(localAnchorA,posA,blue);
					debug.DrawSegment(localAnchorB,posB,green);
					//ground anchor
					debug.DrawCircle(gAnchorA,3/30,black);
					debug.DrawCircle(gAnchorB,3/30,black);
					debug.DrawSegment(gAnchorA,localAnchorA,black);
					debug.DrawSegment(gAnchorB,localAnchorB,black);
					break;
				}
				case b2Joint.e_ropeJoint:
				{
					var rope:b2RopeJoint = joint as b2RopeJoint;
					localAnchorA = bodyA.GetWorldPoint(rope.m_localAnchor1);
					localAnchorB = bodyB.GetWorldPoint(rope.m_localAnchor2);
					//local anchor
					debug.DrawCircle(localAnchorA,5/30,blue);
					debug.DrawCircle(localAnchorB,4/30,green);
					debug.DrawSegment(localAnchorA,posA,blue);
					debug.DrawSegment(localAnchorB,posB,green);
					debug.DrawCircle(anchorA,rope.GetMaxLength(),gray);
					//anchor
					anchorB.Subtract(anchorA);
					anchorB.Multiply(rope.GetMaxLength()/anchorB.Length());
					anchorB.Add(anchorA);
					debug.DrawSegment(anchorA,anchorB,black);
					debug.DrawPoint(anchorA,.1,black);
					debug.DrawPoint(anchorB,.1,black);
					break;
				}
				case b2Joint.e_weldJoint:
				{
					var weld:b2WeldJoint = joint as b2WeldJoint;
					localAnchorA = bodyA.GetWorldPoint(weld.GetLocalAnchorA());
					localAnchorB = bodyB.GetWorldPoint(weld.GetLocalAnchorB());
					//local anchor
					debug.DrawCircle(localAnchorA,5/30,blue);
					debug.DrawCircle(localAnchorB,4/30,green);
					debug.DrawSegment(localAnchorA,posA,blue);
					debug.DrawSegment(localAnchorB,posB,green);
					//anchor
					debug.DrawPoint(anchorA,.1,black);
					//frequency
					debug.DrawSegment(anchorB,localAnchorB,red);
					break;
				}
				case b2Joint.e_wheelJoint:
				{
					var wheel:b2WheelJoint = joint as b2WheelJoint;
					localAnchorA = bodyA.GetWorldPoint(wheel.m_localAnchorA);
					localAnchorB = bodyB.GetWorldPoint(wheel.m_localAnchorB);
					//local anchor
					drawRect(localAnchorA,5/30,5/30,blue);
					debug.DrawCircle(localAnchorB,4/30,green);
					debug.DrawSegment(localAnchorA,posA,blue);
					debug.DrawSegment(localAnchorB,posB,green);
					//axis
					axis = wheel.m_localXAxisA.Copy();
					var wr:b2Rot = new b2Rot(bodyA.GetAngle());
					axis = b2Math.MulQV(wr,axis);
					axis.Multiply(50);
					drawVecAt(axis,anchorA,gray,false);
					drawVecTo(axis,anchorA,gray,false);
					//anchor
					debug.DrawSegment(anchorA,anchorB,black);
					debug.DrawPoint(anchorA,.1,black);
					//frequency
					debug.DrawSegment(anchorA,localAnchorB,red);					
					break;
				}
				case b2Joint.e_gearJoint:
				{
					var gear:b2GearJoint = joint as b2GearJoint;
					drawJoint(gear.GetJoint1());
					drawJoint(gear.GetJoint2());
					break;
				}
				default:
				{
					break;
				}
			}
		}
	}
}