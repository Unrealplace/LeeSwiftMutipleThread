//
//  ViewController.swift
//  MutipleThread
//
//  Created by mac on 17/2/9.
//  Copyright © 2017年 https://github.com/Unrealplace. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    
    var atableView:UITableView?
    let nameStr = ["NsThread","NSOperation","GCD"]
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
      
       // self.automaticallyAdjustsScrollViewInsets = false
        self.atableView = UITableView(frame:UIScreen.main.bounds,style:UITableViewStyle.grouped)
        self.atableView?.dataSource = self
        self.atableView?.delegate   = self
        
        self.view.addSubview(self.atableView!)
        
        
    }

   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            
            let threadVC = NsThreadVC()
            
            self.navigationController?.pushViewController(threadVC, animated: true)
            
            
             break
            
        case 1:
            
            let operationVC = NSOperationVC()
            
            self.navigationController?.pushViewController(operationVC, animated: true)
            
            
            break
            
        case 2:
            
            let gcdVC = GCDVC()
            
            self.navigationController?.pushViewController(gcdVC, animated: true)
            
            break
        default: break
            
            
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
     
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.nameStr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell:UITableViewCell=UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "mycell")
        
         cell.detailTextLabel?.text = self.nameStr[indexPath.row]

        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 0 
    }
    
    
    
    
    
}

