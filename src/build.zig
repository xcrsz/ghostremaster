const std = @import("std");
const iso = @import("iso/assemble.zig");

pub fn run(allocator: std.mem.Allocator) !void {
    _ = allocator;

    try iso.buildISO();
}
