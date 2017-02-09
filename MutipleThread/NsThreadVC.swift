//
//  NsThreadVC.swift
//  MutipleThread
//
//  Created by mac on 17/2/9.
//  Copyright © 2017年 https://github.com/Unrealplace. All rights reserved.
//

import UIKit

/// 轻量级，需要自己管理线程的生命周期和线程同步，线程同步对数据的加锁会有一定的系统开销

class NsThreadVC: UIViewController {

    //线程同步方法 同步锁来实现 ，每个线程只有一个锁
    // 定义两个线程
    var leeThread3:Thread?
    var leeThread4:Thread?
    
    //定义两个线程条件，用于锁住线程
    let condition1 = NSCondition()
    let condition2 = NSCondition()
    
    ///
    override func viewDidLoad() {
        super.viewDidLoad()


        self.view.backgroundColor = UIColor.white
        
        // 1. 类方法创建线程并自动运行
        Thread.detachNewThreadSelector(#selector(NsThreadVC.printOne), toTarget: self, with: nil)
        
        // 2. 实例方法 － 便利构造器 需要手动启动线程 可以设置线程的优先级信息
        let LeeThread2:Thread = Thread(target: self, selector:#selector(NsThreadVC.printTwo), object: nil)
        LeeThread2.start()
        
        //俩个线程实力话 ，并启动第一个线程 线程同步的 方法就是这样呗
        leeThread3 = Thread(target: self, selector:#selector(NsThreadVC.TestThread1), object: nil)

        leeThread4 = Thread(target: self, selector:#selector(NsThreadVC.TestThread2), object: nil)

        
        leeThread3?.start()
        
        
    }

    func TestThread1(sender:AnyObject) {
        
        
        for i in 0 ..< 10
        {
        
            print("thread 3 running\(i)")
            sleep(1);
            
            if i == 2 {
                
                leeThread4?.start()//启动线程4
                //同时锁定线程3 因为这个方法在3线程中所有锁定的是这个线程，线程看不见摸不着的。。。
                condition1.lock()
                condition1.wait()
                condition1.unlock()
                
            }
            
        }
        print("线程 3 结束了")
        //线程4激活
        condition2.signal()
       
    }
    
    func TestThread2(sender:AnyObject) {
         for i in 0 ..< 10
        {
            print("thread 4 running\(i)")
            sleep(1);
            if i == 2 {
                 //线程3激活
                condition1.signal()
                
                //线程4锁定 因为这个方法在4线程中所有锁定的是这个线程，线程看不见摸不着的。。。
                condition2.lock()
                condition2.wait()
                condition2.unlock()
            }
            
            
        }
        
        print("线程 4 结束了")
    }
    
    func printOne() {
        
        print("1线程\(Thread.current)")
     
    }
    
    func printTwo() {
        
        print("2线程\(Thread.current)")
    }
    
    
}
