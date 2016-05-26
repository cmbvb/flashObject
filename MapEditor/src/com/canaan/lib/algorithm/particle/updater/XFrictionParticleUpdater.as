package com.canaan.lib.algorithm.particle.updater
{
	import com.canaan.lib.algorithm.particle.Particle;
	import com.canaan.lib.algorithm.particle.interfaces.IParticleUpdater;
	
	/**
	 * X轴摩擦力粒子更新器
	 * @author Administrator
	 * 
	 */	
	public class XFrictionParticleUpdater implements IParticleUpdater
	{
		protected var mXFriction:Number;								// 摩擦力
		
		public function XFrictionParticleUpdater()
		{
			mXFriction = 0;
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
			if (mXFriction == 0) {
				return;
			}
			if (particle.position.z < 0.1) {
				var offsetX:Number;
				var frictionOffset:Number;
				if (particle.velocity.x > 0) {
					offsetX = particle.position.x - particle.lastPosition.x;
					frictionOffset = 0.5 * mXFriction * deltaTime * deltaTime;
					if (frictionOffset > offsetX) {
						frictionOffset = offsetX;
					}
					particle.position.x -= frictionOffset;
					particle.velocity.x -= mXFriction * deltaTime;
					if (particle.velocity.x < 0) {
						particle.velocity.x = 0;
					}
				} else if (particle.velocity.x < 0) {
					offsetX = particle.position.x - particle.lastPosition.x;
					frictionOffset = 0.5 * mXFriction * deltaTime * deltaTime;
					if (frictionOffset < offsetX) {
						frictionOffset = offsetX;
					}
					particle.position.x += frictionOffset;
					particle.velocity.x += mXFriction * deltaTime;
					if (particle.velocity.x > 0) {
						particle.velocity.x = 0;
					}
				}
			}
		}
		
		/**
		 * 设置摩擦力
		 * @param friction
		 * 
		 */		
		public function setXFriction(friction:Number):void {
			mXFriction = friction;
		}
	}
}