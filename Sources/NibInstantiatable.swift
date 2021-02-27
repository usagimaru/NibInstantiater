//
//  NibInstantiatable.swift
//
//  Created by Satori Maru on 2018.11.26.
//  Copyright © 2018 usagimaru.
//

#if os(macOS)
import Cocoa
#elseif os(iOS)
import UIKit
#endif

public protocol NibInstantiatable: View {

	/*
	// To customize the nib name...
	static var nibName: String {
		return "<#Nib Name#>"
	}
	*/
	/// Custom nib file name (Default name is `"\(Self.self)"`.)
	static var nibName: String {get}

	static func nib(in bundle: Bundle?) -> Nib
	
	func loadOwnedNib(_ bundle: Bundle?)
	static func loadUnwnedNib(_ bundle: Bundle?) -> Self
	
	func didViewLoadedFromNib()

}

public extension NibInstantiatable {

	static var nibName: String {
		return "\(Self.self)"
	}
	
	static func nib(in bundle: Bundle? = nil) -> Nib {
		#if os(macOS)
		return NSNib(nibNamed: NSNib.Name("\(self.nibName)") , bundle: bundle)!
		#elseif os(iOS)
		return UINib(nibName: self.nibName, bundle: bundle)
		#endif
	}
	
	private func setNibLoadedView(_ contentView: View) {
		contentView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(contentView)
		
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[contentView]-0-|",
													  options: NSLayoutConstraint.FormatOptions(),
													  metrics: nil,
													  views: ["contentView" : contentView]))
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[contentView]-0-|",
													  options: NSLayoutConstraint.FormatOptions(),
													  metrics: nil,
													  views: ["contentView" : contentView]))
	}
	
	private static func loadNib<T>(bundle: Bundle?, filesOwner: Any?) -> T {
		#if os(macOS)
		
		var objs: NSArray?
		let nib = Self.nib(in: bundle)
		nib.instantiate(withOwner: filesOwner, topLevelObjects: &objs)
		
		if let objs = objs, let instance = (objs.filter {$0 is T} as NSArray).firstObject as? T {
			return instance
		}
		
		#elseif os(iOS)
		
		let nib = Self.nib(in: bundle)
		let objs = nib.instantiate(withOwner: filesOwner, options: nil)
		
		if let instance = (objs.filter {$0 is T}).first as? T {
			return instance
		}
		
		#endif
		
		fatalError("Unable to load any instances from the nib file.")
	}
	
	/// nib からビューをロード（File’s Owner == self）
	func loadOwnedNib(_ bundle: Bundle? = nil) {
		let view: View = Self.loadNib(bundle: bundle, filesOwner: self)
		setNibLoadedView(view)
		didViewLoadedFromNib()
	}
	
	/// nib からロード（nib のビューにビュークラスを直接適用している場合／File’s Owner = nil）
	static func loadUnownedNib(_ bundle: Bundle? = nil) -> Self {
		let view: Self = Self.loadNib(bundle: bundle, filesOwner: nil)
		view.didViewLoadedFromNib()
		return view
	}
	
	func didViewLoadedFromNib() {
		// Implement on subclasses if needed.
	}

}

