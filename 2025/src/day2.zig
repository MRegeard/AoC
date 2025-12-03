const std = @import("std");

pub fn day2() !void {
    const file = try std.fs.cwd().openFile("input/2025/day2_input.txt", .{});
    defer file.close();

    var buf: [1000]u8 = undefined;
    var fileReader = file.reader(&buf);
    const reader: *std.Io.Reader = &fileReader.interface;
    try firstPart(reader);

    var buf2: [1000]u8 = undefined;
    var fileReader2 = file.reader(&buf2);
    const reader2: *std.Io.Reader = &fileReader2.interface;
    try secondPart(reader2);
}

fn secondPart(reader: *std.Io.Reader) !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var invalidIds: u64 = 0;

    while (try reader.takeDelimiter(',')) |ranges| {
        var iter = std.mem.tokenizeAny(u8, ranges, "-");

        const lowBoundBytes = iter.next().?;
        const bound1 = try std.fmt.parseInt(u64, lowBoundBytes, 10);
        const highBoundBytes = std.mem.trimEnd(u8, iter.next().?, "\n");
        const bound2 = try std.fmt.parseInt(u64, highBoundBytes, 10);

        for (bound1..bound2) |idx| {
            const idxu64: u64 = @intCast(idx);

            var digitsBuf: [1000]u8 = undefined;
            const digits = intToDigits(&digitsBuf, idxu64);
            const digitsLen = digits.len;
            if (digitsLen < 2) {
                continue;
            }

            splitLoop: for (2..digitsLen + 1) |split| {
                if (digitsLen % split == 0) {
                    var list = try std.ArrayList(u64).initCapacity(allocator, split);
                    defer list.deinit(allocator);
                    try ditigsToIntArray(digits, &list);
                    if (std.mem.allEqual(u64, list.items, list.items[0])) {
                        invalidIds += idxu64;
                        break :splitLoop;
                    }
                }
            }
        }
    }
    std.debug.print("SecondPart -- Invalid IDs sum: {}\n", .{invalidIds});
}

fn ditigsToIntArray(digits: []const u8, list: *std.ArrayList(u64)) !void {
    const chunkNumber: usize = list.capacity;
    const chunkSize = digits.len / chunkNumber;

    for (0..chunkNumber) |chunkIdx| {
        const start_ptr = chunkIdx * chunkSize;
        const end_ptr = start_ptr + chunkSize;

        const digitChunk = digits[start_ptr..end_ptr];
        const numberDigit = digitsToInt(digitChunk);
        try list.appendBounded(numberDigit);
    }
}

fn firstPart(reader: *std.Io.Reader) !void {
    var invalidIds: u64 = 0;

    while (try reader.takeDelimiter(',')) |ranges| {
        var iter = std.mem.tokenizeAny(u8, ranges, "-");

        const lowBoundBytes = iter.next().?;
        const bound1 = try std.fmt.parseInt(u64, lowBoundBytes, 10);
        const highBoundBytes = std.mem.trimEnd(u8, iter.next().?, "\n");
        const bound2 = try std.fmt.parseInt(u64, highBoundBytes, 10);

        for (bound1..bound2 + 1) |idx| {
            const idxu64: u64 = @intCast(idx);
            var digitsBuf: [1000]u8 = undefined;
            const digits = intToDigits(&digitsBuf, idxu64);
            const digitsLen = digits.len;

            if (digitsLen % 2 == 0) {
                const half1: u64 = digitsToInt(digits[0 .. digitsLen / 2]);
                const half2: u64 = digitsToInt(digits[digitsLen / 2 ..]);

                if (half1 == half2) invalidIds += idxu64;
            }
        }
    }
    std.debug.print("FirstPart -- Invalid IDs sum: {}\n", .{invalidIds});
}

fn intToDigits(buf: []u8, x: u64) []u8 {
    if (x == 0) {
        buf[0] = 0;
        return buf[0..1];
    }

    var n = x;
    var i = buf.len;

    while (n != 0) {
        i -= 1;
        const nu8: u8 = @intCast(n % 10);
        buf[i] = nu8;
        n /= 10;
    }
    return buf[i..];
}

fn digitsToInt(
    digits: []const u8,
) u64 {
    var res: u64 = 0;

    for (digits) |d| {
        const mul = res * 10;
        res = mul;

        const add = res + d;
        res = add;
    }
    return res;
}
