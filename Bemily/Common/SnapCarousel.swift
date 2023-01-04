//
//  SnapCarousel.swift
//  Bemily
//
//  Created by 임훈 on 2023/01/03.
//

import SwiftUI

struct SnapCarousel<Content: View, T: Identifiable>: View {
    
    var content: (T) -> Content
    var list: [T]
    var spacing: CGFloat
    var trailingSpace: CGFloat
    @Binding var index: Int
    @GestureState var offset: CGFloat = 0
    @State var currentIndex: Int = 0
    
    init(spacing: CGFloat = 15,
         trailingSpace: CGFloat = 100,
         index: Binding<Int>,
         items: [T],
         @ViewBuilder content: @escaping (T)->Content) {
        self.list = items
        self.spacing = spacing
        self.trailingSpace = trailingSpace
        self._index = index
        self.content = content
    }
    
    var body: some View {
        GeometryReader { proxy in
            let width = (proxy.size.width - (trailingSpace - spacing)) // 한개 셀 이동 폭
            let adjustMentWidth = (trailingSpace / 2) - spacing // 처음 셀 제외 padding 값
            HStack(spacing: spacing) {
                ForEach(list) { item in
                    content(item)
                        .frame(width: proxy.size.width - trailingSpace)
                }
            }
            .padding(.horizontal, spacing)
            .offset(x: (CGFloat(currentIndex) * -width ) + (currentIndex != 0 ? adjustMentWidth : adjustMentWidth) + offset)
            .gesture(
                DragGesture()
                    .updating($offset, body: { value, out, _ in
                        out = value.translation.width
                    })
                    .onEnded({ value in
                        let offsetX = value.translation.width
                        let progress = -offsetX / width
                        let roundIndex = progress.rounded()
                        currentIndex = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
                        currentIndex = index
                    })
                    .onChanged({ value in
                        let offsetX = value.translation.width
                        let progress = -offsetX / width
                        let roundIndex = progress.rounded()
                        
                        // 전달 받은 index 값 갱신
                        index = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
                    })
            )
        }
        .animation(.easeInOut, value: offset == 0)
    }
} 
