const std = @import("std");

pub fn day3() !void {
    const file = try std.fs.cwd().openFile("input/2025/day3_input.txt", .{});
    defer file.close();

    var buf: [1024]u8 = undefined;
    var fileReader = file.reader(&buf);
    const reader: *std.Io.Reader = &fileReader.interface;

    try firstPart(reader);

    var buf2: [1024]u8 = undefined;
    var fileReader2 = file.reader(&buf2);
    const reader2: *std.Io.Reader = &fileReader2.interface;

    try secondPart(reader2);
}

fn firstPart(reader: *std.Io.Reader) !void {
    var sumJoltage: u32 = 0;
    while (try reader.takeDelimiter('\n')) |line| {
        const lenLine: usize = line.len;
        var highest: u8 = 0;
        var posHighest: usize = 0;
        var pow: u8 = 2;
        var maxJoltage: u8 = 0;
        var startLoop: usize = 0;
        while (pow > 0) : (pow -= 1) {
            for (startLoop..lenLine - pow + 1) |i| {
                const bu8 = line[i] - '0';
                if (bu8 > highest) {
                    highest = bu8;
                    posHighest = i;
                }
            }
            maxJoltage += highest * std.math.pow(u8, 10, pow - 1);
            startLoop = posHighest + 1;
            highest = 0;
            posHighest = 0;
        }
        sumJoltage += @intCast(maxJoltage);
    }
    std.debug.print("FirstPart -- Sum of max Joltage: {}\n", .{sumJoltage});
}

fn secondPart(reader: *std.Io.Reader) !void {
    var sumJoltage: u64 = 0;
    while (try reader.takeDelimiter('\n')) |line| {
        const lenLine: usize = line.len;
        var highest: u8 = 0;
        var posHighest: usize = 0;
        var pow: u8 = 12;
        var maxJoltage: u64 = 0;
        var startLoop: usize = 0;
        while (pow > 0) : (pow -= 1) {
            for (startLoop..lenLine - pow + 1) |i| {
                const bu8 = line[i] - '0';
                if (bu8 > highest) {
                    highest = bu8;
                    posHighest = i;
                }
            }
            maxJoltage += highest * std.math.pow(u64, 10, pow - 1);
            startLoop = posHighest + 1;
            highest = 0;
            posHighest = 0;
        }
        sumJoltage += @intCast(maxJoltage);
    }
    std.debug.print("SecondPart -- Sum of max Joltage: {}\n", .{sumJoltage});
}
