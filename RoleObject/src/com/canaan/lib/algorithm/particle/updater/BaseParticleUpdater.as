package com.canaan.lib.algorithm.particle.updater
{
	import com.canaan.lib.algorithm.particle.Particle;
	import com.canaan.lib.algorithm.particle.interfaces.IParticleUpdater;
	
	/**
	 * 基础粒子更新器
	 * @author Administrator
	 * 
	 */	
	public class BaseParticleUpdater implements IParticleUpdater
	{
		public function BaseParticleUpdater()
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
			particle.age += deltaTime;
			particle.bakLastPosition();
			particle.position.x += particle.velocity.x * deltaTime;
			particle.position.y += particle.velocity.y * deltaTime;
			particle.position.z += particle.velocity.z * deltaTime;
			if (particle.position.z < 0) {
				particle.position.z = 0;
			}
		}
	}
}