//
//  Person.swift
//  swiftTest
//
//  Created by 王雅强 on 2018/3/19.
//  Copyright © 2018年 王雅强. All rights reserved.
//

import UIKit

class Person: NSObject {
    //属性
    var name:String
    
    init(name:String) {
        self.name = name
        super.init()
    }
    
    
}
/*
3
    / \
9  20
    /  \
15   7

输出结果应该是：
[
    [3],
    [9,20],
    [15,7]
]

本题的 Swift 代码模版如下：
*/


import Foundation

private class TreeNode {
    public var val: Int
    public var left: TreeNode?
    public var right: TreeNode?
    public init(_ val: Int) {
        self.val = val
        self.left = nil
        self.right = nil
    }
}

private class Solution {
    func levelOrder(_ root: TreeNode?) -> [[Int]] {
        guard let root = root else {
            return []
        }
        var result = [[TreeNode]]()
        var level = [TreeNode]()
        
        level.append(root)
        while level.count != 0 {
            result.append(level)
            var nextLevel = [TreeNode]()
            for node in level {
                if let leftNode = node.left {
                    nextLevel.append(leftNode)
                }
                if let rightNode = node.right {
                    nextLevel.append(rightNode)
                }
            }
            level = nextLevel
        }
        
        let ans = result.map { $0.map { $0.val }}
        return ans
    }
}
