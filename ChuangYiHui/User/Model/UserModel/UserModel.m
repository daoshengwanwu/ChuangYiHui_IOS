//
//  UserModel.m
//  GoldUnion
//
//  Created by GYY on 18/04/2016.
//  Copyright © 2016 LEE . All rights reserved.
//

#import "UserModel.h"

@implementation UserModel


+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"user_id":@"id", @"user_description":@"description"};
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _token = [aDecoder decodeObjectForKey:@"token"];
        _user_id = [aDecoder decodeObjectForKey:@"user_id"];
        _name = [aDecoder decodeObjectForKey:@"name"];
        _icon_url = [aDecoder decodeObjectForKey:@"icon_url"];
        _tags = [aDecoder decodeObjectForKey:@"tags"];
        _gender = [aDecoder decodeObjectForKey:@"gender"];
        _liker_count =[aDecoder decodeObjectForKey:@"liker_count"];
        _follower_count = [aDecoder decodeObjectForKey:@"follower_count"];
        _followed_count = [aDecoder decodeObjectForKey:@"followed_count"];
        _friend_count = [aDecoder decodeObjectForKey:@"friend_count"];
        _visitor_count = [aDecoder decodeObjectForKey:@"visitor_count"];
        _is_verified = [aDecoder decodeObjectForKey:@"is_verified"];
        _is_role_verified = [aDecoder decodeObjectForKey:@"is_role_verified"];
        _score = [aDecoder decodeObjectForKey:@"score"];
        _invitation_code = [aDecoder decodeObjectForKey:@"invitation_code"];
        _email = [aDecoder decodeObjectForKey:@"email"];
        _unit1 = [aDecoder decodeObjectForKey:@"unit1"];
        _unit2 = [aDecoder decodeObjectForKey:@"unit2"];
        _time_created = [aDecoder decodeObjectForKey:@"time_created"];
        _user_description = [aDecoder decodeObjectForKey:@"description"];
        _qq = [aDecoder decodeObjectForKey:@"qq"];
        _profession = [aDecoder decodeObjectForKey:@"profession"];
        _role = [aDecoder decodeObjectForKey:@"role"];

    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_token forKey:@"token"];
    [aCoder encodeObject:_user_id forKey:@"user_id"];
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_icon_url forKey:@"icon_url"];
    [aCoder encodeObject:_tags forKey:@"tags"];
    [aCoder encodeObject:_gender forKey:@"gender"];
    [aCoder encodeObject:_liker_count forKey:@"liker_count"];
    [aCoder encodeObject:_follower_count forKey:@"follower_count"];
    [aCoder encodeObject:_followed_count forKey:@"followed_count"];
    [aCoder encodeObject:_friend_count forKey:@"friend_count"];
    [aCoder encodeObject:_visitor_count forKey:@"visitor_count"];
    [aCoder encodeObject:_is_verified forKey:@"is_verified"];
    [aCoder encodeObject:_is_role_verified forKey:@"is_role_verified"];
    [aCoder encodeObject:_invitation_code forKey:@"invitation_code"];
    [aCoder encodeObject:_email forKey:@"email"];
    [aCoder encodeObject:_unit1 forKey:@"unit1"];
    [aCoder encodeObject:_unit2 forKey:@"unit2"];
    [aCoder encodeObject:_time_created forKey:@"time_created"];
    [aCoder encodeObject:_user_description forKey:@"description"];
    [aCoder encodeObject:_qq forKey:@"qq"];
    [aCoder encodeObject:_profession forKey:@"profession"];
    [aCoder encodeObject:_role forKey:@"role"];

}

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if (oldValue == [NSNull null]) {
        return @"";
    }
    
    if ([property.name isEqualToString:@"time_created"]) {
        NSRange range = NSMakeRange(0, 10);
        return [oldValue substringWithRange:range];
    }

    return oldValue;
}


@end
