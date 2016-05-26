package com.canaan.lib.algorithm.particle.cleaner
{
	import com.canaan.lib.algorithm.particle.Particle;
	import com.canaan.lib.algorithm.particle.interfaces.IParticleCleaner;
	
	/**
	 * 距离限制粒子清除器
	 * @author Administrator
	 * 
	 */	
	public class DistanceLimitParticleCleaner implements IParticleCleaner
	{
		protected var mDistanceX:Number = 0;							// x轴距离
		protected var mDistanceY:Number = 0;							// y轴距离
		protected var mDistanceZ:Number = 0;							// z轴距离
		
		public function DistanceLimitParticleCleaner()
		{
		}
		
		public function cleanParticle(particle:Particle):Boolean {
			if (mDistanceX > 0.1 && Math.abs(particle.position.x - particle.originPosition.x) >= mDistanceX) {
				particle.isAlive = false;
			} else if (mDistanceY > 0.1 && Math.abs(particle.position.y - particle.originPosition.y) >= mDistanceY) {
				particle.isAlive = false;
			} else if (mDistanceZ > 0.1 && Math.abs(particle.position.z - particle.originPosition.z) >= mDistanceZ) {
				particle.isAlive = false;
			}
			return !particle.isAlive;
		}
		
		public function setDistance(x:Number, y:Number, z:Number):void {
			mDistanceX = x;
			mDistanceY = y;
			mDistanceZ = z;
		}
	}
}