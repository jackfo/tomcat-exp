/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.apache.tomcat.util.threads;

import java.util.concurrent.BlockingQueue;
import java.util.concurrent.RejectedExecutionException;
import java.util.concurrent.RejectedExecutionHandler;
import java.util.concurrent.ThreadFactory;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicLong;

import org.apache.tomcat.util.res.StringManager;

/**
 * Same as a java.util.concurrent.ThreadPoolExecutor but implements a much more efficient
 * {@link #getSubmittedCount()} method, to be used to properly handle the work queue.
 * If a RejectedExecutionHandler is not specified a default one will be configured
 * and that one will always throw a RejectedExecutionException
 *
 */
public class ThreadPoolExecutor extends java.util.concurrent.ThreadPoolExecutor {
    /**
     * The string manager for this package.
     */
    protected static final StringManager sm = StringManager
            .getManager("org.apache.tomcat.util.threads.res");

    /**
     *  已经提交但尚未完成的任务数量。
     *  这包括已经在队列中的任务和已经交给工作线程的任务但还未开始执行的任务
     *  这个数字总是大于getActiveCount()的
     **/
    private final AtomicInteger submittedCount = new AtomicInteger(0);

    private final AtomicLong lastContextStoppedTime = new AtomicLong(0L);

    /**
     * 最近的时间在ms时，一个线程决定杀死自己来避免潜在的内存泄漏。 用于调节线程的更新速率。
     */
    private final AtomicLong lastTimeThreadKilledItself = new AtomicLong(0L);

    /**
     * Delay in ms between 2 threads being renewed. If negative, do not renew threads.
     * 线程不稳定延迟时间
     */
    private long threadRenewalDelay = Constants.DEFAULT_THREAD_RENEWAL_DELAY;


    public ThreadPoolExecutor(int corePoolSize, int maximumPoolSize, long keepAliveTime, TimeUnit unit, BlockingQueue<Runnable> workQueue, RejectedExecutionHandler handler) {
        super(corePoolSize, maximumPoolSize, keepAliveTime, unit, workQueue, handler);
        prestartAllCoreThreads();
    }

    public ThreadPoolExecutor(int corePoolSize, int maximumPoolSize, long keepAliveTime, TimeUnit unit, BlockingQueue<Runnable> workQueue, ThreadFactory threadFactory,
            RejectedExecutionHandler handler) {
        super(corePoolSize, maximumPoolSize, keepAliveTime, unit, workQueue, threadFactory, handler);
        //在开始的时候就会启动所有核心线程
        prestartAllCoreThreads();
    }

    public ThreadPoolExecutor(int corePoolSize, int maximumPoolSize, long keepAliveTime, TimeUnit unit, BlockingQueue<Runnable> workQueue, ThreadFactory threadFactory) {
        super(corePoolSize, maximumPoolSize, keepAliveTime, unit, workQueue, threadFactory, new RejectHandler());
        prestartAllCoreThreads();
    }

    public ThreadPoolExecutor(int corePoolSize, int maximumPoolSize, long keepAliveTime, TimeUnit unit, BlockingQueue<Runnable> workQueue) {
        super(corePoolSize, maximumPoolSize, keepAliveTime, unit, workQueue, new RejectHandler());
        prestartAllCoreThreads();
    }

    public long getThreadRenewalDelay() {
        return threadRenewalDelay;
    }

    public void setThreadRenewalDelay(long threadRenewalDelay) {
        this.threadRenewalDelay = threadRenewalDelay;
    }

    /**
     *  @param r 已完成的任务
     *  @param t 引起终止的异常，如果执行正常完成则为null
     **/
    @Override
    protected void afterExecute(Runnable r, Throwable t) {
        submittedCount.decrementAndGet();
        if (t == null) {
            stopCurrentThreadIfNeeded();
        }
    }

    //任务执行完毕之后 线程池没有关闭则是正常 若线程池 则扔出异常 表明线程池已经关闭
    protected void stopCurrentThreadIfNeeded() {
        if (currentThreadShouldBeStopped()) {
            //获取线程最后杀死时间 加延迟时间小于当前时间threadRenewalDelay
            long lastTime = lastTimeThreadKilledItself.longValue();
            if (lastTime + threadRenewalDelay < System.currentTimeMillis()) {
                //
                if (lastTimeThreadKilledItself.compareAndSet(lastTime, System.currentTimeMillis() + 1)) {
                    // OK, it's really time to dispose of this thread
                    //通过扔出异常来停止线程
                    final String msg = sm.getString("threadPoolExecutor.threadStoppedToAvoidPotentialLeak", Thread.currentThread().getName());
                    throw new StopPooledThreadException(msg);
                }
            }
        }
    }

    //如果当前线程创建在线程池结束之前,返回真
    protected boolean currentThreadShouldBeStopped() {
        if (threadRenewalDelay >= 0 && Thread.currentThread() instanceof TaskThread) {
            TaskThread currentTaskThread = (TaskThread) Thread.currentThread();
            if (currentTaskThread.getCreationTime() < this.lastContextStoppedTime.longValue()) {
                return true;
            }
        }
        return false;
    }

    //获取当前在执行的线程和队列中线程的数量
    public int getSubmittedCount() {
        return submittedCount.get();
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void execute(Runnable command) {
        execute(command,0,TimeUnit.MILLISECONDS);
    }

    /**
     * Executes the given command at some time in the future.  The command
     * may execute in a new thread, in a pooled thread, or in the calling
     * thread, at the discretion of the <tt>Executor</tt> implementation.
     * If no threads are available, it will be added to the work queue.
     * If the work queue is full, the system will wait for the specified
     * time and it throw a RejectedExecutionException if the queue is still
     * full after that.
     *
     * @param command the runnable task
     * @throws RejectedExecutionException if this task cannot be
     * accepted for execution - the queue is full
     * @throws NullPointerException if command or unit is null
     */
    public void execute(Runnable command, long timeout, TimeUnit unit) {
        //提交数量+1
        submittedCount.incrementAndGet();
        try {
            super.execute(command);
        } catch (RejectedExecutionException rx) {
            if (super.getQueue() instanceof TaskQueue) {
                final TaskQueue queue = (TaskQueue)super.getQueue();
                try {
                    if (!queue.force(command, timeout, unit)) {
                        submittedCount.decrementAndGet();
                        throw new RejectedExecutionException("Queue capacity is full.");
                    }
                } catch (InterruptedException x) {
                    submittedCount.decrementAndGet();
                    throw new RejectedExecutionException(x);
                }
            } else {
                //处理完毕数量-1
                submittedCount.decrementAndGet();
                throw rx;
            }

        }
    }

    public void contextStopping() {
        //设置context停止时间
        this.lastContextStoppedTime.set(System.currentTimeMillis());

        // save the current pool parameters to restore them later
        //获取核心线程数打下
        int savedCorePoolSize = this.getCorePoolSize();
        //获取任务队列
        TaskQueue taskQueue = getQueue() instanceof TaskQueue ? (TaskQueue) getQueue() : null;
        if (taskQueue != null) {
            // note by slaurent : quite oddly threadPoolExecutor.setCorePoolSize
            // checks that queue.remainingCapacity()==0. I did not understand
            // why, but to get the intended effect of waking up idle threads, I
            // temporarily fake this condition.
            //设置forcedRemainingCapacity为0
            taskQueue.setForcedRemainingCapacity(Integer.valueOf(0));
        }

        // setCorePoolSize(0) wakes idle threads
        //设置核心线程数为0
        this.setCorePoolSize(0);

        // TaskQueue.take() takes care of timing out, so that we are sure that
        // all threads of the pool are renewed in a limited time, something like
        // (threadKeepAlive + longest request time)

        if (taskQueue != null) {
            // ok, restore the state of the queue and pool
            taskQueue.setForcedRemainingCapacity(null);
        }
        this.setCorePoolSize(savedCorePoolSize);
    }

    private static class RejectHandler implements RejectedExecutionHandler {
        @Override
        public void rejectedExecution(Runnable r,
                java.util.concurrent.ThreadPoolExecutor executor) {
            throw new RejectedExecutionException();
        }

    }


}
