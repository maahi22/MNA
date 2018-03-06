//
//  OverlayManager.m
//  FPKSimpleApp
//
//  Created by Maahi on 06/03/18.
//

#import "OverlayManager.h"
#import <FastPdfKit/FPKGlyphBox.h>
#import "MFDocumentManager.h"
//#import "Drawable.h"
@implementation OverlayManager
@synthesize searchKeyword;
@synthesize documentManager;
@synthesize glyphBoxes;
@synthesize selectedArea;

-(NSArray *)documentViewController:(MFDocumentViewController *)dvc drawablesForPage:(NSUInteger)page {
    
    if (self.searchKeyword!=nil) {
        NSArray *fsgsg=[documentManager glyphBoxesForPage:page];
        return [self.documentManager searchResultOnPage:page forSearchTerms:self.searchKeyword ignoreCase:YES];
    }else{
        NSMutableArray *drawables = [[NSMutableArray alloc]init];
        for (NSValue * tmpValue in self.selectedArea) {
            UIView * selectedView = [[UIView alloc] initWithFrame:[tmpValue CGRectValue]];
            [drawables addObject:selectedView];
        }
        return drawables;
        
    }
    return nil;
}



//////


- (void) startSelectedArea:(NSInteger)page {
    self.glyphBoxes = [self.documentManager glyphBoxesForPage:page];
}


- (BOOL) calculateSelectedArea:(CGPoint) point page:(NSInteger)page {
    CGRect tmpRect = CGRectZero;
    for (FPKGlyphBox *glyphBox in self.glyphBoxes) {
        CGRect glyphBoxRect = glyphBox.box;
        if (CGRectContainsPoint(glyphBoxRect, point)) {
            tmpRect = glyphBoxRect;
        }
    }
    if (!CGRectIsEmpty(tmpRect)) {
        CGFloat valueOriginY = tmpRect.origin.y;
        
        for (FPKGlyphBox * glyphBox in self.glyphBoxes) {
            CGRect glyphBoxRect = glyphBox.box;
            CGFloat originY = glyphBoxRect.origin.y;
            if (valueOriginY == originY) {
                tmpRect = CGRectUnion(glyphBoxRect, tmpRect);
            }
        }
        
    }
    
    
    if (!CGRectIsEmpty(tmpRect)) {
        BOOL setted = NO;
        for (NSUInteger cpt = 0; cpt < [self.selectedArea count]; cpt++) {
            NSValue * tmpValue = [self.selectedArea objectAtIndex:cpt];
            CGRect rectValue = [tmpValue CGRectValue];
            CGFloat valueOriginY = rectValue.origin.y;
            CGFloat originY = tmpRect.origin.y;
            if (valueOriginY == originY) {
                setted = YES;
            }
        }
        if (!setted) {
            [self.selectedArea addObject:[NSValue valueWithCGRect:tmpRect]];
        }
    }
    
    return YES;
}


@end
