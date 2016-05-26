package com.canaan.lib.algorithm.particle
{
	import com.canaan.lib.algorithm.particle.interfaces.IParticleCleaner;
	import com.canaan.lib.algorithm.particle.interfaces.IParticleEmitter;
	import com.canaan.lib.algorithm.particle.interfaces.IParticleGenerator;
	import com.canaan.lib.algorithm.particle.interfaces.IParticleSystem;
	import com.canaan.lib.algorithm.particle.interfaces.IParticleUpdater;
	import com.canaan.lib.utils.Position3;

	/**
	 * 粒子系统
	 * @author Administrator
	 * 
	 */	
	public class ParticleSystem implements IParticleSystem
	{
		protected var mEmitter:IParticleEmitter;							// 粒子发射器
		protected var mGenerator:IParticleGenerator;						// 粒子生成器
		protected var mParticles:Vector.<Particle>;							// 粒子列表
		protected var mCleaners:Vector.<IParticleCleaner>;					// 粒子清除器列表
		protected var mUpdaters:Vector.<IParticleUpdater>;					// 粒子更新器列表
		protected var mIsStart:Boolean;										// 启动状态
		protected var mAliveParticleCount:int;								// 存活粒子数量
		
		public function ParticleSystem()
		{
			mParticles = new Vector.<Particle>();
			mCleaners = new Vector.<IParticleCleaner>();
			mUpdaters = new Vector.<IParticleUpdater>();
		}
		
		/**
		 * 设置粒子发射器
		 * @param emitter
		 * 
		 */		
		public function setParticleEmitter(emitter:IParticleEmitter):void {
			mEmitter = emitter;
			mEmitter.attachGenerator(mGenerator);
		}
		
		/**
		 * 设置粒子生成器
		 * @param generator
		 * 
		 */		
		public function setParticleGenerator(generator:IParticleGenerator):void {
			mGenerator = generator;
			if (mEmitter != null) {
				mEmitter.attachGenerator(mGenerator);
			}
		}
		
		/**
		 * 添加粒子清除器
		 * @param cleaner
		 * 
		 */		
		public function addParticleCleaner(cleaner:IParticleCleaner):void {
			mCleaners.push(cleaner);
		}
		
		/**
		 * 移除粒子清除器
		 * @param cleaner
		 * 
		 */		
		public function removeParticleCleaner(cleaner:IParticleCleaner):void {
			var index:int = mCleaners.indexOf(cleaner);
			if (index != -1) {
				mCleaners.splice(index, 1);
			}
		}
		
		/**
		 * 添加粒子更新器
		 * @param updater
		 * 
		 */		
		public function addParticleUpdater(updater:IParticleUpdater):void {
			mUpdaters.push(updater);
		}
		
		/**
		 * 移除粒子更新器
		 * @param updater
		 * 
		 */		
		public function removeParticleUpdater(updater:IParticleUpdater):void {
			var index:int = mUpdaters.indexOf(updater);
			if (index != -1) {
				mUpdaters.splice(index, 1);
			}
		}
		
		/**
		 * 开始
		 * 
		 */		
		public function start():void {
			mIsStart = true;
		}
		
		/**
		 * 停止
		 * 
		 */		
		public function stop():void {
			mIsStart = false;
		}
		
		/**
		 * 设置粒子发射位置
		 * @param position
		 * 
		 */		
		public function setPosition(position:Position3):void {
			if (mEmitter != null) {
				mEmitter.setPosition(position);
			}
		}
		
		/**
		 * 更新粒子
		 * @param deltaTime
		 * 
		 */		
		public function update(deltaTime:Number):void {
			if (mIsStart == false) {
				return;
			}
			var particle:Particle;
			// 迭代更新所有粒子
			for each (particle in mParticles) {
				if (particle.isAlive == true) {
					// 更新粒子
					for each (var updater:IParticleUpdater in mUpdaters) {
						updater.updateParticle(deltaTime, particle);
					}
				}
			}
			mAliveParticleCount = 0;
			// 迭代清除所有粒子
			for each (particle in mParticles) {
				if (particle.isAlive == true) {
					// 清除粒子
					for each (var cleaner:IParticleCleaner in mCleaners) {
						if (cleaner.cleanParticle(particle) == true) {
							processDeadParticle(particle);
							break;
						}
					}
					mAliveParticleCount++;
				}
			}
			// 没有存活粒子则停止
			if (mAliveParticleCount == 0) {
				stop();
			}
		}
		
		/**
		 * 重置
		 * 
		 */		
		public function reset():void {
			mParticles.length = 0;
			mAliveParticleCount = 0;
		}
		
		/**
		 * 添加粒子
		 * @param particle
		 * 
		 */		
		public function addParticle(particle:Particle):void {
			mParticles.push(particle);
		}
		
		/**
		 * 处理死亡粒子
		 * @param particle
		 * 
		 */		
		protected function processDeadParticle(particle:Particle):void {
			
		}
		
		/**
		 * 是否启动
		 * @return 
		 * 
		 */		
		public function isAlive():Boolean {
			return mIsStart;
		}
		
		/**
		 * 存活粒子数量
		 * @return 
		 * 
		 */		
		public function getAliveParticleCount():int {
			return mAliveParticleCount;
		}
	}
}