//
//  OverlayManager.h
//  FastPdfKit
//
//  Created by Matteo Gavagnin on 8/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FastPdfKit/MFDocumentOverlayDataSource.h>
#import "MFDocumentManager.h"
//@class MFDocumentManager;

@interface OverlayManager : NSObject <MFDocumentOverlayDataSource>

@property (nonatomic,retain) MFDocumentManager *documentManager;
@property (nonatomic,retain) NSString *searchKeyword;
@property (nonatomic,retain) NSMutableArray *glyphBoxes;
@property (nonatomic,retain) NSMutableArray *selectedArea;
@end
