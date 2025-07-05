//
//  ContentView.swift
//  worktree
//
//  Created by 田中 颯志 on 7/5/25.
//

import SwiftUI

struct LiquidGlassView: View {
    @State private var animationOffset: CGFloat = 0
    @State private var touchLocation: CGPoint = .zero
    @State private var isPressed: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Canvas { context, size in
                    drawLiquidGlass(context: context, size: size)
                }
                .onAppear {
                    withAnimation(.linear(duration: 10).repeatForever(autoreverses: false)) {
                        animationOffset = 360
                    }
                }
                .onTapGesture { location in
                    touchLocation = location
                    withAnimation(.easeOut(duration: 0.5)) {
                        isPressed = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        isPressed = false
                    }
                }
            }
        }
    }
    
    private func drawLiquidGlass(context: GraphicsContext, size: CGSize) {
        let center = CGPoint(x: size.width / 2, y: size.height / 2)
        let baseRadius: CGFloat = min(size.width, size.height) / 3
        
        let numPoints = 20
        var points: [CGPoint] = []
        
        for i in 0..<numPoints {
            let angle = (CGFloat(i) / CGFloat(numPoints)) * 2 * .pi + animationOffset * .pi / 180
            
            let wave1 = sin(angle * 3 + animationOffset * .pi / 180) * 15
            let wave2 = cos(angle * 2 - animationOffset * .pi / 180) * 10
            let wave3 = sin(angle * 5 + animationOffset * .pi / 90) * 8
            
            var radius = baseRadius + wave1 + wave2 + wave3
            
            if isPressed {
                let distance = sqrt(pow(touchLocation.x - center.x, 2) + pow(touchLocation.y - center.y, 2))
                let influence = max(0, 1 - distance / 100)
                radius += influence * 30 * sin(animationOffset * .pi / 30)
            }
            
            let x = center.x + cos(angle) * radius
            let y = center.y + sin(angle) * radius
            
            points.append(CGPoint(x: x, y: y))
        }
        
        var path = Path()
        if !points.isEmpty {
            path.move(to: points[0])
            
            for i in 1..<points.count {
                let current = points[i]
                let previous = points[i - 1]
                
                let midPoint = CGPoint(
                    x: (current.x + previous.x) / 2,
                    y: (current.y + previous.y) / 2
                )
                
                path.addQuadCurve(to: midPoint, control: previous)
                path.addQuadCurve(to: current, control: midPoint)
            }
            
            let lastPoint = points[points.count - 1]
            let firstPoint = points[0]
            let midPoint = CGPoint(
                x: (lastPoint.x + firstPoint.x) / 2,
                y: (lastPoint.y + firstPoint.y) / 2
            )
            path.addQuadCurve(to: midPoint, control: lastPoint)
            path.addQuadCurve(to: firstPoint, control: midPoint)
            
            path.closeSubpath()
        }
        
        let mainGradient = Gradient(colors: [
            Color(red: 0.4, green: 0.8, blue: 1.0, opacity: 0.6),
            Color(red: 0.2, green: 0.6, blue: 0.9, opacity: 0.4),
            Color(red: 0.1, green: 0.4, blue: 0.8, opacity: 0.2)
        ])
        
        context.fill(path, with: .radialGradient(
            mainGradient,
            center: center,
            startRadius: 0,
            endRadius: baseRadius * 1.5
        ))
        
        let glowGradient = Gradient(colors: [
            Color.white.opacity(0.8),
            Color.white.opacity(0.3),
            Color.clear
        ])
        
        let glowRadius = baseRadius * 0.3
        let glowPath = Path(ellipseIn: CGRect(
            x: center.x - glowRadius,
            y: center.y - glowRadius * 1.5,
            width: glowRadius * 2,
            height: glowRadius
        ))
        
        context.fill(glowPath, with: .radialGradient(
            glowGradient,
            center: CGPoint(x: center.x, y: center.y - glowRadius),
            startRadius: 0,
            endRadius: glowRadius
        ))
        
        context.stroke(path, with: .color(Color.white.opacity(0.7)), lineWidth: 2)
        
        let shadowOffset = CGSize(width: 5, height: 10)
        let shadowPath = path.offsetBy(dx: shadowOffset.width, dy: shadowOffset.height)
        context.fill(shadowPath, with: .color(Color.black.opacity(0.2)))
    }
}

struct ContentView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.black, Color.gray.opacity(0.3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            LiquidGlassView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview {
    ContentView()
}
