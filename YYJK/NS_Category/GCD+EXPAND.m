//
//  GCD+EXPAND.m
//  GCDTest
//
//  Created by zwc on 14-3-18.
//  Copyright (c) 2014年 7tea. All rights reserved.
//

#import "GCD+EXPAND.h"

void run_async_and_complete(dispatch_block_t block, dispatch_block_t complete) {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{
        block();
    });
    dispatch_group_notify(group, queue, ^{
        complete();
    });
}

void run_async_global(dispatch_block_t block) {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(queue, block);
}

void run_async_main(dispatch_block_t block) {
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_async(queue, block);
}
