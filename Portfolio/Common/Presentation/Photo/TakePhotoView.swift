//
//  TakePhotoView.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 1/12/24.
//


import SwiftUI

struct TakePhotoView: View {
    @StateObject var cameraViewModel = CameraViewModel()
    var dismiss: ((_ capturedPhoto: UIImage?)->Void)?
    var aspecRation: CGFloat = (231 / 169)

    var body: some View {
        ZStack {
            if !cameraViewModel.isTaken {
                cameraDisplayView
            } else if let photo = cameraViewModel.photo {
                takenPhotoView(photo: photo)
                    .presentationCornerRadius(12)
            }
        }
        .padding(.top, 16)
        .background(cameraViewModel.isTaken ? Color.white : Color.black)
        .onDisappear {
            cameraViewModel.stopSession()
        }
    }

    var cameraDisplayView: some View {
        GeometryReader { geometry in
            let aspectWidth = geometry.size.width
            let aspectHeight = aspectWidth * aspecRation

            VStack(spacing: 0) {
                ZStack {
                    if cameraViewModel.isCameraAuthorized {
                        CameraPreview(cameraViewModel: cameraViewModel)
                            .frame(width: aspectWidth, height: aspectHeight)
                            .clipped()
                    } else {
                        Text(String.localized(.cameraAccessIsRequired))
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                }
                .frame(width: aspectWidth, height: aspectHeight)

                Spacer()
                if !cameraViewModel.isTaken {
                    ZStack {
                        HStack {
                            Button {
                                dismiss?(nil)
                            } label: {
                                Text(String.localized(.cancel))
                                    .font(Font.molarumMedium18)
                                    .foregroundStyle(Color.white)
                            }
                            .padding(.leading, 32)
                            Spacer()
                            switchCameraButton
                                .padding(.trailing, 32)
                        }
                        capturePhotoButton
                    }
                }
                Spacer()
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .onAppear {
                cameraViewModel.checkCameraAuthorization()
            }
            .onDisappear {
                cameraViewModel.stopSession()
            }
        }
    }

    var switchCameraButton: some View {
        Button(action: {
            cameraViewModel.switchCamera()
        }) {
            Image("switchCameraIcon")
                .renderingMode(.template)
                .scaledToFit()
                .foregroundColor(.white)
        }
    }

    var capturePhotoButton: some View {
        HStack {
            Spacer()
            Button(action: {
                if cameraViewModel.isCameraAuthorized {
                    cameraViewModel.takePhoto()
                }
            }) {
                ZStack {
                    Circle()
                        .stroke(Color.white, lineWidth: 5)
                        .frame(width: 70, height: 70)

                    Circle()
                        .fill(Color.white)
                        .frame(width: 58, height: 58)
                }
            }
            .padding(.bottom, 20)
            Spacer()
        }
    }

    func takenPhotoView(photo: UIImage) -> some View {
        VStack {
            Image(uiImage: photo)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
                .frame(height: 483)
                .background(Color.blackPortfolio)
                .roundedRectangle(cornerRadius: 12)

            Text(String.localized(.didYouLikeIt))
                .foregroundStyle(Color.blackPortfolio)
                .font(.newBlackTypefaceExtraBold24)
                .padding(.top, 40)

            Button(action: {
                dismiss?(cameraViewModel.photo)
            }) {
                Text(String.localized(.save))
                    .font(Font.molarumMedium16)
                    .foregroundColor(.blackPortfolio)
                    .padding()
            }
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(Color.yellowPortfolio)
            .cornerRadius(10)

            Button(action: {
                cameraViewModel.isTaken = false
                cameraViewModel.photo = nil
                cameraViewModel.startSession()
            }) {
                Text(String.localized(.retake))
                    .underline()
                    .font(Font.molarumMedium16)
                    .foregroundColor(.blackPortfolio)
                    .padding(.top, 16)
            }
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    NavigationStack {
        TakePhotoView()
    }
}
