//
//  PJQBorderedButton.swift
//  PJQBorderedButton
//
//  Created by Pierre-Jean Quilleré on 03/28/16.
//  Copyright © 2016 Pierre-Jean Quilleré. All rights reserved.
//

import UIKit

class PJQBorderedButton: UIButton {
	
	private var _inactiveStateTitleColor: UIColor?
	var inactiveStateTitleColor: UIColor? {
		get {
			return _inactiveStateTitleColor
		}
		set {
			_inactiveStateTitleColor = newValue
			self.updatePropertiesUsingTintColor()
		}
	}
	private var _inactiveStateBorderColor: UIColor?
	var inactiveStateBorderColor: UIColor? {
		get {
			return _inactiveStateBorderColor
		}
		set {
			_inactiveStateBorderColor = newValue
			self.updateBorderColor()
		}
	}
	
	var activeStateTitleColor: UIColor?
	var activeStateBackgroundColor: UIColor?
	
	private var _cornerRadius: CGFloat?
	var cornerRadius: CGFloat {
		get {
			return _cornerRadius ?? self.frame.height / 2.0
		}
		set {
			_cornerRadius = newValue
			self.setNeedsLayout()
		}
	}
	
	override var enabled: Bool {
		get { return super.enabled }
		set {
			super.enabled = newValue
			self.updateBorderColor()
		}
	}
	override var highlighted: Bool {
		get { return super.highlighted }
		set {
			super.highlighted = newValue
			self.updateBorderColor()
		}
	}
	override var selected: Bool {
		get { return super.selected }
		set {
			super.selected = newValue
			self.updateBorderColor()
		}
	}
	private var enabledTintColor: UIColor {
		get { return self.tintColor }
	}
	private var disabledTintColor: UIColor {
		get { return self.disabledColor(self.tintColor) }
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.setupView()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.setupView()
	}
	
	override func tintColorDidChange() {
		super.tintColorDidChange()
		
		self.updatePropertiesUsingTintColor()
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		self.layer.cornerRadius = self.cornerRadius
	}
	
	func setupView() {
		
		let activeStateTitleColor = self.activeStateTitleColor ?? UIColor.whiteColor()
		
		self.contentEdgeInsets = UIEdgeInsets(top: 6.0, left: 12.0, bottom: 6.0, right: 12.0)
		
		// borderColor uses tintColor
		self.layer.borderWidth = 1.0
		self.layer.masksToBounds = true // prevents the image to spill out of the rounded border
		
		self.setBackgroundImage(UIImage.ext_imageWithColor(UIColor.clearColor()), forState: UIControlState.Normal)
		// .Highlighted uses tintColor
		// .Selected uses tintColor
		
		// .Normal uses tintColor
		self.setTitleColor(activeStateTitleColor, forState: UIControlState.Highlighted)
		self.setTitleColor(activeStateTitleColor, forState: [UIControlState.Highlighted, UIControlState.Disabled])
		self.setTitleColor(activeStateTitleColor, forState: UIControlState.Selected)
		self.setTitleColor(activeStateTitleColor, forState: [UIControlState.Selected, UIControlState.Disabled])
		self.setTitleColor(activeStateTitleColor, forState: [UIControlState.Highlighted, UIControlState.Selected])
		self.setTitleColor(activeStateTitleColor, forState: [UIControlState.Highlighted, UIControlState.Selected, UIControlState.Disabled])
		
		self.updatePropertiesUsingTintColor()
	}
	
	func updatePropertiesUsingTintColor() {
		
		var enabledTintColor = self.enabledTintColor
		var disabledTintColor = self.disabledTintColor
		
		// Use the active background color if available, otherwise fallback to the tint color
		if let activeStateBackgroundColor = self.activeStateBackgroundColor {
			enabledTintColor = activeStateBackgroundColor
			disabledTintColor = self.disabledColor(activeStateBackgroundColor)
		}
		
		self.updateBorderColor()
		
		self.setBackgroundImage(UIImage.ext_imageWithColor(enabledTintColor), forState: UIControlState.Highlighted)
		self.setBackgroundImage(UIImage.ext_imageWithColor(disabledTintColor), forState: [UIControlState.Highlighted, UIControlState.Disabled])
		
		self.setBackgroundImage(UIImage.ext_imageWithColor(enabledTintColor), forState: UIControlState.Selected)
		self.setBackgroundImage(UIImage.ext_imageWithColor(disabledTintColor), forState: [UIControlState.Selected, UIControlState.Disabled])
		
		self.setBackgroundImage(UIImage.ext_imageWithColor(enabledTintColor), forState: [UIControlState.Highlighted, UIControlState.Selected])
		self.setBackgroundImage(UIImage.ext_imageWithColor(disabledTintColor), forState: [UIControlState.Highlighted, UIControlState.Selected, UIControlState.Disabled])
		
		// Use the title color if available
		if let inactiveStateTitleColor = self.inactiveStateTitleColor {
			enabledTintColor = inactiveStateTitleColor
			disabledTintColor = self.disabledColor(inactiveStateTitleColor)
		}
		
		self.setTitleColor(enabledTintColor, forState: UIControlState.Normal)
		self.setTitleColor(disabledTintColor, forState: [UIControlState.Normal, UIControlState.Disabled])
	}
	
	func updateBorderColor() {
		let newBorderColor: UIColor
		if self.selected || self.highlighted {
			newBorderColor = UIColor.clearColor() // otherwise when disabled the border and the background colors alpha are added
		}
		else {
			if let inactiveStateBorderColor = self.inactiveStateBorderColor {
				newBorderColor = self.enabled ? inactiveStateBorderColor : self.disabledColor(inactiveStateBorderColor)
			}
			else {
				newBorderColor = self.enabled ? self.enabledTintColor : self.disabledTintColor
			}
		}
		self.layer.borderColor = newBorderColor.CGColor
	}
	
	// MARK: - Helpers
	
	func disabledColor(color: UIColor) -> UIColor {
		return color.colorWithAlphaComponent(0.5)
	}
	
}
