const std = @import("std");

pub fn buildISO() !void {
    std.debug.print("Building ISO...\n", .{});

    // ADR-0012 pipeline:
    // 1. extract ISO
    // 2. apply diff
    // 3. apply overlay
    // 4. rebuild filesystem
    // 5. generate ISO

    // Stubs for now
}
