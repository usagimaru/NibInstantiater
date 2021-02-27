//
//  Cross-Platform.swift
//
//  Created by usagimaru on 2020.11.17.
//  Copyright © 2020 usagimaru.
//

#if os(macOS)
import Cocoa
public typealias View = NSView
public typealias Nib = NSNib
public typealias Storyboard = NSStoryboard
#elseif os(iOS)
import UIKit
public typealias View = UIView
public typealias Nib = UINib
public typealias Storyboard = UIStoryboard
#endif
