package com.canaan.lib.algorithm.particle.emitter
{
	import com.canaan.lib.algorithm.particle.Particle;
	import com.canaan.lib.algorithm.particle.interfaces.IParticleEmitter;
	import com.canaan.lib.algorithm.particle.interfaces.IParticleGenerator;
	import com.canaan.lib.utils.Position3;
	
	/**
	 * 点坐标粒子发射器
	 * @author Administrator
	 * 
	 */	
	public class PointParticleEmitter implements IParticleEmitter
	{
		protected var mOriginPosition:Position3;							// 原点位置
		protected var mVelocity:Position3;									// 发射速度
		protected var mGenerator:IParticleGenerator;						// 粒子生成器
		
		public function PointParticleEmitter()
		{
			mOriginPosition = new Position3();
			mVelocity = new Position3();
		}
		
		/**
		 * 设置粒子速度
		 * @param velocity
		 * 
		 */		
		public function setParticleVelocity(velocity:Position3):void {
			mVelocity.copy(velocity);
		}
		
		/**
		 * 绑定粒子生成器
		 * @param generator
		 * 
		 */		
		public function attachGenerator(generator:IParticleGenerator):void {
			mGenerator = generator;
		}
		
		/**
		 * 设置发射位置
		 * @param position
		 * 
		 */		
		public function setPosition(position:Position3):void {
			mOriginPosition.copy(position);
		}
		
		/**
		 * 发射粒子
		 * @return 
		 * 
		 */		
		public function emitParticle():Particle {
			if (mGenerator == null) {
				return null;
			}
			// 生成粒子
			var particle:Particle = mGenerator.generateParticle();
			particle.originPosition.copy(mOriginPosition);
			particle.position.copy(mOriginPosition);
			particle.velocity.copy(mVelocity);
			return particle;
		}
	}
}