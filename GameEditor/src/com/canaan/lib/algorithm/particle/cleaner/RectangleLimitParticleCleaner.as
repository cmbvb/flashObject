package com.canaan.lib.algorithm.particle.cleaner
{
	import com.canaan.lib.algorithm.particle.Particle;
	import com.canaan.lib.algorithm.particle.interfaces.IParticleCleaner;
	
	import flash.geom.Rectangle;
	
	/**
	 * 矩形范围限制粒子清除器
	 * @author Administrator
	 * 
	 */	
	public class RectangleLimitParticleCleaner implements IParticleCleaner
	{
		protected var mRect:Rectangle;										// 矩形范围
		
		public function RectangleLimitParticleCleaner()
		{
		}
		
		public function cleanParticle(particle:Particle):Boolean
		{
			if (mRect == null) {
				return false;
			}
			if (particle.position.x < mRect.left || particle.position.x > mRect.right || particle.position.y < mRect.top || particle.position.y > mRect.bottom) {
				particle.isAlive = false;
			}
			return !particle.isAlive;
		}
		
		/**
		 * 设置矩形范围
		 * @param rect
		 * 
		 */		
		public function setRectangle(rect:Rectangle):void {
			mRect = rect.clone();
		}
	}
}