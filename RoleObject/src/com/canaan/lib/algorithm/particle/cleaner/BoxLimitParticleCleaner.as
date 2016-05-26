package com.canaan.lib.algorithm.particle.cleaner
{
	import com.canaan.lib.algorithm.particle.Particle;
	import com.canaan.lib.algorithm.particle.interfaces.IParticleCleaner;
	import com.canaan.lib.utils.Range2;
	
	/**
	 * 范围限制粒子清除器
	 * @author Administrator
	 * 
	 */	
	public class BoxLimitParticleCleaner implements IParticleCleaner
	{
		protected var mRangeX:Range2;								// x轴范围
		protected var mRangeY:Range2;								// y轴范围
		protected var mRangeZ:Range2;								// z轴范围
		
		public function BoxLimitParticleCleaner()
		{
		}
		
		public function cleanParticle(particle:Particle):Boolean
		{
			if (mRangeX != null && particle.position.x < mRangeX.min || particle.position.x > mRangeX.max) {
				particle.isAlive = false;
			} else if (mRangeY != null && particle.position.y < mRangeY.min || particle.position.y > mRangeY.max) {
				particle.isAlive = false;
			} else if (mRangeZ != null && particle.position.z < mRangeZ.min || particle.position.z > mRangeZ.max) {
				particle.isAlive = false;
			}
			return !particle.isAlive;
		}
		
		/**
		 * 设置x轴范围
		 * @param min
		 * @param max
		 * 
		 */		
		public function setXRange(min:Number, max:Number):void {
			if (mRangeX == null) {
				mRangeX = new Range2();
			}
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
			if (mRangeY == null) {
				mRangeY = new Range2();
			}
			mRangeY.min = min;
			mRangeY.max = max;
		}
		
		/**
		 * 设置z轴范围
		 * @param min
		 * @param max
		 * 
		 */		
		public function setZRange(min:Number, max:Number):void {
			if (mRangeZ == null) {
				mRangeZ = new Range2();
			}
			mRangeZ.min = min;
			mRangeZ.max = max;
		}
	}
}