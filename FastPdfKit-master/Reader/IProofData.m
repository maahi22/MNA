//
//  IProofData.m
//  FPKSimpleApp
//
//  Created by Apple on 28/02/18.
//

#import "IProofData.h"

@implementation IProofData
@synthesize Id=Id;
@synthesize userId=userid;
@synthesize tagText=tagtext;
@synthesize userName=username;
@synthesize creationDate=creationdate;
@synthesize X=x;
@synthesize Y=y;
@synthesize Notes=notes;
@synthesize drawingType=drawingtype;

-(id)initWithId:(NSString *)tId UserId:(NSString *)tuserId TagText:(NSString *)ttagText Username:(NSString *)tuserName CreationDate:(NSString *)tcreationDate X:(int)tx Y:(int)ty Notes:(NSString *)tNotes DrawingType:(NSString *)tdrawingType{
    self=[super init];
    if (self!=nil) {
        self.Id=tId;
        self.userId=tuserId;
        self.tagText=ttagText;
        self.userName=tuserName;
        self.creationDate=tcreationDate;
        self.X=tx;
        self.Y=ty;
        self.Notes=tNotes;
        self.drawingType=tdrawingType;
    }
    return self;
}

-(void)dealloc{
    [self.Id release];
    [self.userId release];
    [self.tagText release];
    [self.userName release];
    [self.creationDate release];
    [self.Notes release];
    [self.drawingType release];
    [super dealloc];
}


@end
