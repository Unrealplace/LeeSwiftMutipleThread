//
//  NSOperationVC.swift
//  MutipleThread
//
//  Created by mac on 17/2/9.
//  Copyright © 2017年 https://github.com/Unrealplace. All rights reserved.
//

import UIKit

//介绍：
//
//NSOperation是基于GCD实现，封装了一些更为简单实用的功能，因为GCD的线程生命周期是自动管理，所以NSOperation也是自动管理。NSOperation配合NSOperationQueue也可以实现多线程。
//实现步骤
//
//第1步：将一个操作封装到NSOperation对象中
//
//第2步：将NSOperation对象放入NSOperationQueue队列
//
//第3步：NSOperationQueue自动取出队列中的NSOperation对象放到一条线程中执行
//具体实现
//
//在swift中的实现方式分2种（oc还多了一个NSInvocationOperation，并且在oc中NSOperation是个抽象类）：
//
//1.NSBlockOperation
//
//2.自定义子类继承NSOperation

class NSOperationVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        
        
       ///****** 1.NSOoperation常用操作，创建队列，设置最大并发数。
        // NSBlockOperation 方式
        let queue = OperationQueue()
        //设置最大并发数
        queue.maxConcurrentOperationCount = 1
        //创建operation
        let operation = BlockOperation {() ->Void in
            
            print("dosomething1\(Thread.current)")
        
            
        }
        //当operation有多个任务的时候会自动分配多个线程并发执行,
        //如果只有一个任务，会自动在主线程同步执行
        //operation.start()
        operation.addExecutionBlock { () ->Void in
            
            print("dosomething2\(Thread.current)")

        }
        operation.addExecutionBlock { () ->Void in
            
            print("dosomething3\(Thread.current)")
            
        }
        
        
        let operation2 = BlockOperation{ () ->Void in
            
            print("dosomething4\(Thread.current)")
        
            
        }
        
        //添加到队列中的operation将自动异步执行
        queue.addOperation(operation)
        queue.addOperation(operation2)
        
        
        //还有一种方式，直接将operation的blcok直接加入到队列
        queue.addOperation { () -> Void in
            print("doSomething5 block \(Thread.current)")
        }
        queue.addOperation { () -> Void in
            print("doSomething6 block \(Thread.current)")
        }
        queue.addOperation { () -> Void in
            print("doSomething7 block \(Thread.current)")
        }
        queue.addOperation { () -> Void in
            print("doSomething8 block \(Thread.current)")
        }
        
        
        
        ///****** 2.NSOperation操作依赖，可设置一个操作在另一个操作完成后在执行
        
        let queue2 = OperationQueue()
        
        let operationA = BlockOperation{() ->Void in
            
            print("print A")
        
        }
        
        let operationB = BlockOperation{() ->Void in
            
            print("print B")
            
        }
        
        let operationC = BlockOperation{() ->Void in
            
            print("print C")
            
        }
        
        operationB.addDependency(operationA)
        operationC.addDependency(operationB)
        
        queue2.addOperation(operationC)
        queue2.addOperation(operationA)
        queue2.addOperation(operationB)
        
        self.operationCompletion()
        
        
      ///******  4.NSOperation线程通信，NSOperationQueue.mainQueue。
        
        //创建队列
        let queue3 = OperationQueue()
        queue3.addOperation { () -> Void in
            print("＊＊＊＊＊＊＊＊＊＊子线程  \(Thread.current)")
            let num = 100
            OperationQueue.main.addOperation({ () -> Void in
                print("＊＊＊＊＊＊＊＊＊＊主线程  \(Thread.current)")
                print("\(num - 10)")
                
            })
        }
        
        
//        注意：
//        
//        1.在使用队列任务的时候，内存警告的时候可使用队列的cancelAllOperations函数取消所有操作，注意一旦取消不可恢复。亦可设置队列的suspended属性暂停和恢复队列。
//        
//        2.在设置操作依赖的时候不能设置循环依赖。
//        
//        完！
        
    }
    
    
    ///******  3.NSOperation操作监听，一个操作完成后调用另一个操作：
    
    func operationCompletion(){
        //创建队列
        let queue = OperationQueue()
        let operation = BlockOperation { () -> Void in
            print("当前操作执行中。。。。")
        }
        operation.completionBlock = doSomething
        queue.addOperation(operation)
    }
    func doSomething(){
        print("上个操作完成 后 做doSomething")
    }


    
}
