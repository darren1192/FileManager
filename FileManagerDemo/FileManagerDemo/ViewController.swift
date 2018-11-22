//
//  ViewController.swift
//  FileManagerDemo
//
//  Created by share2glory on 2018/11/22.
//  Copyright © 2018年 WH. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    //Home目录  ./
    func getHomePath(){
        let homeDirectory = NSHomeDirectory()
        print("homeDirectory:\(homeDirectory)")
    }
    //Documnets目录  ./Documents
    func getDocumnetsPath(){
        // 方法1
        let documnetPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documnetPath = documnetPaths.first!
        print("documnetPath:\(documnetPath)")
        
        //方法2
        let documnetPath2 = NSHomeDirectory() + "/Documents"
        print("documnetPath2:\(documnetPath2)")
    }
    
    //Library目录  ./Library
    func getLibrary(){
        //Library
        let libraryPaths = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)
        let libraryPath = libraryPaths.first!
        print("libraryPath:\(libraryPath)")
        
        let libraryPath2 = NSHomeDirectory() + "/Library"
        print("libraryPath2:\(libraryPath2)")
        
        //Library/Caches
        let cachePaths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
        let cachePath = cachePaths.first!
        print("cachePath:\(cachePath)")
        
        let cachePath2 = NSHomeDirectory() + "/Library/Caches"
        print("cachePath2:\(cachePath2)")
        
        //Library/Preferences
        let preferencPath = NSHomeDirectory() + "/Library/Preferences"
        print("preferencPath:\(preferencPath)")
        
    }
    
    //tmp目录  ./tmp
    func getTmp(){
        let timDir = NSTemporaryDirectory()
        print("timDir:\(timDir)")
        
        let timDir2 = NSHomeDirectory() + "/tmp"
        print("timDir2:\(timDir2)")
    }
    
    func traverse(){
        // 对指定路径执行浅搜索，返回指定目录路径下的文件、子目录及符号链接的列表
        let manager = FileManager.default
        let urlForDocument = manager.urls(for: .libraryDirectory, in: .userDomainMask)
        let url = urlForDocument.first
        let contentsOfPath = try? manager.contentsOfDirectory(atPath: url!.path)
        print("contentsOfPath:\(contentsOfPath!)")
        
        let contentsOfUrl = try? manager.contentsOfDirectory(at: url!, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        print("contentsOfUrl:\(contentsOfUrl!)")
        // 深度遍历，会递归遍历子文件夹（但不会递归符号链接）
        let enumeratorAtPath = manager.enumerator(atPath: url!.path)
        print("enumeratorAtPath:\(enumeratorAtPath!.allObjects)")
        
        // 类似上面的，深度遍历，会递归遍历子文件夹（但不会递归符号链接）
        let enumeratorAtUrl = manager.enumerator(at: url!, includingPropertiesForKeys: nil, options: .skipsHiddenFiles, errorHandler: nil)
        print("enumeratorAtUrl:\(enumeratorAtUrl!.allObjects)")
        
        // 深度遍历，会递归遍历子文件夹（包括符号链接，所以要求性能的话用enumeratorAtPath）
        let subPaths = manager.subpaths(atPath: url!.path)
        print("subPaths:\(subPaths!)")
    }
    
    func checkExits(){
        let fileManager = FileManager.default
        let filePath = NSHomeDirectory() + "/Documents"
        let exist = fileManager.fileExists(atPath: filePath)
        print("exist:\(exist)")
    }
    
    func creatFolder1(){
        let myDirectory = NSHomeDirectory() + "/Documents/myFolder"
        let fileManager = FileManager.default
        // 为ture表示路径中间如果有不存在的文件夹都会创建
        try! fileManager.createDirectory(atPath: myDirectory, withIntermediateDirectories: true, attributes: nil)
    }
    
    func creatFolder2(){
        let manager = FileManager.default
        let urlForDocument = manager.urls(for: .documentDirectory, in: .userDomainMask)
        let url = urlForDocument.first!
        let folder = url.appendingPathComponent("myFolder2", isDirectory: true)
        print("文件夹：\(folder)")
        let exist = manager.fileExists(atPath: folder.path)
        if !exist {
            try! manager.createDirectory(at: folder, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    func stringWriteToFolder(){
        let filePath = NSHomeDirectory() + "/Documents/wh.txt"
        let info = "test write string to folder"
        try? info.write(toFile: filePath, atomically: true, encoding: String.Encoding.utf8)
    }
    
    func imageWriteToFolder(){
        let filePath = NSHomeDirectory() + "/Documents/wh.png"
        let image = UIImage.init(named: "WechatIMG9320")
        let data: Data = image!.pngData()!
        try? data.write(to: URL.init(fileURLWithPath: filePath))
    }
    
    func arrayWriteToFolder(){
        let array = NSArray.init(array: ["a", "b", "c", "d"])
        let filePath = NSHomeDirectory() + "/Documents/array.plist"
        array.write(toFile: filePath, atomically: true)
    }
    
    func dictionaryWriteToFolder(){
        let dictionary = NSDictionary.init(dictionary: ["name": "wh",
                                                        "age": 16,
                                                        "sex": "man"])
        let filePath = NSHomeDirectory() + "/Documents/Dic.plist"
        dictionary.write(toFile: filePath, atomically: true)
    }
    
    func creatFile(){
        let manager = FileManager.default
        let urlForDocument = manager.urls(for: .documentDirectory, in: .userDomainMask)
        let url = urlForDocument.first!
        let file = url.appendingPathComponent("test.txt")
        let exist = manager.fileExists(atPath: file.path)
        if !exist {
            let data = Data.init(base64Encoded: "aGVsbG8gd29ybGQ=", options: .ignoreUnknownCharacters)
            let creatSuccess = manager.createFile(atPath: file.path, contents: data, attributes: nil)
            print("文件创建结果：\(creatSuccess)")
        }
    }
    
    func copyFile1(){
        let fileManager = FileManager.default
        let scrouePath = NSHomeDirectory() + "/Documents/wh.txt"
        let toPath = NSHomeDirectory() + "/Documents/wh2.txt"
        try! fileManager.copyItem(atPath: scrouePath, toPath: toPath)
    }
    
    func copyFile2(){
        let manager = FileManager.default
        let urlForDocument = manager.urls(for: .documentDirectory, in: .userDomainMask)
        let url = urlForDocument.first!
        
        let srcoueUrl = url.appendingPathComponent("test.txt")
        let toUrl = url.appendingPathComponent("test2.txt")
        
        try! manager.copyItem(at: srcoueUrl, to: toUrl)
    }
    
    func moveFiler1(){
        let fileManager = FileManager.default
        let srcUrl = NSHomeDirectory() + "/Documents/test.txt"
        let toUrl = NSHomeDirectory() + "/Documents/myFolder/test.txt"
        try? fileManager.moveItem(atPath: srcUrl, toPath: toUrl)
    }
    
    func moveFiler2(){
        let fileManager = FileManager.default
        let urlForDocument = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let url = urlForDocument.first!
        
        let srcUrl = url.appendingPathComponent("test.txt")
        let toUrl = url.appendingPathComponent("move.txt")
        try! fileManager.moveItem(at: srcUrl, to: toUrl)
    }
    
    func removeFiler(){
        let fileManager = FileManager.default
        let myDirectory = NSHomeDirectory() + "/Documents/myFolder"
        let fileArray = fileManager.subpaths(atPath: myDirectory)
        for fn in fileArray!{
            try! fileManager.removeItem(atPath: myDirectory + "/\(fn)")
        }
    }
    
    func readString(){
        let fileManager = FileManager.default
        let urlForDocument = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let docPath = urlForDocument.first!
        let file = docPath.appendingPathComponent("wh2.txt")
        
        //方法1
        let readHandler = try! FileHandle.init(forReadingFrom: file)
        let data = readHandler.readDataToEndOfFile()
        let readString = String.init(data: data, encoding: .utf8)
        print("文件内容:\(readString!)")
        
        //方法2
        let data2 = fileManager.contents(atPath: file.path)
        let readString2 = String.init(data: data2!, encoding: .utf8)
        print("文件内容:\(readString2!)")
    }
    
    func readable(){
        let fileManager = FileManager.default
        let urlForDocument = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let docPath = urlForDocument.first!
        let file = docPath.appendingPathComponent("wh2.txt")
        
        let readable = fileManager.isReadableFile(atPath: file.path)
        let writeable = fileManager.isWritableFile(atPath: file.path)
        let executable = fileManager.isExecutableFile(atPath: file.path)
        let deleteable = fileManager.isDeletableFile(atPath: file.path)
        print("可读:\(readable) \n可写:\(writeable) \n可执行:\(executable) \n可删除:\(deleteable)")
    }
    
    func getFileAttribute(){
        let fileManager = FileManager.default
        let urlForDocument = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let docPath = urlForDocument.first!
        let file = docPath.appendingPathComponent("wh2.txt")
        
        let attributes = try? fileManager.attributesOfItem(atPath: file.path)
        //        print("attributes:\(attributes)")
        print("创建时间:\(attributes![FileAttributeKey.creationDate]!)")
        print("修改时间:\(attributes![FileAttributeKey.modificationDate]!)")
        print("文件大小:\(attributes![FileAttributeKey.size]!)")
    }
    
    func comparison(){
        let fileManager = FileManager.default
        let urlForDocument = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let docPath = urlForDocument.first!
        let contents = try! fileManager.contentsOfDirectory(atPath: docPath.path)
        //下面比较用户文档中前面两个文件是否内容相同（该方法也可以用来比较目录）
        let count = contents.count
        if count > 1 {
            let path1 = docPath.path + "/" + contents[0]
            let path2 = docPath.path + "/" + contents[1]
            let equal = fileManager.contentsEqual(atPath: path1, andPath: path2)
            print("path1:\(path1)")
            print("path2:\(path2)")
            print("比较结果:\(equal)")
        }
    }
    

}

