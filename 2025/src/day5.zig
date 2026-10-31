const std = @import("std");

const Range = struct {
    lo: u64,
    hi: u64,
};

pub fn day5() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const file = try std.fs.cwd().openFile("input/2025/day5_input.txt", .{});
    defer file.close();

    var buf: [1024]u8 = undefined;
    var fileReader = file.reader(&buf);
    const reader = &fileReader.interface;

    var ranges = try std.ArrayList(Range).initCapacity(allocator, 0);
    defer ranges.deinit(allocator);

    var ids = try std.ArrayList(u64).initCapacity(allocator, 0);
    defer ids.deinit(allocator);

    var isRanges = true;
    while (try reader.takeDelimiter('\n')) |line| {
        if (line.len == 0) {
            isRanges = false;
            continue;
        }
        if (isRanges) {
            var splitIt = std.mem.splitScalar(u8, line, '-');
            const r1 = try std.fmt.parseInt(u64, splitIt.next().?, 10);
            const r2 = try std.fmt.parseInt(u64, splitIt.next().?, 10);
            try ranges.append(allocator, .{ .lo = r1, .hi = r2 });
        } else {
            const id: u64 = try std.fmt.parseInt(u64, line, 10);
            try ids.append(allocator, id);
        }
    }
    firstPart(ids, ranges);
    secondPart(ranges);
}

fn secondPart(ranges: std.ArrayList(Range)) void {
    outer: for (0..ranges.items.len - 1) |i| {
        inner: for (i + 1..ranges.items.len) |j| {
            const r1 = ranges.items[i];
            const r2 = ranges.items[j];
            if (r1.lo == 0 and r1.hi == 0) {
                continue :outer;
            }
            if (r2.lo == 0 and r2.hi == 0) {
                continue :inner;
            }
            if (r1.lo == r2.lo and r1.hi == r2.hi) {
                ranges.items[j] = .{ .lo = 0, .hi = 0 };
            }
            if (r2.lo >= r1.lo and r2.hi <= r1.lo) { // r2 totally contained in r1
                ranges.items[j] = .{ .lo = 0, .hi = 0 };
            }
            if (r1.lo >= r2.lo and r1.hi <= r2.hi) { // r1 totally contined in r2
                ranges.items[i] = .{ .lo = 0, .hi = 0 };
                continue :outer;
            }
            if (r2.lo > r1.lo) { // r2 right overlap r1 e.g. r1 = 8, 12; r2 = 10, 13
                ranges.items[j].lo = ranges.items[i].hi;
            }
            if (r2.hi < r1.hi) { // r2 left overlap r1 e.g. r1 = 6, 13 r2 = 1, 8
                ranges.items[j].hi = ranges.items[i].lo;
            }
        }
    }
    var totalId: u64 = 0;
    for (ranges.items) |r| {
        totalId += r.hi - r.lo;
    }
    std.debug.print("SecondPart -- totalId: {}\n", .{totalId});
}

fn firstPart(ids: std.ArrayList(u64), ranges: std.ArrayList(Range)) void {
    var totalFresh: u64 = 0;
    idLoop: for (ids.items) |id| {
        for (ranges.items) |r| {
            if ((id >= r.lo) and (id <= r.hi)) {
                totalFresh += 1;
                continue :idLoop;
            }
        }
    }
    std.debug.print("FirstPart -- totalFresh: {}\n", .{totalFresh});
}
