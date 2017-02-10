//
//  GCDVC.swift
//  MutipleThread
//
//  Created by mac on 17/2/9.
//  Copyright © 2017年 https://github.com/Unrealplace. All rights reserved.
//

import UIKit


/// 基本概念是一个 调度队列 来接受任务 任务是以先到先执行的顺序执行

/// 1.GCD 比 thread 简单，基于block 的特性可以在不同代码块间传递上下文

/// 2.GCD 实现功能轻量，优雅，比手动创建的线程更实用和快速

/// 3.GCD 自动根据系统负载来增减线程数量，从而减少了上下文切换并提高了效率

/// 4.无需加锁 或 其他同步机制

//线程同步：就是多个线程同时访问同一资源，必须等一个线程访问结束，才能访问其它资源，比较浪费时间，效率低
//线程异步：访问资源时在空闲等待时可以同时访问其他资源，实现多线程机制

//1、同步就是指一个线程要等待上一个线程执行完之后才开始执行当前的线程。
//2、异步是指一个线程去执行，它的下一个线程不必等待它执行完就开始执行。


 //串行队列   同步执行任务    会在当前线程内执行  # 不一定是主线程
 //异步的方式  执行串行队列   会创建一个新的线程来执行任务
 //串行的队列都是按照顺序来执行。就是任务1 -> 任务2 -》任务3

 //并行队列，同步的方式执行  并不会开辟新线程
 //异步的方式 执行并行队列 会创建多个新的线程来执行 多个任务 是随机无序执行的


class GCDVC: UIViewController {
    
    
    var imageV:UIImageView?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        self.imageV = UIImageView()
        self.imageV?.frame = self.view.bounds
        self.view.addSubview(self.imageV!)
        
         self.LeeSyncSerail()
         self.LeeSyncConcurrent()
         self.LeeAsyncSerail()
         self.LeeAsyncConcurrent()
        
         self.LeeSubThreadToMainThread()
         self.LeeQueueCommunication()
         self.LeeDelay(time: 10)
         self.LeeMutiPle()
        
        
        
    }

    
    
    /// 1.三种创建队列的方法
    func LeeGCDMakeMethods() {
        
        //label 代表队列名称，attr 属性代表队列是串行还是并行执行任务
        //创建一个串行队列
        let serialQueue = DispatchQueue(label: "queue1", attributes: .init(rawValue: 0))
        //创建一个并发队列
        let conQueue    = DispatchQueue(label: "Mazy", attributes: .concurrent)
        
        //获得主队列
        let globalQueue = DispatchQueue.global()
        
        
        
       

        
    }
    
    
    ///1、同步 + 串行队列 
    // 同步 + 串行队列：不会开启新的线程，在当前线程执行任务。任务是串行的，执行完一个任务，再执行下一个任务
    func LeeSyncSerail(){
        // 1、创建一个串行队列
        let serialQueue = DispatchQueue(label: "Mazy", attributes: .init(rawValue: 0))
        // 同步执行三个任务
        serialQueue.sync {
            print("1 + \(Thread.current)")
        }
        serialQueue.sync {
            for i in 0 ..< 100 {
                
                print("\(i)")
            }
        }
        serialQueue.sync {
            print("3 + \(Thread.current)")
        }
    }
    
    
    
    //3、同步 + 并发队列
    //// 同步 + 并发队列： 总结：不开启新线程，主线程执行任务，任务也是顺序执行
    func LeeSyncConcurrent() {
        // 创建一个全局
        let globalQueue = DispatchQueue.global()
        // 同步执行三个任务
        globalQueue.sync {
            
            for i in 0 ..< 100 {
            
                print("\(i)")
            }

        }
        globalQueue.sync {
            print("2 + \(Thread.current)")
        }
        globalQueue.sync {
            print("3 + \(Thread.current)")
        }
        
   
    }
    //2、异步 + 串行队列
    //// 异步 + 串行队列：开启新的线程，但只开启一条 总结：开启了一条线程，任务串行执行
    func LeeAsyncSerail() {
        // 1、创建一个串行队列
        let serialQueue = DispatchQueue(label: "Mazy", attributes: .init(rawValue: 0))
        // 异步执行三个任务
        serialQueue.async {
            print("1 + \(Thread.current)")
        }
        serialQueue.async {
            print("2 + \(Thread.current)")
        }
        serialQueue.async {
            print("3 + \(Thread.current)")
        }
        serialQueue.async {
            print("4 + \(Thread.current)")
        }
        serialQueue.async {
            print("5 + \(Thread.current)")
        }
        serialQueue.async {
            print("6 + \(Thread.current)")
        }
    }
    //4、异步 + 并发队列
    // 异步 + 并发队列：同时开启多条线程 任务是并行执行
    func LeeAsyncConcurrent() {
        
        // 创建一个全局队列
        let globalQueue = DispatchQueue.global()
        // 异步执行三个任务
        globalQueue.async {
            print("1 + \(Thread.current)")
        }
        globalQueue.async {
            print("2 + \(Thread.current)")
        }
        globalQueue.async {
            print("3 + \(Thread.current)")
        }
    }
    
    
    
    //******GCD线程之间的通信
    
    //从子线程回到主线程
    func LeeSubThreadToMainThread() {
        
        DispatchQueue.global().async {
            // 执行耗时的异步操作...
            
            for i in 0 ..< 100000{
            
                print("\(i)")
                
            }
            
            DispatchQueue.main.async {
                // 回到主线程，执行UI刷新操作
                self.view.backgroundColor = UIColor.red
            }
        }
        
    }
    
    //线程之间的通信具体实现实例
    func LeeQueueCommunication(){
        
        // 创建 异步 全局并发队列
        DispatchQueue.global().async {
            // 图片的网络路径
            let url = URL(string: "http://h.hiphotos.baidu.com/zhidao/pic/item/6d81800a19d8bc3ed69473cb848ba61ea8d34516.jpg")
            
            if let u = url {

                do {
                    // 加载图片
                    let data = try Data(contentsOf: u)
                    // 生成图片
                    let image = UIImage(data: data)
                    // 回到主线程设置图片
                    DispatchQueue.main.async {
                        
                        self.imageV?.image = image
                    
                     }
                } catch {
                
                    print("error")
                    
                }
            }
            
        }
    
    }
    
    
    //******GCD的其他使用
    //延迟执行
    func LeeDelay(time:Int) {
        
        let additionalTime: DispatchTimeInterval = .seconds(time)
        DispatchQueue.main.asyncAfter(deadline: .now() + additionalTime, execute: {
            print("\(time)秒后执行 \(NSDate())")
        })
    }
    
    
    //创建线程群组
    //例如同一个文件分段下载，待所有分段任务下载完成后，合并任务
    // 总结：开启多条线程，去执行群组中的任务，当群组内的四个任务执行完毕后，再去执行notify里面的任务
    
    func LeeMutiPle() {
        
        // 获得全局队列
        let globalQueue = DispatchQueue.global()
        
        // 创建一个队列组
        let group = DispatchGroup()
        
        globalQueue.async(group: group, execute: {
            print("任务一 \(Thread.current)")
        })
        globalQueue.async(group: group, execute: {
            print("任务二 \(Thread.current)")
        })
        
        // group内的任务完成后,执行此方法
        group.notify(queue: globalQueue, execute: {
            print("终极任务 \(Thread.current)")
        })
        
        globalQueue.async(group: group, execute: {
            print("任务三 \(Thread.current)")
        })
        
        globalQueue.async(group: group, execute: {
            print("任务四 \(Thread.current)")
        })
        
        
        
    }
    
    
}

