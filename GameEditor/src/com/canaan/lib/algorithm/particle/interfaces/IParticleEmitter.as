package com.canaan.lib.algorithm.particle.interfaces
{
	import com.canaan.lib.algorithm.particle.Particle;
	import com.canaan.lib.utils.Position3;

	/**
	 * 粒子发射器接口
	 * @author Administrator
	 * 
	 */	
	public interface IParticleEmitter
	{
		/**
		 * 绑定粒子生成器
		 * @param generator
		 * 
		 */		
		function attachGenerator(generator:IParticleGenerator):void;
		
		/**
		 * 设置发射位置
		 * @param position
		 * 
		 */		
		function setPosition(position:Position3):void;
		
		/**
		 * 发射粒子
		 * @return 
		 * 
		 */		
		function emitParticle():Particle;
	}
}