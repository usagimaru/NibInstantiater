//
//  StoryboardInstantiatable.swift
//
//  Created by Satori Maru on 17.05.15.
//  Copyright © 2017 usagimaru.
//

#if os(macOS)
import Cocoa
#elseif os(iOS)
import UIKit
#endif

public protocol StoryboardInstantiatable: class {
	
	/*
	// To customize the Storyboard name...
	static var storyboardName: String {
		return "<#Storyboard Name#>"
	}
	*/
	
	/// Custom Storyboard file name (Default name is `"Main"`.)
	static var storyboardName: String {get}
	/// Custom Storyboard ID name (Default name is `"\(self)"`, nil for Initial View Controller.)
	static var storyboardID: String? {get}
	
	static func loadFromStoryboard() -> Self
	static func loadFromStoryboard(storyboardID: String?) -> Self
	
}

public extension StoryboardInstantiatable {
	
	static var storyboardName: String {
		return "Main"
	}
	
	// デフォルト実装では View Controller 名を ID として返す
	static var storyboardID: String? {
		return "\(self)"
	}
	
	static func loadFromStoryboard() -> Self {
		return loadFromStoryboard(storyboardID: self.storyboardID)
	}
	
	static func loadFromStoryboard(storyboardID: String?) -> Self {
		#if os(macOS)
		
		let sb = NSStoryboard(name: NSStoryboard.Name(self.storyboardName), bundle: nil)
		
		if let storyboardID = storyboardID {
			return sb.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(storyboardID)) as! Self
		}
		else {
			return sb.instantiateInitialController() as! Self
		}
		
		#elseif os(iOS)
		
		let sb = UIStoryboard(name: self.storyboardName, bundle: nil)
		
		if let storyboardID = storyboardID {
			return sb.instantiateViewController(identifier: storyboardID) as! Self
		}
		else {
			return sb.instantiateInitialViewController() as! Self
		}
		
		#endif
	}
	
}
