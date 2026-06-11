const std = @import("std");
const file = @import("file.zig");

pub fn diff(
    allocator: std.mem.Allocator,
    base: []const u8,
    live: []const u8,
) !void {
    _ = allocator;
    _ = base;
    _ = live;

    // ADR-0011 implementation goes here:
    // - recursive compare
    // - SHA256 comparison
    // - classification of changes
}
