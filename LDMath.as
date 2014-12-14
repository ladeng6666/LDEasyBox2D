package ldEasyBox2D
{
	import Box2D.Common.Math.b2Math;
	import Box2D.Common.Math.b2Vec2;

	public class LDMath
	{
		public function LDMath()
		{
		}
//		/**
//		 * 获取大小与v相同，方向朝向v左侧并垂直v的向量 
//		 * @param v
//		 * @return 
//		 * 
//		 */		
//		public static function getLeftNormal(v:b2Vec2):b2Vec2{
//			var ln:b2Vec2 = new b2Vec2();
//			ln.x = v.y;
//			ln.y = -v.x;
//			return ln;
//		}
//		
//		public static function getRightNormal(v:b2Vec2):b2Vec2
//		{
//			var rn:b2Vec2 = new b2Vec2();
//			rn.x = -v.y;
//			rn.y = v.x;
//			return rn;
//		}
		/**
		 *返回向量v的单位向量，表示向量v的方向 
		 * @param v
		 * @return 
		 * 
		 */		
		public static function getNormal(v:b2Vec2):b2Vec2
		{
			var n:b2Vec2 = new b2Vec2();
			if (v.Length()>0) 
			{
				n.x = v.x/v.Length();
				n.y = v.y/v.Length();
			}
			return n;
		}
		public static function getAngle(v:b2Vec2):Number
		{
			return Math.atan2(v.y,v.x);
		}
		/**
		 * 计算两个向量的点乘积，返回值有两个含义，其正负通常用来判断v1和v2的方向是否相同，返回值大小表示v1映射到v2上的线段是长度 <br>
		 * <ul>
		 * 		<li>返回值>0：v1和v2方向一致</li>
		 * 		<li>返回值<0：v1和v2方向相反 </li>
		 * <ul>
		 * @param v1 向量1
		 * @param v2 向量2
		 * @return 
		 * 
		 */		
//		public static function dotProduct(v1:b2Vec2,v2:b2Vec2):Number
//		{
//			var n2:b2Vec2 = getNormal(v2);
//			return v1.x*n2.x + v1.y*n2.y;
//		}
		/**
		 *垂直映射，其返回值有两个含义：其正负表示v1朝向v2的左边还是右边，其大小表示v1在垂直v2方向上映射线段的大小
		 * <ul>
		 * 	<li>返回值>0：v1朝向v2的左侧</li>
		 * 	<li>返回值<0：v1朝向v2的右侧</li>
		 * </ul> 
		 * @param v1
		 * @param v2
		 * @return 
		 * 
		 */		
//		public static function perpProduct(v1:b2Vec2,v2:b2Vec2):Number
//		{
//			var ln1:b2Vec2 = getLeftNormal(v1);
//			var perpProduct:Number = dotProduct(ln1,v2);
//			
//			if(perpProduct != 0)
//			{
//				return perpProduct;
//			}
//			else
//			{
//				return 1;
//			}	
//		}
		/**
		 * 计算v1对v2的映射向量 
		 * @param v1
		 * @param v2
		 * @return 
		 * 
		 */		
//		static public function project(v1:b2Vec2, v2:b2Vec2):b2Vec2 
//		{
//			var dp1:Number = dotProduct(v1, v2);
//			var normal2:b2Vec2 = getNormal(v2);
//			
//			var vx:Number = dp1 * normal2.x;
//			var vy:Number = dp1 * normal2.y;
//			
//			var projectionVector:b2Vec2 = new b2Vec2(vx,vy);
//			return projectionVector;
//		}
		/**
		 *计算并返回向量v1对向量v2的反射向量 
		 * @param v1	射向v2的向量
		 * @param v2	作为镜面的向量v2
		 * @return 
		 * 
		 */		
//		static public function bounce(v1:b2Vec2, v2:b2Vec2):b2Vec2 
//		{
//			//Find the projection onto v2
//			var p1:b2Vec2 = project(v1, v2);
//			var ln2:b2Vec2 = getLeftNormal(v2);
//			//Find the projection onto v2's normal
//			var p2:b2Vec2 = project(v1, ln2);
//			
//			//Calculate the bounce vector by adding up the projections
//			//and reversing the projection onto the normal
//			var bounceVx:Number = p1.x + (p2.x * -1);
//			var bounceVy:Number = p1.y + (p2.y * -1);
//			
//			//Create a bounce b2Vec2 to return to the caller
//			var bounceVector:b2Vec2 = new b2Vec2(bounceVx, bounceVy);
//			
//			return bounceVector;
//		}
		/**
		 *计算并返回向量v1以v2为轴的对称向量 
		 * @param v1	要对称的向量
		 * @param v2	对称轴
		 * @return 
		 * 
		 */		
//		public static function symmetric(v1:b2Vec2,v2:b2Vec2):b2Vec2
//		{
//			var ln2:b2Vec2 = getLeftNormal(v2);
//			var bnc:b2Vec2 = bounce(v1,ln2);
//			var sym:b2Vec2 = new b2Vec2();
//			
//			sym.x = -bnc.x;
//			sym.y = -bnc.y;
//			return sym;
//		}
//		public static function getCrossPoint(ap1:b2Vec2,ap2:b2Vec2,bp1:b2Vec2,bp2:b2Vec2):b2Vec2
//		{
//			var va:b2Vec2 = b2Math.SubtractVV(ap2,ap1);
//			var vb:b2Vec2 = b2Math.SubtractVV(bp2,bp1);
//			var v:b2Vec2 = b2Math.SubtractVV(ap1,bp1);
//			if (perpProduct(va,b2Math.SubtractVV(bp1,ap1))*perpProduct(va,b2Math.SubtractVV(bp2,ap1))>0) return null;
//			if (perpProduct(vb,b2Math.SubtractVV(ap1,bp1))*perpProduct(vb,b2Math.SubtractVV(ap2,bp1))>0) return null;
//			
//			var t:Number = perpProduct(v,va)/perpProduct(vb,va);
//			var crossPoint:b2Vec2 = bp1.Copy();
//			crossPoint.Add(b2Math.MulFV(t,vb));
//			return crossPoint;
//		}
	}
}