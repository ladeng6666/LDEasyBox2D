package ldEasyBox2D.tools
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	import Box2D.Common.Math.b2Math;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	
	public class LDBodyTrail extends Sprite
	{
		public var trailDistance:Number;
		private var dotSize:int=1;
		private var birdPrePos:b2Vec2;
		private var bird:b2Body;
		private var trailSprite:Sprite;
		private var trailColor:uint = 0;
		
		public function LDBodyTrail(parent:DisplayObjectContainer,body:b2Body, dotDistance:Number=20)
		{
			parent.addChild(this);
			bird = body;
			birdPrePos = bird.GetPosition().Copy();
			trailDistance = dotDistance;
			
			trailSprite = new Sprite();
			addChild(trailSprite);
			setTrailColor(0);
		}
		
		public function update():void
		{
			drawDotTo(bird.GetPosition());
		}
		public function clear():void
		{
			trailSprite.graphics.clear();
		}
		public function startFromHere():void{
			clear();
			birdPrePos = bird.GetPosition().Copy();
		}
		public function setTrailColor(color:uint):void
		{
			trailColor = color;
		}
		private function drawDotTo(birdCurPos:b2Vec2):void
		{
			trailSprite.graphics.lineStyle(1,trailColor,0.5);
			var distance:Number = b2Math.Distance(birdCurPos,birdPrePos);
			var distanceVector:b2Vec2;
			while(distance >trailDistance/30){
				distanceVector= b2Math.SubtractVV(birdCurPos,birdPrePos);
				distanceVector.Multiply(trailDistance/30/distance);
				birdPrePos.Add(distanceVector);
				
				dotSize = Math.random()>0.5?2:1;
				trailSprite.graphics.drawCircle(birdPrePos.x*30,birdPrePos.y*30,dotSize);
				trailSprite.graphics.endFill();
				
				distance = b2Math.Distance(birdCurPos,birdPrePos);
			}
		}
	}
}