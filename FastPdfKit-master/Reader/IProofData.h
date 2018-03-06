//
//  IProofData.h
//  FPKSimpleApp
//
//  Created by Apple on 28/02/18.
//

#import <Foundation/Foundation.h>

@interface IProofData : NSObject{
    
    NSString *Id;
    NSString *userid;
    NSString *tagtext;
    NSString *username;
    NSString *creationdate;
    int y;
    int x;
    NSString *notes;
    NSString *drawingtype;
    
}

@property (nonatomic, retain) NSString *Id;
@property (nonatomic, retain) NSString *userId;
@property (nonatomic, retain) NSString *tagText;
@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) NSString *creationDate;
@property (nonatomic, assign) int X;
@property (nonatomic, assign) int Y;
@property (nonatomic, retain) NSString *Notes;
@property (nonatomic, retain) NSString *drawingType;

-(id)initWithId:(NSString *)tId UserId:(NSString *) tuserId TagText:(NSString *) ttagText  Username:(NSString *) tuserName CreationDate:(NSString *) tcreationDate X:(int) tx Y:(int) ty  Notes:(NSString *) tNotes DrawingType:(NSString *) tdrawingType;

@end
