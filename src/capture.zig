const std = @import("std");
const pkg = @import("pkg.zig");

pub fn run(allocator: std.mem.Allocator) !void {
    try std.fs.cwd().makePath("profile");

    try pkg.writePackageList(allocator, "profile/packages.txt");

    std.debug.print("Capture complete\n", .{});
}
