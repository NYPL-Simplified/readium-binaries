//
//  CPUCacheUtils.h
//  ePub3
//
//  Created by Jim Dovey on 2013-08-26.
//  Copyright (c) 2014 Readium Foundation and/or its licensees. All rights reserved.
//  
//  Redistribution and use in source and binary forms, with or without modification, 
//  are permitted provided that the following conditions are met:
//  1. Redistributions of source code must retain the above copyright notice, this 
//  list of conditions and the following disclaimer.
//  2. Redistributions in binary form must reproduce the above copyright notice, 
//  this list of conditions and the following disclaimer in the documentation and/or 
//  other materials provided with the distribution.
//  3. Neither the name of the organization nor the names of its contributors may be 
//  used to endorse or promote products derived from this software without specific 
//  prior written permission.
//  
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
//  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
//  IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
//  INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, 
//  BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
//  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF 
//  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE 
//  OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED 
//  OF THE POSSIBILITY OF SUCH DAMAGE.

// based on OS X <libkern/OSCacheControl.h>

#ifndef ePub3_CPUCacheUtils_h
#define ePub3_CPUCacheUtils_h

#ifdef ENABLE_SYS_CACHE_FLUSH

#include <ePub3/base.h>

// operation codes for epub_sys_cache_control()
enum
{
    kSyncCaches     = 1,        // sync RAM changes into CPU caches
    kFlushCaches    = 2,        // push CPU caches out to memory & invalidate them
};

__BEGIN_DECLS

int epub_sys_cache_control(int operation, void* start, long len);

// equivalent to epub_sys_cache_control(kSyncCaches, ...)
void epub_sys_cache_invalidate(void* start, long len);

// equivalent to epub_sys_cache_control(kFlushCaches, ...)
void epub_sys_cache_flush(void* start, long len);

__END_DECLS

#endif //ENABLE_SYS_CACHE_FLUSH

#endif