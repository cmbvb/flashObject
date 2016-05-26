package com.canaan.lib.algorithm.particle.interfaces
{
	import com.canaan.lib.algorithm.particle.Particle;

	/**
	 * 粒子清除器接口
	 * @author Administrator
	 * 
	 */	
	public interface IParticleCleaner
	{
		/**
		 * 清除粒子
		 * @param particle
		 * @return 
		 * 
		 */		
		function cleanParticle(particle:Particle):Boolean;
	}
}