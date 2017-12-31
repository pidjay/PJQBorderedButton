//
//  PJQBorderedButton.swift
//  PJQBorderedButton
//
//  Created by Pierre-Jean Quilleré on 03/28/16.
//  Copyright © 2016 Pierre-Jean Quilleré. All rights reserved.
//

import UIKit

public class PJQBorderedButton: UIButton {
	
	private var _inactiveStateTitleColor: UIColor?
	public var inactiveStateTitleColor: UIColor? {
		get {
			return _inactiveStateTitleColor
		}
		set {
			_inactiveStateTitleColor = newValue
			self.updatePropertiesUsingTintColor()
		}
	}
	private var _inactiveStateBorderColor: UIColor?
	public var inactiveStateBorderColor: UIColor? {
		get {
			return _inactiveStateBorderColor
		}
		set {
			_inactiveStateBorderColor = newValue
			self.updateBorderColor()
		}
	}
	
	public var activeStateTitleColor: UIColor?
	public var activeStateBackgroundColor: UIColor?
	
	private var _cornerRadius: CGFloat?
	public var cornerRadius: CGFloat {
		get {
			return _cornerRadius ?? self.frame.height / 2.0
		}
		set {
			_cornerRadius = newValue
			self.setNeedsLayout()
		}
	}
	
	override public var isEnabled: Bool {
		get { return super.isEnabled }
		set {
			super.isEnabled = newValue
			self.updateBorderColor()
		}
	}
	override public var isHighlighted: Bool {
		get { return super.isHighlighted }
		set {
			super.isHighlighted = newValue
			self.updateBorderColor()
		}
	}
	override public var isSelected: Bool {
		get { return super.isSelected }
		set {
			super.isSelected = newValue
			self.updateBorderColor()
		}
	}
	private var enabledTintColor: UIColor {
		get { return self.tintColor }
	}
	private var disabledTintColor: UIColor {
		get { return self.disabledColor(for: self.tintColor) }
	}
	
	override public init(frame: CGRect) {
		super.init(frame: frame)
		self.setupView()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.setupView()
	}
	
	override public func tintColorDidChange() {
		super.tintColorDidChange()
		
		self.updatePropertiesUsingTintColor()
	}
	
	override public func layoutSubviews() {
		super.layoutSubviews()
		
		self.layer.cornerRadius = self.cornerRadius
	}
	
	private func setupView() {
		
		let activeStateTitleColor = self.activeStateTitleColor ?? UIColor.white
		
		self.contentEdgeInsets = UIEdgeInsets(top: 6.0, left: 12.0, bottom: 6.0, right: 12.0)
		
		// borderColor uses tintColor
		self.layer.borderWidth = 1.0
		self.layer.masksToBounds = true // prevents the image to spill out of the rounded border
		
		self.setBackgroundImage(UIImage.ext_imageWithColor(UIColor.clear), for: .normal)
		// .Highlighted uses tintColor
		// .Selected uses tintColor
		
		// .Normal uses tintColor
		self.setTitleColor(activeStateTitleColor, for: .highlighted)
		self.setTitleColor(activeStateTitleColor, for: [.highlighted, .disabled])
		self.setTitleColor(activeStateTitleColor, for: .selected)
		self.setTitleColor(activeStateTitleColor, for: [.selected, .disabled])
		self.setTitleColor(activeStateTitleColor, for: [.highlighted, .selected])
		self.setTitleColor(activeStateTitleColor, for: [.highlighted, .selected, .disabled])
		
		self.updatePropertiesUsingTintColor()
	}
	
	private func updatePropertiesUsingTintColor() {
		
		var enabledTintColor = self.enabledTintColor
		var disabledTintColor = self.disabledTintColor
		
		// Use the active background color if available, otherwise fallback to the tint color
		if let activeStateBackgroundColor = self.activeStateBackgroundColor {
			enabledTintColor = activeStateBackgroundColor
			disabledTintColor = self.disabledColor(for: activeStateBackgroundColor)
		}
		
		self.updateBorderColor()
		
		self.setBackgroundImage(UIImage.ext_imageWithColor(enabledTintColor), for: .highlighted)
		self.setBackgroundImage(UIImage.ext_imageWithColor(disabledTintColor), for: [.highlighted, .disabled])
		
		self.setBackgroundImage(UIImage.ext_imageWithColor(enabledTintColor), for: .selected)
		self.setBackgroundImage(UIImage.ext_imageWithColor(disabledTintColor), for: [.selected, .disabled])
		
		self.setBackgroundImage(UIImage.ext_imageWithColor(enabledTintColor), for: [.highlighted, .selected])
		self.setBackgroundImage(UIImage.ext_imageWithColor(disabledTintColor), for: [.highlighted, .selected, .disabled])
		
		// Use the title color if available
		if let inactiveStateTitleColor = self.inactiveStateTitleColor {
			enabledTintColor = inactiveStateTitleColor
			disabledTintColor = self.disabledColor(for: inactiveStateTitleColor)
		}
		
		self.setTitleColor(enabledTintColor, for: .normal)
		self.setTitleColor(disabledTintColor, for: [.normal, .disabled])
	}
	
	private func updateBorderColor() {
		let newBorderColor: UIColor
		if self.isSelected || self.isHighlighted {
			newBorderColor = UIColor.clear // otherwise when disabled the border and the background colors alpha are added
		}
		else {
			if let inactiveStateBorderColor = self.inactiveStateBorderColor {
				newBorderColor = self.isEnabled ? inactiveStateBorderColor : self.disabledColor(for: inactiveStateBorderColor)
			}
			else {
				newBorderColor = self.isEnabled ? self.enabledTintColor : self.disabledTintColor
			}
		}
		self.layer.borderColor = newBorderColor.cgColor
	}
	
	// MARK: - Helpers
	
	private func disabledColor(for color: UIColor) -> UIColor {
		return color.withAlphaComponent(0.5)
	}
	
}
