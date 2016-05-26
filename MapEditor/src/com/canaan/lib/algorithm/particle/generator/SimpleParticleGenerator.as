package com.canaan.lib.algorithm.particle.generator
{
	import com.canaan.lib.algorithm.particle.Particle;
	import com.canaan.lib.algorithm.particle.interfaces.IParticleGenerator;
	
	/**
	 * 简单粒子生成器
	 * @author Administrator
	 * 
	 */	
	public class SimpleParticleGenerator implements IParticleGenerator
	{
		public function SimpleParticleGenerator()
		{
		}
		
		public function generateParticle():Particle {
			return new Particle();
		}
	}
}