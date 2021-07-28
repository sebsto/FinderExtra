//
//  Analytics.swift
//  FinderExtra
//
//  Created by Stormacq, Sebastien on 13/09/2020.
//  Copyright © 2020 Stormacq, Sebastien. All rights reserved.
//

import Foundation


import SotoCore
import SotoCognitoIdentity
import SotoS3

struct AnalyticsManager {
    
    // strong ref to the AWSHttpClient
    private let awsClient : AWSClient
    
    init() {
//        let cpf = CredentialProviderFactory.cognitoIdentity(identityPoolId: "eu-central-1:533d8173-6816-495c-9aad-aa8506bea293", logins: nil, region: Region.eucentral1)
        
        self.awsClient = AWSClient(credentialProvider: .configFile(credentialsFilePath: "~/Downloads/credentials", profile: "default"), middlewares: [AWSLoggingMiddleware()], httpClientProvider: .createNew)
        
//        self.awsClient = AWSClient(credentialProvider: cpf, middlewares: [], httpClientProvider: .createNew)
//        self.awsClient = AWSClient(credentialProvider: cpf, middlewares: [AWSLoggingMiddleware()], httpClientProvider: .createNew)
        
    }
    
    func testS3() {
        print("reading s3")
        let s3 = S3(client: awsClient)
        let _ = s3.listBuckets()
            .map { response in
                for b in response.buckets! {
                    print("\(b)")
                }
        }
        //        do {
        //            try response.wait()
        //        } catch (let e) {
        //            print(e)
        //        }
    }
}
