//
//  BottomNoticeFloater.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 10/19/23.
//

import SwiftUI
import PopupView

public struct BottomNoticeFloater<T: View>: ViewModifier {
  @Binding var isPresented: Bool
  let view: T
  let bottomPadding: CGFloat
  let duration: CGFloat
  let dismissAction: (() -> Void)?
    
    public init(isPresented: Binding<Bool>, view: T, bottomPadding: CGFloat, duration: CGFloat, dismissAction: (() -> Void)?) {
        self._isPresented = isPresented
        self.view = view
        self.bottomPadding = bottomPadding
        self.duration = duration
        self.dismissAction = dismissAction
    }
    
    public func body(content: Content) -> some View {
    content
      .popup(isPresented: $isPresented) {
        view
          .padding(.horizontal, 20)
          .padding(.bottom, bottomPadding)
          .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
              isPresented.toggle()
            }
          }
      } customize: {
        $0
          .type(.floater(verticalPadding: 0, horizontalPadding: 0, useSafeAreaInset: false))
          .position(.bottom)
          .animation(.default)
          .closeOnTap(false)
          .closeOnTapOutside(false)
          .dragToDismiss(false)
          .dismissCallback {
            if let dismissAction {
              dismissAction()
            }
          }
      }
  }
}

extension View {
    public func bottomNoticeFloater<T: View>(
    isPresented: Binding<Bool>,
    view: T,
    bottomPadding: CGFloat = 130,
    duration: CGFloat = 2,
    dismissAction: (() -> Void)? = nil
  ) -> some View {
    modifier(
      BottomNoticeFloater(
        isPresented: isPresented,
        view: view,
        bottomPadding: bottomPadding,
        duration: duration,
        dismissAction: dismissAction)
    )
  }
}
