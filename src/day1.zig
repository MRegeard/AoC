const std = @import("std");

pub fn day1() !void {
    const file = try std.fs.cwd().openFile("input/2025/day1_input1.txt", .{});
    defer file.close();

    var buf: [4096]u8 = undefined;
    var file_reader = file.reader(&buf);
    const reader: *std.Io.Reader = &file_reader.interface;

    try partOne(reader);

    var buf2: [4096]u8 = undefined;
    var file_reader2 = file.reader(&buf2);
    const reader2: *std.Io.Reader = &file_reader2.interface;
    try secondPart(reader2);
}

pub fn partOne(r: *std.Io.Reader) !void {
    var pointer_position: u32 = 50;
    var number_zero: usize = 0;

    while (try r.takeDelimiter('\n')) |line| {
        if (line[0] == 'R') {
            pointer_position = add100Overflow(pointer_position, try std.fmt.parseInt(u32, line[1..], 10));
        } else {
            pointer_position = sub100Overflow(pointer_position, try std.fmt.parseInt(u32, line[1..], 10));
        }
        number_zero += @intFromBool(pointer_position == 0);
    }
    std.debug.print("First Part -- Number of zeros encounter: {}\n", .{number_zero});
}

pub fn secondPart(r: *std.Io.Reader) !void {
    var pointer_position: u32 = 50;
    var number_zero: usize = 0;

    //    var line_counter: usize = 0;
    while (try r.takeDelimiter('\n')) |line| {
        //        line_counter += 1;
        //        if (line_counter == 20) break;
        if (line[0] == 'R') {
            const overflowedPointer = pointer_position + try std.fmt.parseInt(u32, line[1..], 10);
            const overflowedPointerFloat: f64 = @floatFromInt(overflowedPointer);
            const addToZero: u32 = @intFromFloat(overflowedPointerFloat / 100.0);
            number_zero += addToZero;
            pointer_position = @mod(overflowedPointer, 100);
        } else {
            const shift: u32 = try std.fmt.parseInt(u32, line[1..], 10);
            if (shift < pointer_position) {
                pointer_position -= shift;
            } else {
                const overflowedPointer: i64 = @as(i64, pointer_position) - @as(i64, shift);
                const overflowedPointerFloat: f64 = @floatFromInt(overflowedPointer);
                const addToZero: u32 = @intFromFloat(@abs(overflowedPointerFloat) / 100.0);
                if (pointer_position == 0) {
                    number_zero += addToZero;
                } else {
                    number_zero += addToZero + 1;
                }
                pointer_position = @intCast(@mod(overflowedPointer, 100));
            }
        }
    }
    std.debug.print("SecondPart -- Number of zeros encounter: {}\n", .{number_zero});
}

pub fn add100Overflow(a: u32, b: u32) u32 {
    var res = a + b;
    if (res > 99) {
        res %= 100;
    }
    return res;
}

pub fn sub100Overflow(a: u32, b: u32) u32 {
    const ai: i64 = @intCast(a);
    const bi: i64 = @intCast(b);
    var resi = ai - bi;
    if (resi < 0) {
        resi = @mod(resi, 100);
    }
    const res: u32 = @intCast(resi);
    return res;
}
