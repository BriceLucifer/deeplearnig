const std = @import("std");
const Allocator = std.mem.Allocator;

pub fn GROW_CAPACITY(capacity: u8) i32 {
    if (capacity < 8) {
        return 8;
    } else {
        return capacity * 2;
    }
}

// pub fn GROW_ARRAY(comptime T: type, pointer: *T, oldCount: i32, newCount: i32, allocator: Allocator) void {

// }
