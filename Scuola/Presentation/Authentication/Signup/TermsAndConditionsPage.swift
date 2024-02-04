//
//  TermsAndConditionsPages.swift
//  Scuola
//
//  Created by Braden Ross on 2/3/24.
//

import SwiftUI

struct TermsAndConditionsPage: View {
    @Binding var title: String
    var body: some View {
        VStack(){
            ScrollView(){
                Text("Sample Privacy Policy\nIntroduction\nThis Privacy Policy outlines the types of personal information that [Your Company Name] (\"we,\" \"us,\" or \"our\") may collect, how we use it, and the choices you have regarding your information. Please read this policy carefully.\nInformation We Collect\nPersonal Information: We may collect personally identifiable information, such as your name, email address, and other contact details, when you voluntarily provide it to us.\nUsage Data: We may collect information about how you interact with our website or application, such as your IP address, browser type, and device information.\nHow We Use Your Information\nProviding Services: We use your information to provide and improve our services, respond to your inquiries, and personalize your experience.\nAnalytics: We may use analytics tools to analyze user behavior and improve our services.\nMarketing: With your consent, we may send you promotional materials or information about our products and services.\nSharing Your Information\nThird-Party Service Providers: We may share your information with third-party service providers who help us deliver our services.\nLegal Compliance: We may disclose your information if required by law or in response to a valid legal request.\nYour Choices\nOpt-Out: You can opt-out of receiving promotional communications from us by following the instructions provided in the communication.\nAccess and Correction: You have the right to access and correct your personal information. Contact us for assistance.\nSecurity\nWe take reasonable measures to protect your information from unauthorized access or disclosure.\nChildren's Privacy\nOur services are not intended for individuals under the age of 13. We do not knowingly collect personal information from children.\nChanges to This Policy\nWe may update this Privacy Policy periodically. Please review this policy regularly for any changes.\nContact Us\nIf you have any questions or concerns about this Privacy Policy, please contact us at [your contact email].\nDate of Last Update: [Insert Date]")
                    .multilineTextAlignment(.leading)
            }
            .frame(maxWidth: .infinity)
            
            Text("By pressing 'Finish' you accept to our terms and conditions and privacy policy.")
                .font(.footnote)
                .frame(alignment: .center)
                .multilineTextAlignment(.center)
        }
        .onAppear{
            title = "Terms and Conditions"
        }
    }
}
