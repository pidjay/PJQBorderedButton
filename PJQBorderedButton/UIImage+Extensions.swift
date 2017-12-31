//
//  UIImage+Extensions.swift
//  PJQBorderedButton
//
//  Created by Pierre-Jean Quilleré on 3/28/16.
//  Copyright © 2016 Pierre-Jean Quilleré. All rights reserved.
//

import UIKit

extension UIImage {
	
	class func ext_imageWithColor(color: UIColor) -> UIImage
	{
		return self.ext_imageWithColor(color, size: CGSize(width: 1.0, height: 1.0))
	}
	
	class func ext_imageWithColor(color: UIColor, size: CGSize) -> UIImage
	{
		UIGraphicsBeginImageContext(size)
		let context = UIGraphicsGetCurrentContext()
		
		CGContextSetFillColorWithColor(context, color.CGColor)
		CGContextFillRect(context, CGRect(origin: CGPoint.zero, size: size))
		
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return image
	}
}
