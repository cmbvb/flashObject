package com.canaan.lib.algorithm.particle.updater
{
	import com.canaan.lib.algorithm.particle.Particle;
	import com.canaan.lib.algorithm.particle.interfaces.IParticleUpdater;
	
	/**
	 * X轴加速度运动粒子更新器
	 * @author Administrator
	 * 
	 */	
	public class XAccelerateParticleUpdater implements IParticleUpdater
	{
		protected var mXAcceleration:Number;						// 加速度
		
		public function XAccelerateParticleUpdater()
		{
			mXAcceleration = 0;
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
			if (mXAcceleration == 0) {
				return;
			}
			var positionOffset:Number = 0.5 * mXAcceleration * deltaTime * deltaTime;
			var velocityOffset:Number = mXAcceleration * deltaTime;
			if (particle.velocity.x > 0) {
				particle.position.x += positionOffset;
				particle.velocity.x += velocityOffset;
			} else {
				particle.position.x -= positionOffset;
				particle.velocity.x -= velocityOffset;
			}
		}
		
		/**
		 * 设置X轴加速度
		 * @param acceleration
		 * 
		 */		
		public function setXAcceleration(acceleration:Number):void {
			mXAcceleration = acceleration;
		}
	}
}