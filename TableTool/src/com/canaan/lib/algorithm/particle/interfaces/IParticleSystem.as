package com.canaan.lib.algorithm.particle.interfaces
{
	import com.canaan.lib.utils.Position3;

	/**
	 * 粒子系统接口
	 * @author Administrator
	 * 
	 */	
	public interface IParticleSystem
	{
		/**
		 * 设置粒子发射器
		 * @param emitter
		 * 
		 */		
		function setParticleEmitter(emitter:IParticleEmitter):void;
		
		/**
		 * 设置粒子生成器
		 * @param generator
		 * 
		 */		
		function setParticleGenerator(generator:IParticleGenerator):void;
		
		/**
		 * 添加粒子清除器
		 * @param cleaner
		 * 
		 */		
		function addParticleCleaner(cleaner:IParticleCleaner):void;
		
		/**
		 * 移除粒子清除器
		 * @param cleaner
		 * 
		 */		
		function removeParticleCleaner(cleaner:IParticleCleaner):void;
		
		/**
		 * 添加粒子更新器
		 * @param updater
		 * 
		 */		
		function addParticleUpdater(updater:IParticleUpdater):void;
		
		/**
		 * 移除粒子更新器
		 * @param updater
		 * 
		 */		
		function removeParticleUpdater(updater:IParticleUpdater):void;
		
		/**
		 * 开始
		 * 
		 */		
		function start():void;
		
		/**
		 * 停止
		 * 
		 */		
		function stop():void;
		
		/**
		 * 设置粒子发射器位置
		 * @param position
		 * 
		 */		
		function setPosition(position:Position3):void;
		
		/**
		 * 更新
		 * @param deltaTime
		 * 
		 */		
		function update(deltaTime:Number):void;
	}
}