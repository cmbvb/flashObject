package com.canaan.lib.algorithm.particle.emitter
{
	import com.canaan.lib.algorithm.particle.Particle;
	import com.canaan.lib.algorithm.particle.interfaces.IParticleEmitter;
	import com.canaan.lib.algorithm.particle.interfaces.IParticleGenerator;
	import com.canaan.lib.utils.MathUtil;
	import com.canaan.lib.utils.Position3;
	import com.canaan.lib.utils.Range2;
	
	/**
	 * XY平面粒子发射器
	 * @author Administrator
	 * 
	 */	
	public class XYPlaneParticleEmitter implements IParticleEmitter
	{
		protected var mOriginPosition:Position3;							// 原点位置
		protected var mVelocity:Position3;									// 发射速度
		protected var mGenerator:IParticleGenerator;						// 粒子生成器
		protected var mRangeX:Range2;										// x轴范围
		protected var mRangeY:Range2;										// y轴范围
		
		public function XYPlaneParticleEmitter()
		{
			mOriginPosition = new Position3();
			mVelocity = new Position3();
			mRangeX = new Range2();
			mRangeY = new Range2();
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
			// 计算粒子坐标
			var position:Position3 = new Position3();
			position.copy(mOriginPosition);
			position.x += MathUtil.randRange(mRangeX.min, mRangeX.max);
			position.y += MathUtil.randRange(mRangeY.min, mRangeY.max);
			// 生成粒子
			var particle:Particle = mGenerator.generateParticle();
			particle.originPosition.copy(position);
			particle.position.copy(position);
			particle.velocity.copy(mVelocity);
			return particle;
		}
		
		/**
		 * 设置x轴范围
		 * @param min
		 * @param max
		 * 
		 */		
		public function setXRange(min:Number, max:Number):void {
			mRangeX.min = min;
			mRangeX.max = max;
		}
		
		/**
		 * 设置y轴范围
		 * @param min
		 * @param max
		 * 
		 */		
		public function setYRange(min:Number, max:Number):void {
			mRangeY.min = min;
			mRangeY.max = max;
		}
	}
}