const std = @import("std");

pub fn walkDir(
    dir_path: []const u8,
    callback: fn ([]const u8) void,
) !void {
    var dir = try std.fs.openDirAbsolute(dir_path, .{ .iterate = true });
    defer dir.close();

    var it = dir.iterate();
    while (try it.next()) |entry| {
        callback(entry.name);
    }
}
