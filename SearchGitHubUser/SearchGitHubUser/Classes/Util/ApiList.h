//
//  ApiList.h
//  Super
//
//  Created by lx on 15/5/29.


#ifndef Super_ApiList_h
#define Super_ApiList_h

#define DEF_NETPATH_BASEURL @"https://api.github.com"
#define DEF_CLIENT_ID @"ace712dd4bafa1b6bdd0"
#define DEF_CLIENT_Secret @"87b48e1293beca7cda274586be6dd4eeb51b034f"


//查询用户
#define api_query_user(username)  [NSString stringWithFormat:@"search/users?q=%@",username]

//查询用户resp
#define api_query_user_repos(username)  [NSString stringWithFormat:@"users/%@/repos?client_id=%@&client_secret=%@",username,DEF_CLIENT_ID,DEF_CLIENT_Secret]

#endif
