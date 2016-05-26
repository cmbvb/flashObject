package com.canaan.lib.algorithm.particle.interfaces
{
	import com.canaan.lib.algorithm.particle.Particle;

	/**
	 * 粒子生成器接口
	 * @author Administrator
	 * 
	 */	
	public interface IParticleGenerator
	{
		/**
		 * 生成粒子
		 * @return 
		 * 
		 */		
		function generateParticle():Particle;
	}
}