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
package org.apache.catalina.util;

import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;

import org.apache.catalina.Lifecycle;
import org.apache.catalina.LifecycleEvent;
import org.apache.catalina.LifecycleListener;

/**
 * Support class to assist in firing LifecycleEvent notifications to
 * registered LifecycleListeners.
 *
 * @author Craig R. McClanahan
 */
public final class LifecycleSupport {

    // ----------------------------------------------------------- Constructors

    /**
     * Construct a new LifecycleSupport object associated with the specified
     * Lifecycle component.
     *
     * @param lifecycle The Lifecycle component that will be the source
     *  of events that we fire
     */
    public LifecycleSupport(Lifecycle lifecycle) {
        super();
        this.lifecycle = lifecycle;
    }


    /**与LifecycleListener对应的生命周期的组件 即 对应容器*/
    private final Lifecycle lifecycle;


    /**注册LifecycleListeners事件通知的集合*/
    private final List<LifecycleListener> listeners = new CopyOnWriteArrayList<>();


    // --------------------------------------------------------- Public Methods

    /**添加一个LifecycleListener实例给当前lifecycle*/
    public void addLifecycleListener(LifecycleListener listener) {
        listeners.add(listener);
    }



    /**获取所有和lifecycle相关的lifecycle listeners ，
     * 如果Lifecycle没有listeners注册则返回一个长度为0的LifecycleListener数组*/
    public LifecycleListener[] findLifecycleListeners() {
        return listeners.toArray(new LifecycleListener[0]);
    }


    /**
     * Notify all lifecycle event listeners that a particular event has
     * occurred for this Container.  The default implementation performs
     * this notification synchronously using the calling thread.
     *
     * 获取当前组件的所有listener,构造对应的LifecycleEvent实例即事件实例
     * 循环遍历进行调用
     * @param type Event type
     * @param data Event data
     */
    public void fireLifecycleEvent(String type, Object data) {
        LifecycleEvent event = new LifecycleEvent(lifecycle, type, data);
        for (LifecycleListener listener : listeners) {
            listener.lifecycleEvent(event);
        }
    }


    /**
     * Remove a lifecycle event listener from this component.
     *
     * @param listener The listener to remove
     */
    public void removeLifecycleListener(LifecycleListener listener) {
        listeners.remove(listener);
    }
}
