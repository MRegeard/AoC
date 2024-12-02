const std = @import("std");

pub fn main() !void {
    var path_buffer: [std.fs.max_path_bytes]u8 = undefined;
    const path = try std.fs.realpath("input/input1.txt", &path_buffer);

    var arena_allocator = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena_allocator.deinit();
    const gpa = arena_allocator.allocator();

    const file = std.fs.cwd().openFile(path, .{}) catch |err| {
        std.log.err("Failed to open file: {s}", .{@errorName(err)});
        return err;
    };
    defer file.close();

    var array_list1 = std.ArrayList(u32).init(gpa);
    var array_list2 = std.ArrayList(u32).init(gpa);

    while (file.reader().readUntilDelimiterOrEofAlloc(gpa, '\n', std.math.maxInt(usize)) catch |err| {
        std.log.err("Failed to read line: {s}", .{@errorName(err)});
        return err;
    }) |line| {
        const int1 = try std.fmt.parseInt(u32, line[0..5], 10);
        const int2 = try std.fmt.parseInt(u32, line[8..], 10);
        try array_list1.append(int1);
        try array_list2.append(int2);
    }
    const slice_list1 = try array_list1.toOwnedSlice();
    const slice_list2 = try array_list2.toOwnedSlice();

    const counts = try firstPart(slice_list1, slice_list2);
    try std.io.getStdOut().writer().print("1st part, total is: {}\n", .{counts});

    const counts_2 = try secondPart(slice_list1, slice_list2);
    try std.io.getStdOut().writer().print("2nd part, total is: {}\n", .{counts_2});
}

pub fn secondPart(slice_list1: []u32, slice_list2: []u32) !u64 {
    var sim_score: u64 = 0;

    for (slice_list1) |s1| {
        var count: u32 = 0;
        for (slice_list2) |s2| {
            if (s1 == s2) {
                count += 1;
            }
        }
        sim_score += s1 * count;
    }
    return sim_score;
}

pub fn firstPart(slice_list1: []u32, slice_list2: []u32) !u64 {
    std.mem.sort(u32, slice_list1, {}, comptime std.sort.asc(u32));
    std.mem.sort(u32, slice_list2, {}, comptime std.sort.asc(u32));

    var counts: u64 = 0;

    for (slice_list1, slice_list2) |s1, s2| {
        switch (s1 < s2) {
            true => counts += s2 - s1,
            false => counts += s1 - s2,
        }
    }
    return counts;
}
