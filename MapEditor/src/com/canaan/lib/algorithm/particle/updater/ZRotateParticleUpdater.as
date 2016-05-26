package com.canaan.lib.algorithm.particle.updater
{
	import com.canaan.lib.algorithm.particle.Particle;
	import com.canaan.lib.algorithm.particle.interfaces.IParticleUpdater;
	import com.canaan.lib.utils.MathUtil;
	
	/**
	 * Z轴旋转粒子更新器
	 * @author Administrator
	 * 
	 */	
	public class ZRotateParticleUpdater implements IParticleUpdater
	{
		public function ZRotateParticleUpdater()
		{
		}
		
		/**
		 * 更新粒子
		 * @param deltaTime
		 * @param particle
		 * 
		 */		
		public function updateParticle(deltaTime:Number, particle:Particle):void {
			if (particle.parse) {
				return;
			}
			if (particle.velocity.x == 0) {
				return;
			}
			if (particle.velocity.z == 0) {
				particle.rotateZ = 0;
				return;
			}
			var tanZX:Number = particle.velocity.z / particle.velocity.x;
			var radian:Number = Math.atan(tanZX);
			particle.rotateZ = -MathUtil.radianToAngle(radian);
		}
	}
}