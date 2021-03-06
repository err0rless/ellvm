; RUN: not llc -march=amdgcn -verify-machineinstrs < %s 2>&1 | FileCheck -check-prefix=ERROR %s

declare i32 @memcmp(i8 addrspace(1)* readonly nocapture, i8 addrspace(1)* readonly nocapture, i64) #0
declare i8 addrspace(1)* @memchr(i8 addrspace(1)* readonly nocapture, i32, i64) #1
declare i8* @strcpy(i8* nocapture, i8* readonly nocapture) #0
declare i32 @strlen(i8* nocapture) #1
declare i32 @strnlen(i8* nocapture, i32) #1
declare i32 @strcmp(i8* nocapture, i8* nocapture) #1


; ERROR: error: <unknown>:0:0: in function test_memcmp void (i8 addrspace(1)*, i8 addrspace(1)*, i32*): unsupported call to function memcmp
define void @test_memcmp(i8 addrspace(1)* %x, i8 addrspace(1)* %y, i32* nocapture %p) #0 {
entry:
  %cmp = tail call i32 @memcmp(i8 addrspace(1)* %x, i8 addrspace(1)* %y, i64 2)
  store volatile i32 %cmp, i32 addrspace(1)* undef
  ret void
}

; ERROR: error: <unknown>:0:0: in function test_memchr void (i8 addrspace(1)*, i32, i64): unsupported call to function memchr
define void @test_memchr(i8 addrspace(1)* %src, i32 %char, i64 %len) #0 {
  %res = call i8 addrspace(1)* @memchr(i8 addrspace(1)* %src, i32 %char, i64 %len)
  store volatile i8 addrspace(1)* %res, i8 addrspace(1)* addrspace(1)* undef
  ret void
}

; ERROR: error: <unknown>:0:0: in function test_strcpy void (i8*, i8*): unsupported call to function strcpy
define void @test_strcpy(i8* %dst, i8* %src) #0 {
  %res = call i8* @strcpy(i8* %dst, i8* %src)
  store volatile i8* %res, i8* addrspace(1)* undef
  ret void
}

; ERROR: error: <unknown>:0:0: in function test_strcmp void (i8*, i8*): unsupported call to function strcmp
define void @test_strcmp(i8* %src0, i8* %src1) #0 {
  %res = call i32 @strcmp(i8* %src0, i8* %src1)
  store volatile i32 %res, i32 addrspace(1)* undef
  ret void
}

; ERROR: error: <unknown>:0:0: in function test_strlen void (i8*): unsupported call to function strlen
define void @test_strlen(i8* %src) #0 {
  %res = call i32 @strlen(i8* %src)
  store volatile i32 %res, i32 addrspace(1)* undef
  ret void
}

; ERROR: error: <unknown>:0:0: in function test_strnlen void (i8*, i32): unsupported call to function strnlen
define void @test_strnlen(i8* %src, i32 %size) #0 {
  %res = call i32 @strnlen(i8* %src, i32 %size)
  store volatile i32 %res, i32 addrspace(1)* undef
  ret void
}

attributes #0 = { nounwind }
