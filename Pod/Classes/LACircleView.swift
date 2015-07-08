//
//  LACircleView.swift
//  LACircleViewExample
//
//  Created by huhk.fnst@g08 on 15/7/3.
//  Copyright © 2015年 com.laker. All rights reserved.
//

import UIKit
import Darwin
import CoreGraphics



@IBDesignable
public class LACircleView: UIView {
    
    @IBInspectable public var strokeWidth : CGFloat = 5.0
    
    @IBInspectable public var isAutojustRadius : Bool = false{
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    
    @IBInspectable public var progress : CGFloat = 0.0 {
        didSet{
            if(didLayoutSubView){
                circleLayer.path = getBezierPath(self.bounds, progress: self.progress).CGPath
                self.drawStroke()
            }
        }
    }
    @IBInspectable public var percentOfCircle : CGFloat = 1.0{
        didSet{
            if(didLayoutSubView){
                circleLayer.path = getBezierPath(self.bounds, progress: self.progress).CGPath
                self.setNeedsDisplay()
                self.drawStroke()

            }
        }
    }


    
    @IBInspectable public var isRectCap : Bool = false
    @IBInspectable public var showArrow : Bool = false

    @IBInspectable public var startColor : UIColor = UIColor.cyanColor()
    @IBInspectable public var middleColor : UIColor?
    @IBInspectable public var endColor : UIColor = UIColor.cyanColor()

    @IBInspectable public var baseLineColor :UIColor = UIColor.lightGrayColor()

    
    
    
    let circleLayer : CAShapeLayer = CAShapeLayer()
    let arrow : CAShapeLayer = CAShapeLayer()
    let strokePercent :CGFloat = 0.05
    
    
    
    var didLayoutSubView : Bool = false
    
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    
    override public func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        //adjust stroke width
        let radiusAndStroke = getRadiusAndStrokeWidth(rect: rect)
        
        //draw the base circle
        let angle = CGFloat(M_PI) * (1 - self.percentOfCircle)
        let Pi : CGFloat = CGFloat(M_PI)
        let Pi_2 : CGFloat = CGFloat(M_PI_2)
        CGContextAddArc(context, rect.size.width / 2 , radiusAndStroke.radius + radiusAndStroke.strokeWidth / 2, radiusAndStroke.radius ,   Pi_2 + angle ,   2.5 * Pi - angle , 0)
        CGContextSetStrokeColorWithColor(context, self.baseLineColor.CGColor)
        CGContextSetLineWidth(context, radiusAndStroke.strokeWidth)
        CGContextSetLineCap(context,isRectCap ? kCGLineCapSquare : kCGLineCapRound)
        CGContextDrawPath(context, kCGPathStroke)
    }
    
    override public func awakeFromNib() {
        configure()
    }
    
    
    func configure(){
        circleLayer.lineCap = kCALineCapRound;
        circleLayer.fillColor = UIColor.clearColor().CGColor;
        circleLayer.zPosition = 1;
        self.layer.addSublayer(circleLayer)
        
        if(self.showArrow){
            self.arrow.frame = CGRectMake(0, 0, self.strokeWidth, self.strokeWidth);
            self.arrow.fillColor = UIColor.whiteColor().CGColor;
            self.arrow.fillRule = kCAFillRuleEvenOdd;
        }
    }
    
    override public func layoutSubviews() {
        didLayoutSubView = true
        let rect = self.bounds
        let path : UIBezierPath = getBezierPath(rect, progress: self.progress)
        circleLayer.lineWidth = getRadiusAndStrokeWidth(rect: rect).strokeWidth
        circleLayer.path = path.CGPath
        
        
        if(self.showArrow){
            updateArrow()
        }
        super.layoutSubviews()

    }
    
    // MARK: help functions
    func getRadiusAndStrokeWidth(#rect:CGRect) -> (strokeWidth : CGFloat, radius :CGFloat ){
        func getRadius(rect:CGRect, stroke:CGFloat) ->CGFloat{
            if(self.percentOfCircle >= 0.5){
                let radius1 = (rect.size.width - stroke) / 2
                let radius2 = (rect.size.height - stroke) / CGFloat(cosf(Float(1 - self.percentOfCircle) * Float(M_PI)) + 1)
                return min(radius1, radius2)
            }else if(self.percentOfCircle > 0){
                let radius1 = (rect.size.width - stroke) / 2 / CGFloat(sinf(Float(self.percentOfCircle) * Float(M_PI)))
                let radius2 = (rect.size.height - stroke / 2 ) / (1 - CGFloat(cosf(Float(self.percentOfCircle))))
                return min(radius1, radius2)
            }else{
                return 0
            }
        }
        
        let strokeWidth = isAutojustRadius ? (rect.size.height < rect.size.width ? rect.size.height * self.strokePercent : rect.size.width * self.strokePercent) : self.strokeWidth
        return (strokeWidth,getRadius(rect,strokeWidth))
        
    }
    
    
    func getBezierPath(rect:CGRect,progress:CGFloat) -> UIBezierPath{
        
        //adjust stroke width
        let radiusAndStroke = getRadiusAndStrokeWidth(rect: rect)
        
        //draw the base circle
        let angle = (1 - self.percentOfCircle) * CGFloat(M_PI)
        let startAngle = CGFloat(M_PI_2) + angle
        let endAngle = 2 * CGFloat(M_PI) + CGFloat(M_PI_2) - angle - (2 * CGFloat(M_PI) - 2 * angle) * (1-progress)
        let path = UIBezierPath()
        if(endAngle > startAngle){
            path.addArcWithCenter(CGPointMake(rect.size.width / 2 , radiusAndStroke.radius + radiusAndStroke.strokeWidth / 2), radius: radiusAndStroke.radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        }
        return path
    }

    func getPointByAngle(angle : CGFloat, radius : CGFloat ,strokeWidth: CGFloat, rect : CGRect) -> CGPoint{
        let x = rect.size.width / 2 - CGFloat( sinf(Float(angle))) * radius
        let y = strokeWidth / 2 +  CGFloat ( cosf(Float(angle)) ) * radius + radius
        return CGPoint(x: x,y: y)
    }
    
    func updateArrow(){
        let strokeAndRadius = getRadiusAndStrokeWidth(rect: self.bounds)
        
        
        self.arrow.frame = CGRectMake(0, 0, strokeAndRadius.strokeWidth, strokeAndRadius.strokeWidth)
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x:0, y:strokeAndRadius.strokeWidth))
        path.addLineToPoint(CGPoint(x:strokeAndRadius.strokeWidth / 2, y:0))
        path.addLineToPoint(CGPoint(x:strokeAndRadius.strokeWidth , y:strokeAndRadius.strokeWidth))
        
        let radius = strokeAndRadius.radius - strokeAndRadius.strokeWidth / 2
        
        let angle = CGFloat(asinf(Float(strokeAndRadius.strokeWidth / 2 / strokeAndRadius.radius)))
        path.addArcWithCenter(CGPoint(x: strokeAndRadius.strokeWidth / 2 , y: CGFloat(sqrtf(Float( strokeAndRadius.strokeWidth + radius * radius - strokeAndRadius.strokeWidth / 2 * strokeAndRadius.strokeWidth / 2))) + strokeAndRadius.strokeWidth ), radius: radius, startAngle: CGFloat(1.5 * M_PI) + angle, endAngle: CGFloat(1.5 * M_PI), clockwise: false)
        self.arrow.path = path.CGPath;
    }
    
    // MARK: public functions
    public func drawStroke(){
        circleLayer.removeAllAnimations()
        circleLayer.sublayers = nil
        let pathAnimation = CABasicAnimation()
        pathAnimation.keyPath = "strokeEnd"

        pathAnimation.duration = 1.0;
        pathAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut);
        pathAnimation.fromValue = 0.0;
        pathAnimation.toValue = 1.0;
        
        circleLayer.addAnimation(pathAnimation, forKey: "strokeEndAnimation");
        circleLayer.strokeEnd = 1.0

        
        //add gradient color for line
        let gradientMask = CAShapeLayer()
        gradientMask.fillColor = UIColor.clearColor().CGColor;
        gradientMask.strokeColor = UIColor.blackColor().CGColor;
        gradientMask.lineWidth = circleLayer.lineWidth;
        gradientMask.lineCap = self.isRectCap ? kCALineCapSquare : kCALineCapRound;
        
        
        let gradientFrame = CGRectMake(0, 0, 2 * self.bounds.size.width, 2*self.bounds.size.height);
        gradientMask.frame = gradientFrame;
        gradientMask.path = circleLayer.path;
        
        let gradientLayer = CAGradientLayer();
        gradientLayer.startPoint = CGPointMake( 0,0.5);
        gradientLayer.endPoint = CGPointMake((self.frame.size.width / 2 ) / self.frame.size.width,0.5);
        gradientLayer.frame = gradientFrame;
        
        
        var colors : Array<AnyObject>?
        if((self.middleColor) != nil){
            colors = [self.startColor.CGColor,self.middleColor!.CGColor,self.endColor.CGColor]
        }else{
            colors = [self.startColor.CGColor,self.endColor.CGColor]
        }
        
        gradientMask.strokeEnd = 1.0
        gradientMask.addAnimation( pathAnimation, forKey: "strokeEndAnimation")
        
        gradientLayer.colors = colors
        gradientLayer.mask = gradientMask
        circleLayer.addSublayer(gradientLayer)
        
        if(self.showArrow){
            let strokeAndRadius = getRadiusAndStrokeWidth(rect: self.bounds)
            self.arrow.removeAllAnimations()
            
            if(self.progress > 0){
                //to cover the stroke width of line
                CATransaction.begin()
                CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
                self.arrow.transform = CATransform3DMakeRotation(0,0,0,1)
                CATransaction.commit()
                let angle = self.percentOfCircle != 1 ? CGFloat(asinf(Float(strokeAndRadius.strokeWidth / 2 / (strokeAndRadius.radius - strokeAndRadius.strokeWidth / 2)))) / CGFloat(2 * M_PI) : 0
                let path = getBezierPath(self.bounds,progress: self.progress + angle)
                let anim = CAKeyframeAnimation(keyPath: "position")
                anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut);
                anim.path = path.CGPath;
                anim.rotationMode = kCAAnimationRotateAuto;
                anim.repeatCount = 0;
                anim.autoreverses = false;
                anim.fillMode = kCAFillModeForwards;
                anim.removedOnCompletion = false;
                anim.duration = 1.0
                self.arrow.addAnimation(anim, forKey: "arrow")
            }else{
                let strokeWidthAngle = self.percentOfCircle != 1 ? strokeAndRadius.strokeWidth / 2.0 / ( CGFloat(2 * M_PI) * (strokeAndRadius.radius - strokeAndRadius.strokeWidth / 2) ) : 0
                let centerPoint = getPointByAngle((1 - self.percentOfCircle) * CGFloat(M_PI) - strokeWidthAngle , radius: strokeAndRadius.radius, strokeWidth: strokeAndRadius.strokeWidth , rect: self.bounds)
                CATransaction.begin()
                CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
                self.arrow.position = centerPoint
                self.arrow.transform = CATransform3DMakeRotation(-(self.percentOfCircle) * CGFloat(M_PI) - strokeWidthAngle,0,0,1)
                CATransaction.commit()

            }
            self.circleLayer.addSublayer(self.arrow)
        }
        
    }
    
    



}
