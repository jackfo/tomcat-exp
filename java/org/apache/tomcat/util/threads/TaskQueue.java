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

import java.util.Collection;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.RejectedExecutionException;
import java.util.concurrent.TimeUnit;

/**
 * As task queue specifically designed to run with a thread pool executor. The
 * task queue is optimised to properly utilize threads within a thread pool
 * executor. If you use a normal queue, the executor will spawn threads when
 * there are idle threads and you wont be able to force items onto the queue
 * itself.
 */
public class TaskQueue extends LinkedBlockingQueue<Runnable> {

    private static final long serialVersionUID = 1L;

    private volatile ThreadPoolExecutor parent = null;

    // No need to be volatile. This is written and read in a single thread
    // (when stopping a context and firing the  listeners)
    private Integer forcedRemainingCapacity = null;

    public TaskQueue() {
        super();
    }

    public TaskQueue(int capacity) {
        super(capacity);
    }

    public TaskQueue(Collection<? extends Runnable> c) {
        super(c);
    }

    public void setParent(ThreadPoolExecutor tp) {
        parent = tp;
    }

    //在调用拒绝策略之后 任务呗拒绝之后
    public boolean force(Runnable o) {
        if ( parent==null || parent.isShutdown() ) {
            throw new RejectedExecutionException("Executor not running, can't force a command into the queue");
        }
        //forces the item onto the queue, to be used if the task is rejected
        return super.offer(o);
    }

    public boolean force(Runnable o, long timeout, TimeUnit unit) throws InterruptedException {
        if ( parent==null || parent.isShutdown() ) {
            throw new RejectedExecutionException("Executor not running, can't force a command into the queue");
        }
        //forces the item onto the queue, to be used if the task is rejected
        return super.offer(o,timeout,unit);
    }

    /**
     * 插入一个节点元素 首先保证达到最大线程池数量
     * */
    @Override
    public boolean offer(Runnable o) {
        //如果线程池围为空 调用父类方法
        if (parent==null) {
            return super.offer(o);
        }
        //如果线程池最大数量等于MaximumPoolSize 将其添加到队列
        if (parent.getPoolSize() == parent.getMaximumPoolSize()){
            return super.offer(o);
        }
        //we have idle threads, just add it to the queue
        if (parent.getSubmittedCount()<(parent.getPoolSize())){
            return super.offer(o);
        }
        //如果工作线程小于最大线程数量则不添加到队列
        if (parent.getPoolSize()<parent.getMaximumPoolSize()) {
            return false;
        }
        //if we reached here, we need to add it to the queue
        return super.offer(o);
    }


    @Override
    public Runnable poll(long timeout, TimeUnit unit)
            throws InterruptedException {
        //取出一个线程
        Runnable runnable = super.poll(timeout, unit);
        if (runnable == null && parent != null) {
            //取出超时,它给了一个机会,停止当前线程避免内存泄漏。
            parent.stopCurrentThreadIfNeeded();
        }
        return runnable;
    }

    @Override
    public Runnable take() throws InterruptedException {
        if (parent != null && parent.currentThreadShouldBeStopped()) {
            return poll(parent.getKeepAliveTime(TimeUnit.MILLISECONDS),
                    TimeUnit.MILLISECONDS);
            // yes, this may return null (in case of timeout) which normally
            // does not occur with take()
            // but the ThreadPoolExecutor implementation allows this
        }
        return super.take();
    }

    @Override
    public int remainingCapacity() {
        if (forcedRemainingCapacity != null) {
            // ThreadPoolExecutor.setCorePoolSize checks that
            // remainingCapacity==0 to allow to interrupt idle threads
            // I don't see why, but this hack allows to conform to this
            // "requirement"
            return forcedRemainingCapacity.intValue();
        }
        return super.remainingCapacity();
    }

    public void setForcedRemainingCapacity(Integer forcedRemainingCapacity) {
        this.forcedRemainingCapacity = forcedRemainingCapacity;
    }

}
