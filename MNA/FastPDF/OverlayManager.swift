//
//  OverlayManager.swift
//  MNA
//
//  Created by Maahi on 20/01/18.
//  Copyright © 2018 KTeck. All rights reserved.
//

import UIKit

class OverlayManager: NSObject ,MFDocumentOverlayDataSource{

    var searchKeyword = ""
    var documentManager:MFDocumentManager = MFDocumentManager()
    var glyphBoxes:NSMutableArray =  NSMutableArray()
    var selectedArea:NSMutableArray = NSMutableArray()
    
    
    
    func documentViewController(_ dvc:MFDocumentViewController , drawablesForPage:Int) -> NSArray{
        
        if searchKeyword != ""{
           
            //let   fsgsg:NSArray =  documentManager.glyphBoxes(forPage: UInt(drawablesForPage)) as! NSArray
            return  documentManager.searchResult(onPage: UInt(drawablesForPage), forSearchTerms: searchKeyword, ignoreCase: true)! as NSArray
           // (onPage: drawablesForPage, forSearchTerms: searchKeyword, ign)
        
        
        }else{
            
            var drawables:NSMutableArray = NSMutableArray()
            for tmpValue in selectedArea {
                let tVal  = tmpValue as! UIView
                let selectedView:UIView = UIView()
                selectedView.frame = tVal.frame
                drawables.add(selectedView)
                
            }
            
            return drawables
            
        }
        
      //  return NSArray()
    }
    
    
    
    
    func startSelectedArea(_ page:Int) {
        glyphBoxes = documentManager.glyphBoxes(forPage: UInt(page)) as! NSMutableArray
    }
    
    
    
    
    
    func calculateSelectedArea(_ point:CGPoint, page:Int) -> Bool{
        
        var tmpRect:CGRect = CGRect()
        for tmpValue in glyphBoxes {
            let glyphBox = tmpValue as! FPKGlyphBox
            let glyphBoxRect :CGRect =  glyphBox.box
            
            if glyphBoxRect.contains(point){
                tmpRect = glyphBoxRect
            }
            
        }
        
        if  !self.CheckEmpity(tmpRect) {
            let valueOriginY:CGFloat = tmpRect.origin.y
            
            for tmpValue in glyphBoxes {
                let glyphBox = tmpValue as! FPKGlyphBox
                let glyphBoxRect :CGRect =  glyphBox.box
                
                let originY:CGFloat = glyphBoxRect.origin.y
                if valueOriginY == originY {
                    tmpRect = glyphBoxRect.union(tmpRect);
                }
            }
            
        }
        
        
        
        
        
        
        
        return true
    }
    
    
    func CheckEmpity(_ frm:CGRect) ->Bool{

        let empity:CGRect? = nil
        if frm == empity{
            return true
        }else{
            return false
        }
        
    }
    
}
