package com.canaan.lib.algorithm.particle.updater
{
	import com.canaan.lib.algorithm.particle.Particle;
	import com.canaan.lib.algorithm.particle.interfaces.IParticleUpdater;

	/**
	 * 重力粒子更新器
	 * @author Administrator
	 * 
	 */	
	public class GravityParticleUpdater implements IParticleUpdater
	{
		protected var mGravity:Number;							// 重力
		
		public function GravityParticleUpdater()
		{
			super();
			mGravity = 0;
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
			if (mGravity == 0) {
				return;
			}
			if (particle.position.z > 0) {
				particle.position.z -= 0.5 * mGravity * deltaTime * deltaTime;
				if (particle.position.z < 0) {
					particle.position.z = 0;
				}
				particle.velocity.z -= mGravity * deltaTime;
			}
		}
		
		/**
		 * 设置重力
		 * @param gravity
		 * 
		 */		
		public function setGravity(gravity:Number):void {
			mGravity = gravity;
		}
	}
}