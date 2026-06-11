const std = @import("std");

pub fn writePackageList(
    allocator: std.mem.Allocator,
    path: []const u8,
) !void {
    var child = std.process.Child.init(
        &[_][]const u8{ "pkg", "query", "%n" },
        allocator,
    );

    child.stdout_behavior = .Pipe;

    try child.spawn();

    const out = try child.stdout.?.reader().readAllAlloc(
        allocator,
        1024 * 1024,
    );

    _ = try child.wait();

    try std.fs.cwd().writeFile(.{
        .sub_path = path,
        .data = out,
    });
}
