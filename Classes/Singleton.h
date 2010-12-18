//
//  Singleton.h
//  BetterFlickr
//
//  Created by Johan Attali on 7/14/10.
//  Copyright 2010 Johan Attali. http://www.jjbrothers.net. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Singleton : NSObject 
{

}

/*!
 * @method		instance
 * @abstract	Creates a static instance of the DB accessible from everywhere in the application. 
 * @result		A static instance of the local DB class
 */
+ (id)instance;			

@end
