//
//  ContentView.swift
//  worktree
//
//  Created by 田中 颯志 on 7/5/25.
//

import SwiftUI

struct LiquidGlass: View {
    @State private var animationOffset: CGFloat = 0
    @State private var rippleOffset: CGFloat = 0
    
    let content: AnyView
    
    init<Content: View>(@ViewBuilder content: () -> Content) {
        self.content = AnyView(content())
    }
    
    var body: some View {
        ZStack {
            content
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.white.opacity(0.3),
                                        Color.white.opacity(0.1),
                                        Color.clear
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.white.opacity(0.6),
                                        Color.white.opacity(0.2)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.5
                            )
                        
                        Circle()
                            .fill(
                                RadialGradient(
                                    gradient: Gradient(colors: [
                                        Color.white.opacity(0.4),
                                        Color.clear
                                    ]),
                                    center: .center,
                                    startRadius: 10,
                                    endRadius: 60
                                )
                            )
                            .frame(width: 120, height: 120)
                            .offset(x: animationOffset - 40, y: -50)
                            .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: animationOffset)
                        
                        Circle()
                            .fill(
                                RadialGradient(
                                    gradient: Gradient(colors: [
                                        Color.blue.opacity(0.2),
                                        Color.clear
                                    ]),
                                    center: .center,
                                    startRadius: 20,
                                    endRadius: 80
                                )
                            )
                            .frame(width: 160, height: 160)
                            .scaleEffect(1 + rippleOffset * 0.3)
                            .opacity(1 - rippleOffset)
                            .animation(.easeOut(duration: 2).repeatForever(autoreverses: false), value: rippleOffset)
                        
                        RoundedRectangle(cornerRadius: 20)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(stops: [
                                        .init(color: Color.white.opacity(0.1), location: 0),
                                        .init(color: Color.clear, location: 0.3),
                                        .init(color: Color.clear, location: 0.7),
                                        .init(color: Color.white.opacity(0.05), location: 1)
                                    ]),
                                    startPoint: UnitPoint(x: animationOffset / 200, y: 0),
                                    endPoint: UnitPoint(x: (animationOffset / 200) + 0.3, y: 1)
                                )
                            )
                            .animation(.linear(duration: 4).repeatForever(autoreverses: false), value: animationOffset)
                    }
                )
        }
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        .shadow(color: Color.white.opacity(0.8), radius: 1, x: 0, y: -1)
        .onAppear {
            animationOffset = 200
            rippleOffset = 1
        }
    }
}

struct ContentView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.purple.opacity(0.8),
                    Color.blue.opacity(0.6),
                    Color.cyan.opacity(0.4)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                LiquidGlass {
                    VStack {
                        Image(systemName: "drop.fill")
                            .imageScale(.large)
                            .foregroundStyle(.blue)
                            .font(.title)
                        Text("Liquid Glass")
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                    .padding(40)
                    .background(Color.clear)
                }
                
                LiquidGlass {
                    VStack {
                        Text("Custom Implementation")
                            .font(.headline)
                        Text("No standard APIs used")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(30)
                    .background(Color.clear)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
