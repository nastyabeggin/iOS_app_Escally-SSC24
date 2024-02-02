//

import SwiftUI

struct Vector1: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0, y: 0.57 * height))
        path.addLine(to: CGPoint(x: 0.10 * width, y: 0.48 * height))
        path.addLine(to: CGPoint(x: 0.18 * width, y: 0.43 * height))
        path.addLine(to: CGPoint(x: 0.26 * width, y: 0.30 * height))
        path.addLine(to: CGPoint(x: 0.33 * width, y: 0.36 * height))
        path.addCurve(to: CGPoint(x: 0.44 * width, y: 0.26 * height), control1: CGPoint(x: 0.35 * width, y: 0.35 * height), control2: CGPoint(x: 0.40 * width, y: 0.31 * height))
        path.addCurve(to: CGPoint(x: 0.51 * width, y: 0.17 * height), control1: CGPoint(x: 0.47 * width, y: 0.20 * height), control2: CGPoint(x: 0.50 * width, y: 0.17 * height))
        path.addCurve(to: CGPoint(x: 0.54 * width, y: 0.21 * height), control1: CGPoint(x: 0.53 * width, y: 0.17 * height), control2: CGPoint(x: 0.54 * width, y: 0.20 * height))
        path.addLine(to: CGPoint(x: 0.57 * width, y: 0.14 * height))
        path.addLine(to: CGPoint(x: 0.63 * width, y: 0.14 * height))
        path.addCurve(to: CGPoint(x: 0.69 * width, y: 0.01 * height), control1: CGPoint(x: 0.65 * width, y: 0.11 * height), control2: CGPoint(x: 0.68 * width, y: 0.04 * height))
        path.addCurve(to: CGPoint(x: 0.74 * width, y: 0.06 * height), control1: CGPoint(x: 0.70 * width, y: -0.03 * height), control2: CGPoint(x: 0.73 * width, y: 0.06 * height))
        path.addCurve(to: CGPoint(x: 0.77 * width, y: 0.06 * height), control1: CGPoint(x: 0.75 * width, y: 0.06 * height), control2: CGPoint(x: 0.77 * width, y: 0.06 * height))
        path.addLine(to: CGPoint(x: 0.82 * width, y: 0.14 * height))
        path.addCurve(to: CGPoint(x: 0.86 * width, y: 0.21 * height), control1: CGPoint(x: 0.83 * width, y: 0.15 * height), control2: CGPoint(x: 0.85 * width, y: 0.18 * height))
        path.addCurve(to: CGPoint(x: 0.92 * width, y: 0.30 * height), control1: CGPoint(x: 0.88 * width, y: 0.25 * height), control2: CGPoint(x: 0.91 * width, y: 0.29 * height))
        path.addLine(to: CGPoint(x: width, y: 0.48 * height))
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.addLine(to: CGPoint(x: 0, y: 0.57 * height))
        path.closeSubpath()
        return path
    }
}


struct Vector2: Shape {
        func path(in rect: CGRect) -> Path {
                var path = Path()
                let width = rect.size.width
                let height = rect.size.height
                path.move(to: CGPoint(x: 0, y: 0.2395420533*height))
                path.addLine(to: CGPoint(x: 0.0688018968*width, y: 0.2395420533*height))
                path.addLine(to: CGPoint(x: 0.1565836693*width, y: 0.1767114786*height))
                path.addCurve(to: CGPoint(x: 0.2704626793*width, y: 0.2866649684*height), control1: CGPoint(x: 0.1917754465*width, y: 0.2159805798*height), control2: CGPoint(x: 0.2638197369*width, y: 0.2929480245*height))
                path.addCurve(to: CGPoint(x: 0.3357058911*width, y: 0.2395420533*height), control1: CGPoint(x: 0.2787663577*width, y: 0.2788111481*height), control2: CGPoint(x: 0.3274022128*width, y: 0.3023726152*height))
                path.addCurve(to: CGPoint(x: 0.3831554583*width, y: 0.1767114786*height), control1: CGPoint(x: 0.3423488336*width, y: 0.1892776043*height), control2: CGPoint(x: 0.3701068213*width, y: 0.1767114786*height))
                path.addLine(to: CGPoint(x: 0.4377225094*width, y: 0.2866649684*height))
                path.addLine(to: CGPoint(x: 0.4982207482*width, y: 0.2866649684*height))
                path.addCurve(to: CGPoint(x: 0.5207593007*width, y: 0.2395420533*height), control1: CGPoint(x: 0.499406988*width, y: 0.2709573279*height), control2: CGPoint(x: 0.5055754311*width, y: 0.2395420533*height))
                path.addCurve(to: CGPoint(x: 0.5705812326*width, y: 0.2395420533*height), control1: CGPoint(x: 0.5397391378*width, y: 0.2395420533*height), control2: CGPoint(x: 0.5563463553*width, y: 0.2395420533*height))
                path.addCurve(to: CGPoint(x: 0.5907473555*width, y: 0.1767114786*height), control1: CGPoint(x: 0.5848161099*width, y: 0.2395420533*height), control2: CGPoint(x: 0.5670225597*width, y: 0.2434689523*height))
                path.addCurve(to: CGPoint(x: 0.6595492767*width, y: 0.0549772663*height), control1: CGPoint(x: 0.6144721513*width, y: 0.1099540049*height), control2: CGPoint(x: 0.648873119*width, y: 0.0392696258*height))
                path.addCurve(to: CGPoint(x: 0.729537429*width, y: 0), control1: CGPoint(x: 0.6702254344*width, y: 0.0706849068*height), control2: CGPoint(x: 0.7141163115*width, y: 0))
                path.addCurve(to: CGPoint(x: 0.8695136685*width, y: 0.1767114786*height), control1: CGPoint(x: 0.7449585465*width, y: 0), control2: CGPoint(x: 0.8102016811*width, y: 0.1767114786*height))
                path.addCurve(to: CGPoint(x: 1.0000000596*width, y: 0.3534219143*height), control1: CGPoint(x: 0.9169632601*width, y: 0.1767114786*height), control2: CGPoint(x: 0.9762752638*width, y: 0.2945184357*height))
                path.addLine(to: CGPoint(x: 1.0000000596*width, y: 1.0000000596*height))
                path.addLine(to: CGPoint(x: 0, y: 1.0000000596*height))
                path.addLine(to: CGPoint(x: 0, y: 0.2395420533*height))
                path.closeSubpath()
                return path
        }
}

struct Vector3: Shape {
        func path(in rect: CGRect) -> Path {
                var path = Path()
                let width = rect.size.width
                let height = rect.size.height
                path.move(to: CGPoint(x: 0, y: height))
                path.addLine(to: CGPoint(x: width, y: height))
                path.addLine(to: CGPoint(x: width, y: 0.6960784314*height))
                path.addLine(to: CGPoint(x: width, y: 0.2472766885*height))
                path.addLine(to: CGPoint(x: width, y: 0.0795206972*height))
                path.addLine(to: CGPoint(x: 0.9081295148*width, y: 0))
                path.addLine(to: CGPoint(x: 0.8213613692*width, y: 0.0942981529*height))
                path.addLine(to: CGPoint(x: 0.703041115*width, y: 0.310493918*height))
                path.addLine(to: CGPoint(x: 0.5650009079*width, y: 0.4990902238*height))
                path.addLine(to: CGPoint(x: 0.3869346734*width, y: 0.8071895425*height))
                path.addLine(to: CGPoint(x: 0, y: height))
                path.closeSubpath()
                return path
        }
}

struct Vector4: Shape {
        func path(in rect: CGRect) -> Path {
                var path = Path()
                let width = rect.size.width
                let height = rect.size.height
                path.move(to: CGPoint(x: 0, y: height))
                path.addLine(to: CGPoint(x: 0, y: 0.574433657*height))
                path.addLine(to: CGPoint(x: 0, y: 0.4660194175*height))
                path.addLine(to: CGPoint(x: 0.0352756989*width, y: 0.3678076537*height))
                path.addLine(to: CGPoint(x: 0.1174407568*width, y: 0.1117045455*height))
                path.addLine(to: CGPoint(x: 0.1776951325*width, y: 0))
                path.addLine(to: CGPoint(x: 0.2639684433*width, y: 0.1117045455*height))
                path.addLine(to: CGPoint(x: 0.2968344664*width, y: 0.2615521132*height))
                path.addLine(to: CGPoint(x: 0.4159738394*width, y: 0.4849612042*height))
                path.addLine(to: CGPoint(x: 0.49129177*width, y: 0.743788784*height))
                path.addLine(to: CGPoint(x: width, y: height))
                path.addLine(to: CGPoint(x: 0, y: height))
                path.closeSubpath()
                return path
        }
}

struct Vector5: Shape {
        func path(in rect: CGRect) -> Path {
                var path = Path()
                let width = rect.size.width
                let height = rect.size.height
                path.move(to: CGPoint(x: 0, y: height))
                path.addLine(to: CGPoint(x: 0.1877236597*width, y: 0.8621715134*height))
                path.addLine(to: CGPoint(x: 0.199119762*width, y: 0.8621715134*height))
                path.addLine(to: CGPoint(x: 0.313080727*width, y: 0.7088971922*height))
                path.addLine(to: CGPoint(x: 0.3202032812*width, y: 0.7141224319*height))
                path.addLine(to: CGPoint(x: 0.3387219378*width, y: 0.7141224319*height))
                path.addLine(to: CGPoint(x: 0.3515425432*width, y: 0.7245729831*height))
                path.addLine(to: CGPoint(x: 0.4768995911*width, y: 0.574782179*height))
                path.addLine(to: CGPoint(x: 0.4882956934*width, y: 0.5678151449*height))
                path.addLine(to: CGPoint(x: 0.5580968105*width, y: 0.6340017543*height))
                path.addLine(to: CGPoint(x: 0.5808889763*width, y: 0.6113589291*height))
                path.addLine(to: CGPoint(x: 0.6108037352*width, y: 0.5817491773*height))
                path.addCurve(to: CGPoint(x: 0.6620861568*width, y: 0.487694503*height), control1: CGPoint(x: 0.6255236922*width, y: 0.56317047*height), control2: CGPoint(x: 0.6592371327*width, y: 0.5033685814*height))
                path.addCurve(to: CGPoint(x: 0.6720577172*width, y: 0.4789823075*height), control1: CGPoint(x: 0.6635282364*width, y: 0.4797608142*height), control2: CGPoint(x: 0.6687420567*width, y: 0.4805829843*height))
                path.addCurve(to: CGPoint(x: 0.6891518319*width, y: 0.4598230353*height), control1: CGPoint(x: 0.679565699*width, y: 0.4753577348*height), control2: CGPoint(x: 0.6871755637*width, y: 0.4767377466*height))
                path.addCurve(to: CGPoint(x: 0.7076705661*width, y: 0.4215043834*height), control1: CGPoint(x: 0.6915260185*width, y: 0.4511142661*height), control2: CGPoint(x: 0.6985536896*width, y: 0.431258205*height))
                path.addCurve(to: CGPoint(x: 0.737585325*width, y: 0.3918945957*height), control1: CGPoint(x: 0.7167874426*width, y: 0.4117505618*height), control2: CGPoint(x: 0.7314124392*width, y: 0.3977004413*height))
                path.addLine(to: CGPoint(x: 0.7788961085*width, y: 0.323966192*height))
                path.addLine(to: CGPoint(x: 0.7788961085*width, y: 0.311773918*height))
                path.addLine(to: CGPoint(x: 0.8059618613*width, y: 0.2751970963*height))
                path.addLine(to: CGPoint(x: 0.8130844932*width, y: 0.280422354*height))
                path.addLine(to: CGPoint(x: 0.8187825055*width, y: 0.280422354*height))
                path.addLine(to: CGPoint(x: 0.8316030721*width, y: 0.2612630638*height))
                path.addLine(to: CGPoint(x: 0.8316030721*width, y: 0.252554307*height))
                path.addLine(to: CGPoint(x: 0.8686404629*width, y: 0.1741753878*height))
                path.addLine(to: CGPoint(x: 0.8814610294*width, y: 0.1741753878*height))
                path.addLine(to: CGPoint(x: 0.9128002526*width, y: 0.118439258*height))
                path.addCurve(to: CGPoint(x: 0.9199228845*width, y: 0.0905711931*height), control1: CGPoint(x: 0.9132750899*width, y: 0.1120528274*height), control2: CGPoint(x: 0.9153644462*width, y: 0.0975382082*height))
                path.addCurve(to: CGPoint(x: 0.9384414634*width, y: 0.0783789191*height), control1: CGPoint(x: 0.9244813227*width, y: 0.083604178*height), control2: CGPoint(x: 0.9341679275*width, y: 0.0795400884*height))
                path.addCurve(to: CGPoint(x: 0.9526866495*width, y: 0.0609613875*height), control1: CGPoint(x: 0.9422401621*width, y: 0.0766371654*height), control2: CGPoint(x: 0.9504074304*width, y: 0.0707152091*height))
                path.addCurve(to: CGPoint(x: 0.9598092038*width, y: 0.0348350767*height), control1: CGPoint(x: 0.9549658687*width, y: 0.0512075659*height), control2: CGPoint(x: 0.9583846918*width, y: 0.0394797535*height))
                path.addLine(to: CGPoint(x: 0.9697807642*width, y: 0.0156757843*height))
                path.addLine(to: CGPoint(x: 0.9834605598*width, y: 0.0064553991*height))
                path.addLine(to: CGPoint(x: 0.9923664122*width, y: 0.0046948357*height))
                path.addLine(to: CGPoint(x: width, y: 0))
                path.addLine(to: CGPoint(x: width, y: height))
                path.addLine(to: CGPoint(x: 0, y: height))
                path.closeSubpath()
                return path
        }
}

struct CustomBackgroundView: View {
    var body: some View {
        GeometryReader { geometry in
            HStack {
                Spacer()
                Vector5()
                    .fill(AppColors.lighterBlue)
                    .aspectRatio(399 / 852, contentMode: .fit)
                    .frame(height: geometry.size.height)
            }
            VStack {
                Spacer()
                Vector4()
                    .fill(AppColors.lightGray)
                    .opacity(0.8)
                    .aspectRatio(390 / 309, contentMode: .fit)
                    .frame(width: geometry.size.width)
            }
            VStack {
                Spacer()
                Vector3()
                    .fill(AppColors.lightGray)
                    .opacity(0.8)
                    .aspectRatio(398 / 459, contentMode: .fit)
                    .frame(width: geometry.size.width)
            }
            VStack {
                Spacer()
                Vector2()
                    .fill(AppColors.darkBlue)
                    .opacity(0.8)
                    .aspectRatio(470 / 300, contentMode: .fit)
                    .frame(width: geometry.size.width)
                    .offset(y: geometry.size.height / 20)
            }
            VStack {
                Spacer()
                Vector1()
                    .fill(.black)
                    .opacity(0.8)
                    .aspectRatio(579 / 166, contentMode: .fit)
                    .frame(width: geometry.size.width)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    CustomBackgroundView()
}
