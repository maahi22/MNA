//
//  OverlayManager.h
//  FPKSimpleApp
//
//  Created by Maahi on 06/03/18.
//

#import <Foundation/Foundation.h>
#import <FastPdfKit/MFDocumentOverlayDataSource.h>
@class MFDocumentManager;


@interface OverlayManager : NSObject<MFDocumentOverlayDataSource>

@property (nonatomic,retain) MFDocumentManager *documentManager;
@property (nonatomic,retain) NSString *searchKeyword;
@property (nonatomic,retain) NSMutableArray *glyphBoxes;
@property (nonatomic,retain) NSMutableArray *selectedArea;

@end
