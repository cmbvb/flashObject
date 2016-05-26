package com.canaan.lib.algorithm.particle.cleaner
{
	import com.canaan.lib.algorithm.particle.Particle;
	import com.canaan.lib.algorithm.particle.interfaces.IParticleCleaner;
	
	/**
	 * Z轴高度粒子清除器
	 * @author Administrator
	 * 
	 */	
	public class ZHeightParticleCleaner implements IParticleCleaner
	{
		protected var mZHeight:Number;
		
		public function ZHeightParticleCleaner()
		{
		}
		
		public function cleanParticle(particle:Particle):Boolean {
			// 当粒子下落时判断高度
			if (particle.velocity.z < 0 && particle.position.z < mZHeight) {
				particle.isAlive = false;
			}
			return !particle.isAlive;
		}
		
		public function setZHeight(zHeight:Number):void {
			mZHeight = zHeight;
		}
	}
}