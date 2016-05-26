package com.canaan.lib.algorithm.particle.cleaner
{
	import com.canaan.lib.algorithm.particle.Particle;
	import com.canaan.lib.algorithm.particle.interfaces.IParticleCleaner;
	
	/**
	 * 年龄限制粒子清除器
	 * @author Administrator
	 * 
	 */	
	public class AgeLimitParticleCleaner implements IParticleCleaner
	{
		protected var mAgeLimit:Number;
		
		public function AgeLimitParticleCleaner()
		{
			mAgeLimit = -1;
		}
		
		/**
		 * 清除粒子
		 * @param particle
		 * @return 
		 * 
		 */		
		public function cleanParticle(particle:Particle):Boolean {
			if (particle.maxAge > 0) {
				if (particle.age >= particle.maxAge) {
					particle.isAlive = false;
				}
			}
			if (mAgeLimit > 0) {
				if (particle.age >= mAgeLimit) {
					particle.isAlive = false;
				}
			}
			return !particle.isAlive;
		}
		
		/**
		 * 设置年龄限制
		 * @param ageLimit
		 * 
		 */		
		public function setAgeLimit(ageLimit:Number):void {
			mAgeLimit = ageLimit;
		}
	}
}