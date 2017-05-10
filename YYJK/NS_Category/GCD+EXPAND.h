//
//  GCD+EXPAND.h
//  GCDTest
//
//  Created by zwc on 14-3-18.
//  Copyright (c) 2014年 7tea. All rights reserved.
//


void run_async_and_complete(dispatch_block_t block, dispatch_block_t complete);

void run_async_global(dispatch_block_t block);

void run_async_main(dispatch_block_t block);
