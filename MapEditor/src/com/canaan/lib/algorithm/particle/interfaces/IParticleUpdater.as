package com.canaan.lib.algorithm.particle.interfaces
{
	import com.canaan.lib.algorithm.particle.Particle;

	/**
	 * 粒子更新器接口
	 * @author Administrator
	 * 
	 */	
	public interface IParticleUpdater
	{
		/**
		 * 更新粒子
		 * @param deltaTime
		 * @param particle
		 * 
		 */		
		function updateParticle(deltaTime:Number, particle:Particle):void;
	}
}