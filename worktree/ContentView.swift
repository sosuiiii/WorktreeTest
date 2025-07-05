//
//  ContentView.swift
//  worktree
//
//  Created by 田中 颯志 on 7/5/25.
//

import SwiftUI

struct LiquidGlassView: View {
    @State private var waveOffset: CGFloat = 0
    @State private var isAnimating = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [
                        Color.blue.opacity(0.1),
                        Color.cyan.opacity(0.2),
                        Color.white.opacity(0.3)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                // Liquid wave effect
                WaveShape(offset: waveOffset, amplitude: 30, frequency: 0.02)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.blue.opacity(0.3),
                                Color.cyan.opacity(0.4),
                                Color.white.opacity(0.2)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .blendMode(.overlay)
                
                // Glass effect overlay
                Rectangle()
                    .fill(Color.white.opacity(0.1))
                    .overlay(
                        Rectangle()
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
                    .blur(radius: 0.5)
                
                // Floating particles
                ForEach(0..<15, id: \.self) { index in
                    FloatingParticle(index: index, isAnimating: isAnimating)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        isAnimating = true
        
        // Wave animation
        withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
            waveOffset = 400
        }
    }
}

struct WaveShape: Shape {
    var offset: CGFloat
    let amplitude: CGFloat
    let frequency: CGFloat
    
    var animatableData: CGFloat {
        get { offset }
        set { offset = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.width
        let height = rect.height
        let midHeight = height * 0.5
        
        path.move(to: CGPoint(x: 0, y: midHeight))
        
        for x in stride(from: 0, through: width, by: 1) {
            let relativeX = x / width
            let sine = sin((relativeX + offset * frequency) * .pi * 2)
            let y = midHeight + sine * amplitude
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.closeSubpath()
        
        return path
    }
}

struct FloatingParticle: View {
    let index: Int
    let isAnimating: Bool
    @State private var position: CGPoint = CGPoint(x: 50, y: 50)
    @State private var opacity: Double = 0.5
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        Circle()
            .fill(Color.white.opacity(opacity))
            .frame(width: CGFloat.random(in: 2...6), height: CGFloat.random(in: 2...6))
            .scaleEffect(scale)
            .position(position)
            .onAppear {
                if isAnimating {
                    startFloating()
                }
            }
            .onChange(of: isAnimating) { _, newValue in
                if newValue {
                    startFloating()
                }
            }
    }
    
    private func startFloating() {
        let randomDelay = Double.random(in: 0...2)
        let randomDuration = Double.random(in: 2...4)
        
        withAnimation(.easeInOut(duration: randomDuration).repeatForever(autoreverses: true).delay(randomDelay)) {
            position = CGPoint(
                x: CGFloat.random(in: 20...300),
                y: CGFloat.random(in: 20...500)
            )
        }
        
        withAnimation(.easeInOut(duration: randomDuration * 0.8).repeatForever(autoreverses: true).delay(randomDelay)) {
            opacity = Double.random(in: 0.2...0.8)
            scale = CGFloat.random(in: 0.5...1.5)
        }
    }
}

struct ContentView: View {
    var body: some View {
        VStack(spacing: 30) {
            Text("Liquid Glass Effect")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            LiquidGlassView()
                .frame(width: 300, height: 400)
            
            Text("Custom SwiftUI Implementation")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                colors: [Color.gray.opacity(0.1), Color.blue.opacity(0.05)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
}

#Preview {
    ContentView()
}
