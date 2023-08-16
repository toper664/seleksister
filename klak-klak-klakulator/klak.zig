const std = @import("std");

// Function to perform bitwise addition using only bitwise operators
fn bitwiseAddition(x: i32, y: i32) i32 {
    var xVar: i32 = x;
    var yVar: i32 = y;

    while (yVar != 0) {
        const carry = xVar & yVar;
        xVar = xVar ^ yVar;
        yVar = carry << 1;
    }

    return xVar;
}

fn readInteger() !i32 {
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();

    var buf: [20]u8 = undefined;

    try stdout.print("Input number : ", .{});

    if (try stdin.readUntilDelimiterOrEof(buf[0..], '\n')) |user_input| {
        var trimmed = std.mem.trimRight(u8, user_input[0..], "\r");
        return std.fmt.parseInt(i32, trimmed, 10);
    } else {
        return @as(i32, 0);
    }
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    try (stdout.print("Enter two numbers to perform addition using bitwise operators: {}", .{}));

    var num1: i32 = try (readInteger());
    var num2: i32 = try (readInteger());

    const result = bitwiseAddition(num1, num2);

    // Printing the result
    try stdout.print("Sum: {d}\n", .{result});
}
