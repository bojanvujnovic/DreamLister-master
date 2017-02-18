//
//  Item+CoreDataClass.swift
//  
//
//  Created by Mac on 2/18/17.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData

@objc(Item)
public class Item: NSManagedObject {

    public override func awakeFromInsert() {
        super.awakeFromInsert()
        self.created =  NSDate()
    }
}
