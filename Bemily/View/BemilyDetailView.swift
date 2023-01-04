//
//  BemilyDetailView.swift
//  Bemily
//
//  Created by 임훈 on 2023/01/03.
//

import SwiftUI
import SDWebImageSwiftUI

struct BemilyDetailView: View {
    @EnvironmentObject var viewModel : APIManager
    @Environment(\.openURL) var openURL
    
    @State var showNewMore : Bool = false
    @State var showDecriptionMore : Bool = false
    @State var showCompatibility : Bool = false
    @State var showAdvisoryRating : Bool = false
    @State var showSheetAdvisoryRating : Bool = false
    @State var showShareSheet : Bool = false
    
    @State var reviewCurrentIndex : Int = 0
    @State var likeAppCurrentIndex : Int = 0
    
    @State var previewCount : Int = 1
    @State var starCount : Int = 0
    @State var reviewDetail : Bool = false
    @State var popupOpacity : CGFloat = 0
    
    
    let 앱지원URL = "https://www.befamily.co.kr"
    
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(spacing: 0) {
                    Group {
                        headerView(viewModel)
                        appScrollInfoView(viewModel)
                        versionView(viewModel)
                        screenshotView(viewModel)
                        descriptionView(viewModel)
                        developerView(viewModel)
                        evaluationReviewView(viewModel)
                        tapEvaluationView(viewModel)
                        reviewListView(viewModel)
                    }
                    Group {
                        appPermissionsView(viewModel)
                        appInfoView(viewModel)
                    }
                    Spacer()
                }
            }
            
            NavigationLink(destination: Text("리뷰 더보기"), isActive: $reviewDetail) {}
            
            VStack{
                Image(systemName: "star.fill")
                    .font(.system(size: 120, weight: .light))
                    .foregroundColor(.secondary)
                
                Text("제출됨")
                Text("피드백을 보내주셔서 감사합니다.")
            }
            .frame(width: 300, height: 300, alignment: .center)
            .background(Color("gray1").cornerRadius(20))
            .opacity(popupOpacity)
            .onChange(of: starCount) { _ in
                withAnimation(Animation.easeIn(duration: 2)) {
                    popupOpacity = 0
                }
            } 
        }
        .sheet(isPresented: $showSheetAdvisoryRating) {
            Text("연령등급")
        }
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(activityItems: ["\(viewModel.iTunes.trackName)"])
        }
    }
    
    // MARK: Header View
    @ViewBuilder
    func headerView(_ viewModel : APIManager) -> some View {
        HStack {
            WebImage(url: URL(string: viewModel.iTunes.artworkUrl512))
                .resizable()
                .frame(width: 135, height: 135, alignment: .center)
                .overlay(
                    RoundedRectangle(cornerRadius: 20).stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
            
            VStack(alignment: .leading, spacing: 0, content: {
                Text(viewModel.iTunes.trackName)
                    .font(.headline)
                Text("가까운 사람들끼리 쓰는 메신저")
                    .font(.system(size: 14, weight: .light))
                    .foregroundColor(.gray)
                
                Spacer()
                
                HStack(spacing: 0) {
                    Button {
                        
                    } label: {
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: 100, height: 36, alignment: .center)
                            .overlay(
                                Text("열기")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16, weight: .heavy))
                            )
                    }
                    
                    Spacer()
                    
                    Button {
                        showShareSheet.toggle()
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 24))
                        
                    }
                }
                .padding(.top, 20)
            })
            .padding(.horizontal, 10)
            .frame(height: 135)
        }
        .padding()
    }
    
    // MARK: App Scroll Info View
    @ViewBuilder
    func appScrollInfoView(_ viewModel : APIManager) -> some View {
        VStack {
            Divider()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    VStack(spacing: 5) {
                        Text("\(viewModel.iTunes.userRatingCountForCurrentVersion)개의 평가")
                            .font(.system(size: 12, weight: .light))
                        
                        Text(viewModel.iTunes.getRating())
                            .font(.system(size: 16, weight: .semibold))
                        HStack(spacing: 0) {
                            ForEach(0..<5, id: \.self) { index in
                                Image(systemName: "star.fill")
                                    .font(.system(size: 12, weight: .light))
                            }
                        }
                    }
                    .foregroundColor(.gray)
                    .frame(width: 80)
                    .padding(.horizontal, 10)
                    
                    Divider().padding(.vertical, 10)
                    
                    VStack(spacing: 5) {
                        Text("연령")
                            .font(.system(size: 12, weight: .light))
                            .foregroundColor(.gray.opacity(0.8))
                        
                        Text(viewModel.iTunes.trackContentRating)
                            .font(.system(size: 16, weight: .semibold))
                        
                        Text("세")
                            .font(.system(size: 12, weight: .light))
                    }
                    .foregroundColor(.gray)
                    .frame(width: 80)
                    .padding(.horizontal, 10)
                    
                    Divider().padding(.vertical, 10)
                    
                    VStack(spacing: 5) {
                        Text("차트")
                            .font(.system(size: 12, weight: .light))
                            .foregroundColor(.gray.opacity(0.8))
                        
                        Text("#\(viewModel.iTunes.userRatingCountForCurrentVersion)")
                            .font(.system(size: 16, weight: .semibold))
                        
                        Text("소셜 네트워킹")
                            .font(.system(size: 12, weight: .light))
                    }
                    .foregroundColor(.gray)
                    .frame(width: 80)
                    .padding(.horizontal, 10)
                    
                    Divider().padding(.vertical, 10)
                    
                    VStack(spacing: 5) {
                        Text("개발자")
                            .font(.system(size: 12, weight: .light))
                            .foregroundColor(.gray.opacity(0.8))
                        
                        Image(systemName: "person.crop.square")
                            .font(.system(size: 16, weight: .semibold))
                        
                        Text(viewModel.iTunes.artistName)
                            .font(.system(size: 12, weight: .light))
                    }
                    .foregroundColor(.gray)
                    .frame(width: 80)
                    .padding(.horizontal, 10)
                    
                    Divider().padding(.vertical, 10)
                    
                    VStack(spacing: 5) {
                        Text("언어")
                            .font(.system(size: 12, weight: .light))
                            .foregroundColor(.gray.opacity(0.8))
                        
                        if let index = viewModel.iTunes.languageCodesISO2A.firstIndex(of: "aO") {
                            Text("\(viewModel.iTunes.languageCodesISO2A[index])")
                                .font(.system(size: 16, weight: .semibold))
                        } else {
                            Text("\(viewModel.iTunes.languageCodesISO2A[0])")
                                .font(.system(size: 16, weight: .semibold))
                        }
                    
                        Text("+ \(viewModel.iTunes.languageCodesISO2A.count - 1)개 언어")
                            .font(.system(size: 12, weight: .light))
                    }
                    .foregroundColor(.gray)
                    .frame(width: 80)
                    .padding(.horizontal, 10)
                }
            }
            
            Divider()
        }
        .frame(height: 100)
    }
    
    // MARK: Version View
    @ViewBuilder
    func versionView(_ viewModel : APIManager) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("새로운 기능")
                        .font(.system(size: 22, weight: .semibold))
                    Text("버전 \(viewModel.iTunes.version)")
                        .font(.system(size: 16, weight: .light))
                        .foregroundColor(.gray)
                        .padding(.top, 8)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 0) {
                    NavigationLink {
                        Text("버전 기록")
                    } label: {
                        Text("버전 기록")
                    }
                    
                    Text("x 주전")
                        .font(.system(size: 16, weight: .light))
                        .foregroundColor(.gray)
                        .padding(.top, 8)
                }
                
            }
            .padding()
            
            VStack {
                if showNewMore {
                    Text(viewModel.iTunes.releaseNotes)
                        .font(.system(size: 16, weight: .light))
                } else {
                    Text(viewModel.iTunes.releaseNotes)
                        .font(.system(size: 16, weight: .light))
                        .lineLimit(4)
                }
            }
            .overlay(content: {
                VStack(alignment: .trailing) {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            withAnimation {
                                showNewMore.toggle()
                            }
                        } label: {
                            Text("더보기")
                                .font(.system(size: 14, weight: .light))
                                .frame(width: 50)
                                .background(content: {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(.white)
                                })
                                .offset(x: 20)
                        }
                    }
                }
                .opacity(showNewMore ? 0 : 1)
            })
            .padding()
        }
        
        
        Divider()
    }
    
    // MARK: Screenshot View
    @ViewBuilder
    func screenshotView(_ viewModel: APIManager) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Button {
                    withAnimation {
                        if previewCount < viewModel.iTunes.screenshotUrls.count {
                            previewCount += 1
                        }
                    }
                } label: {
                    Text("미리보기")
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundColor(.black)
                        .padding()
                }
                Spacer()
            }
            
            ScrollViewReader { scrollProxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(0..<previewCount, id: \.self) { index in
                            WebImage(url: URL(string: viewModel.iTunes.screenshotUrls[index]))
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .padding(.leading, 10)
                                .id(index)
                            
                        }
                    }
                    .padding(.horizontal, 10)
                    .onChange(of: previewCount) { newValue in
                        withAnimation {
                            scrollProxy.scrollTo(previewCount - 1)
                        }
                    }
                }
            }
            
            HStack {
                Image(systemName: "iphone.gen2")
                Text("iPhone")
            }
            .padding()
            Spacer()
        }
    }
    
    // MARK: Description View
    @ViewBuilder
    func descriptionView(_ viewModel: APIManager) -> some View {
        VStack(alignment: .leading) {
            HStack {
                if showDecriptionMore {
                    Text(viewModel.iTunes.description)
                        .font(.system(size: 16, weight: .light))
                        
                } else {
                    let text = viewModel.iTunes.description.replacingOccurrences(of: "\n\n", with: "\n")
                    Text(text)
                        .font(.system(size: 16, weight: .light))
                        .lineLimit(3)
                }
                Spacer()
            }
            .padding()
        }
        .overlay(content: {
            VStack(alignment: .trailing) {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        withAnimation {
                            showDecriptionMore.toggle()
                        }
                    } label: {
                        Text("더보기")
                            .font(.system(size: 14, weight: .light))
                            .frame(width: 50)
                            .background(content: {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(.white)
                            })
                    }
                }
                .padding(.trailing)
                
            }
            .opacity(showDecriptionMore ? 0 : 1)
        })
    }
    
    // MARK: Developer View
    @ViewBuilder
    func developerView(_ viewModel: APIManager) -> some View {
        NavigationLink {
            Text("개발자")
        } label: {
            HStack {
                VStack(alignment: .leading) {
                    Text(viewModel.iTunes.sellerName)
                    Text("개발자")
                        .font(.system(size: 16, weight: .light))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
        }
        .padding(20)
    }
    
    // MARK: Star View
    @ViewBuilder
    func starView(count : Int) -> some View {
        HStack(spacing: 0) {
            ForEach(0..<count, id: \.self) { index in
                Image(systemName: "star.fill")
                    .font(.system(size: 8, weight: .light))
                    .foregroundColor(.gray)
            }
            
            ProgressView(value: Double.random(in: 0...1))
                .frame(width: 200)
                .padding(.leading, 12)
                .accentColor(.gray)
        }
    }
    
    // MARK: Evaluation Review View
    @ViewBuilder
    func evaluationReviewView(_ viewModel: APIManager) -> some View {
        VStack {
            Divider()
            HStack {
                VStack(spacing: 0){
                    Text("평가 및 리뷰")
                        .font(.system(size: 24, weight: .heavy))
                    Text(viewModel.iTunes.getRating())
                        .font(.system(size: 60, weight: .heavy, design: .rounded))
                    Text("(최고 5점)")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.gray)
                }
                VStack(alignment: .trailing, spacing: 0) {
                    starView(count: 5)
                    starView(count: 4)
                    starView(count: 3)
                    starView(count: 2)
                    starView(count: 1)
                    Text("\(viewModel.iTunes.userRatingCount)개의 평가")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.gray)
                        .padding(.top, 10)
                }
            }
            Divider()
        }
    }
    
    // MARK: Tap Evaluation View
    @ViewBuilder
    func tapEvaluationView(_ viewModel: APIManager) -> some View {
        HStack {
            Text("탭하여 평가하기:")
                .font(.system(size: 18, weight: .light))
            Spacer()
            
            HStack {
                ForEach(0..<5, id: \.self) { index in
                    Button {
                        print("star\(index)")
                        withAnimation {
                            starCount = index
                            popupOpacity = 1
                        }
                    } label: {
                        Image(systemName: starCount < index ? "star" : "star.fill")
                            .font(.system(size: 24, weight: .light))
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        .padding()
    }
    
    // MARK: review List View
    @ViewBuilder
    func reviewListView(_ viewModel: APIManager) -> some View {
        VStack {
            
            SnapCarousel(index: $reviewCurrentIndex, items: viewModel.reviews) { review in
                GeometryReader{ proxy in
                    let size = proxy.size
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(review.title)
                                    .font(.system(size: 14, weight: .bold))
                                HStack(spacing: 0) {
                                    ForEach(0..<5, id: \.self) { index in
                                        Image(systemName: index < review.rating ? "star.fill" : "star")
                                            .font(.system(size: 12, weight: .light))
                                            .foregroundColor(.orange)
                                    }
                                }
                            }
                            .padding()
                            Spacer()
                            
                            VStack(alignment: .trailing) {
                                Text("1년전")
                                    .font(.system(size: 12, weight: .light))
                                    .foregroundColor(.gray)
                                Text(review.nickname)
                                    .font(.system(size: 12, weight: .light))
                                    .foregroundColor(.gray)
                            }
                            .padding(.trailing)
                            .foregroundColor(.gray)
                        }
                        
                        Text(review.review)
                            .font(.system(size: 12, weight: .light))
                            .padding(.horizontal)
                            .lineLimit(3)
                        
                        HStack{
                            Text("개발자 답변")
                                .font(.system(size: 14, weight: .bold))
                                .padding(.top, 12)
                                .padding(.bottom, 8)
                                .padding(.leading)
                            Spacer()
                            Text("1년전")
                                .font(.system(size: 12, weight: .light))
                                .foregroundColor(.gray)
                                .padding(.trailing)
                        }
                        
                        
                        Text(review.answer)
                            .font(.system(size: 12, weight: .light))
                            .padding(.horizontal)
                            .lineLimit(2)
                        Spacer()
                        
                    }
                    .frame(width: size.width, height: 200)
                    .background(content: {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.gray.opacity(0.5))
                            .frame(width: size.width)
                        
                    })
                    .overlay(content: {
                        VStack(alignment: .trailing) {
                            Spacer()
                            HStack {
                                Spacer()
                                VStack {
                                    Button {
                                        
                                    } label: {
                                        Text("더보기")
                                            .font(.system(size: 12, weight: .light))
                                            .frame(width: 50)
                                            .offset(x: 10, y: -70)
                                    }
                                    
                                    Button {
                                        
                                    } label: {
                                        Text("더보기")
                                            .font(.system(size: 12, weight: .light))
                                            .frame(width: 50)
                                            .offset(x: 10, y: -20)
                                    }
                                }
                            }
                            .padding(.trailing)
                        }
                    })
                }
            }
            .padding(.vertical, 10)
            .frame(height: 220)
            .onTapGesture {
                reviewDetail.toggle()
            }
            HStack {
                NavigationLink {
                    Text("리뷰 작성하기")
                } label: {
                    Image(systemName: "square.and.pencil")
                        .font(.system(size: 24, weight: .light))
                    Text("리뷰 작성")
                }
                
                Spacer()
                 
                Link(destination:  URL(string: 앱지원URL)!) {
                    Image(systemName: "questionmark.circle")
                        .font(.system(size: 24, weight: .light))
                    Text("앱 지원")
                }
            }
            .frame(height: 40)
            .padding(.bottom)
            .padding(.horizontal)
        }
    }
    
    // MARK: App Permissions View
    @ViewBuilder
    func appPermissionsView(_ viweModel : APIManager) -> some View {
        
        VStack(spacing: 0) {
            Divider()
            HStack {
                Text("앱이 수집하는 개인정보")
                    .font(.system(size: 22, weight: .semibold))
                Spacer()
                NavigationLink {
                    Text("세부사항 보기")
                } label: {
                    Text("세부사항 보기")
                }
            }
            .padding()
            
            Text("Bemily, Inc. 개발자가 아래 설명된 데이터 처리 방식이 앱의 개인정보 처리방침에 포함되어 있을 수 있다고 표시했습니다. 자세한 내용은 개발자의 [개인정보 처리방침](https://www.bemily.com/terms/privacy)을 참조하십시오.")
                .font(.system(size: 14, weight: .light))
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 10)
            
            VStack(spacing: 0) {
                Image(systemName: "person.circle")
                    .font(.system(size: 28, weight: .light))
                    .foregroundColor(.blue)
                
                Text("사용자에게 연결된 데이터")
                    .font(.system(size: 16, weight: .semibold))
                    .padding(.top, 8)
                
                Text("다음 데이터가 수집되어 신원에 연결될 수 있습니다.")
                    .font(.system(size: 14, weight: .light))
                    .foregroundColor(.gray)
                
                HStack {
                    Image(systemName: "info.circle.fill")
                        .font(.system(size: 14, weight: .bold))
                    Text("연락처 정보")
                }
                .padding(.top, 16)
            }
            .frame(width: UIScreen.main.bounds.width - 40)
            .padding(.vertical, 20)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.gray.opacity(0.25), radius: 16, x: 0, y: 10)
            .padding(.top, 40)
             
            VStack(spacing: 0) {
                Image(systemName: "person.2.slash")
                    .font(.system(size: 28, weight: .light))
                    .foregroundColor(.blue)
                
                Text("사용자에게 연결된 데이터")
                    .font(.system(size: 16, weight: .semibold))
                    .padding(.top, 8)
                
                Text("다음 데이터가 수집되어 신원에 연결될 수 있습니다.")
                    .font(.system(size: 14, weight: .light))
                    .foregroundColor(.gray)
                
                HStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "info.circle.fill")
                                .font(.system(size: 14, weight: .bold))
                            Text("연락처 정보")
                            Spacer()
                        }
                        .padding(.leading)
                        
                        HStack {
                            Image(systemName: "photo")
                                .font(.system(size: 14, weight: .bold))
                            Text("사용자 콘텐츠")
                            Spacer()
                        }
                        .padding(.leading)
                        .padding(.top, 4)
                        
                        HStack {
                            Image(systemName: "gearshape.fill")
                                .font(.system(size: 14, weight: .bold))
                            Text("진단")
                            Spacer()
                        }
                        .padding(.leading)
                        .padding(.top, 4)
                        
                        Spacer()
                    }
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "person.circle")
                                .font(.system(size: 14, weight: .bold))
                            Text("연락처")
                            Spacer()
                        }
                        
                        HStack {
                            Image(systemName: "person.text.rectangle.fill")
                                .font(.system(size: 14, weight: .bold))
                            Text("식별자")
                            Spacer()
                        }
                        .padding(.top, 4)
                        Spacer()
                    }
                }
                .padding(.top, 16)
            }
            .frame(width: UIScreen.main.bounds.width - 40)
            .padding(.vertical, 20)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.gray.opacity(0.25), radius: 16, x: 0, y: 10)
            .padding(.top, 40)
            
            HStack {
                Text("개인정보 처리방침은 사용하는 기능이나 사용자의 나이 등에 따라 달라 질 수 있습니다.[더 알아보기](https://www.bemily.com/terms/privacy)")
                    .font(.system(size: 14, weight: .light))
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 10)
            }
            .padding(.vertical, 40)
            .padding(.horizontal, 10)
        }
    }
    
    // MARK: App Info View
    @ViewBuilder
    func appInfoView(_ viweModel : APIManager) -> some View {
        VStack(alignment: .leading) {
            Group {
                Divider()
                Text("정보")
                    .font(.system(size: 22, weight: .semibold))
                HStack {
                    Text("제공자")
                        .font(.system(size: 16, weight: .light))
                        .foregroundColor(.gray)
                    Spacer()
                    Text(viewModel.iTunes.sellerName)
                        .font(.system(size: 16, weight: .light))
                        .foregroundColor(.black)
                }
                .frame(height: 36)
                
                Divider()
                
                HStack {
                    Text("크기")
                        .font(.system(size: 16, weight: .light))
                        .foregroundColor(.gray)
                    Spacer()
                    Text("\(169)MB")
                        .font(.system(size: 16, weight: .light))
                        .foregroundColor(.black)
                }
                .frame(height: 36)
                
                Divider()
                
                HStack {
                    Text("카테고리")
                        .font(.system(size: 16, weight: .light))
                        .foregroundColor(.gray)
                    Spacer()
                    if viewModel.iTunes.genres.count != 0 {
                        Text(viewModel.iTunes.genres[0])
                            .font(.system(size: 16, weight: .light))
                            .foregroundColor(.black)
                    }
                }
                .frame(height: 36)
                
                Divider()
                
                if showCompatibility {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text("호환성")
                                .font(.system(size: 16, weight: .light))
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        
                        Text("iPhone")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.black)
                            .padding(.top, 2)
                        Text("iOS \(viewModel.iTunes.minimumOsVersion) 이상 필요.")
                            .font(.system(size: 16, weight: .light))
                            .foregroundColor(.black)
                        
                        Text("iPod touch")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.black)
                            .padding(.top, 10)
                        Text("iOS \(viewModel.iTunes.minimumOsVersion) 이상 필요.")
                            .font(.system(size: 16, weight: .light))
                            .foregroundColor(.black)
                    }
                } else {
                    Button {
                        withAnimation {
                            showCompatibility.toggle()
                        }
                    } label: {
                        HStack {
                            Text("호환성")
                                .font(.system(size: 16, weight: .light))
                                .foregroundColor(.gray)
                            Spacer()
                            Text("이 iPhone에서 작동")
                                .font(.system(size: 16, weight: .light))
                                .foregroundColor(.black)
                            Image(systemName: "chevron.down")
                                .font(.system(size: 20, weight: .light))
                                .foregroundColor(.gray)
                        }
                        .frame(height: 36)
                    }
                }
                
                Divider()
            }
            
            Group {
                HStack {
                    Text("언어")
                        .font(.system(size: 16, weight: .light))
                        .foregroundColor(.gray)
                    Spacer()
                    Text("\(169)MB")
                        .font(.system(size: 16, weight: .light))
                        .foregroundColor(.black)
                }
                .frame(height: 36)
                
                Divider()
                
                if showAdvisoryRating {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text("연령 등급")
                                .font(.system(size: 16, weight: .light))
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        
                        Text("\(viewModel.iTunes.contentAdvisoryRating)")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.black)
                            .padding(.top, 2)
                        
                        Button {
                            showSheetAdvisoryRating.toggle()
                        } label: {
                            Text("더 알아보기")
                                .font(.system(size: 16, weight: .light))
                                .padding(.top, 4)
                        }

                    }
                } else {
                    Button {
                        withAnimation {
                            showAdvisoryRating.toggle()
                        }
                    } label: {
                        HStack {
                            Text("연령 등급")
                                .font(.system(size: 16, weight: .light))
                                .foregroundColor(.gray)
                            Spacer()
                            Text("\(viewModel.iTunes.contentAdvisoryRating)")
                                .font(.system(size: 16, weight: .light))
                                .foregroundColor(.black)
                            Image(systemName: "chevron.down")
                                .font(.system(size: 20, weight: .light))
                                .foregroundColor(.gray)
                        }
                        .frame(height: 36)
                    }

                }
                
                
                Divider()
                
                HStack {
                    Text("저작권")
                        .font(.system(size: 16, weight: .light))
                        .foregroundColor(.gray)
                    Spacer()
                    Text("ⓒ 2020 \(viewModel.iTunes.sellerName)")
                        .font(.system(size: 16, weight: .light))
                        .foregroundColor(.black)
                }
                .frame(height: 36)
                
                Button {
                    openURL(URL(string: "https://www.bemily.com/terms/privacy")!)
                } label: {
                    HStack {
                        Text("개인정보 처리방침")
                            .font(.system(size: 16, weight: .light))
                        Spacer()
                        Image(systemName: "hand.raised.fill")
                            .font(.system(size: 16, weight: .light))
                    }
                    .frame(height: 36)
                    .foregroundColor(.blue)
                }
 
                Divider()
                
                Button {
                    openURL(URL(string: "https://idmsa.apple.com/IDMSWebAuth/signin?appIdKey=20379f32034f8867d352666ff2904d2152d5ff6843ee2db5ab5df863c14b1aef&path=%2F__logged_in%2Freportaproblem.apple.com%2Fstore%2F1502953604%3Fs%3D9&authResult=FAILED")!)
                } label: {
                    HStack {
                        Text("문제 리포트")
                            .font(.system(size: 16, weight: .light))
                        Spacer()
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 16, weight: .light))
                    }
                    .frame(height: 36)
                    .foregroundColor(.blue)
                }
            }
        }
        .padding()
    } 
}

struct BemilyDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

