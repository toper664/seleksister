const std = @import("std");

fn readInteger() !i32 {
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();

    var buf: [20]u8 = undefined;

    try stdout.print("Masukkan integer : ", .{});

    if (try stdin.readUntilDelimiterOrEof(buf[0..], '\n')) |user_input| {
        var trimmed = std.mem.trimRight(u8, user_input[0..], "\r");
        return std.fmt.parseInt(i32, trimmed, 10);
    } else {
        return @as(i32, 0);
    }
}

fn addition(operand_1: i32, operand_2: i32) i32 {
    var carry: i32 = operand_1 & operand_2;
    var result: i32 = operand_1 ^ operand_2;

    while (carry != 0) {
        var shifted_carry: i32 = carry << 1;
        carry = result & shifted_carry;
        result ^= shifted_carry;
    }
    return result;
}

fn subtraction(operand_1: i32, operand_2: i32) i32 {
    // add operand_1 to negative of operand_2
    return addition(operand_1, addition(~operand_2, 1));
}

fn absoluteValue(operand: i32) i32 {
    var mask: i32 = operand >> 31;
    return addition(mask, operand) ^ mask;
}

fn sign(operand: i32) i32 {
    return (operand >> 31) & 1;
}

fn muldiv(operand_1: i32, operand_2: i32, multiply: bool) i32 {
    const sign_bit: i32 = (sign(operand_1) ^ sign(operand_2));

    var result: i32 = 0;

    if (!multiply and operand_2 == 0) {
        result = std.math.maxInt(i32);
    } else {
        const result_increment: i32 = if (multiply) absoluteValue(operand_2) else 1;

        var counter: i32 = absoluteValue(operand_1);
        const counter_decrement: i32 = if (multiply) 1 else absoluteValue(operand_2);

        while (counter >= counter_decrement) {
            counter = subtraction(counter, counter_decrement);
            result = addition(result, result_increment);
        }
    }

    return if (sign_bit == 0) result else subtraction(0, result);
}

fn operate(operand_1: i32, operator: []const u8, operand_2: i32) i32 {
    if (std.mem.eql(u8, operator, "+")) {
        return addition(operand_1, operand_2);
    } else if (std.mem.eql(u8, operator, "-")) {
        return subtraction(operand_1, operand_2);
    } else if (std.mem.eql(u8, operator, "*")) {
        return muldiv(operand_1, operand_2, true);
    } else if (std.mem.eql(u8, operator, "/")) {
        return muldiv(operand_1, operand_2, false);
    } else {
        return std.math.maxInt(i32);
    }
}

fn readExpression() !void {
    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();

    var buf: [100]u8 = undefined;

    try stdout.print("\nMasukkan ekspresi : \n", .{});

    if (try stdin.readUntilDelimiterOrEof(buf[0..], '\n')) |user_input| {
        var trimmed = std.mem.trimRight(u8, user_input[0..], "\r");

        var it = std.mem.split(u8, trimmed[0..], " ");

        var is_complete_expr: bool = false;
        var is_start: bool = true;
        var operand_1: i32 = 0;
        var operand_2: i32 = 0;
        var operator: []const u8 = "";

        var err: bool = false;

        try stdout.print("Perhitungan: \n", .{});
        while (it.next()) |x| {
            // try stdout.print("{s}\n", .{x});
            if (is_start) {
                operand_1 = try std.fmt.parseInt(i32, x, 10);
                is_complete_expr = true;
                is_start = false;
            } else {
                if (is_complete_expr) {
                    operator = x;
                } else {
                    operand_2 = try std.fmt.parseInt(i32, x, 10);
                }
                is_complete_expr = !is_complete_expr;

                if (is_complete_expr) {
                    var result = operate(operand_1, operator, operand_2);
                    try stdout.print("{d} {s} {d} = {d}\n", .{ operand_1, operator, operand_2, result });
                    operand_1 = result;

                    if (std.mem.eql(u8, operator, "/") and operand_2 == 0) {
                        err = true;
                        try stdout.print("Zero division error\n", .{});
                        break;
                    }
                }
            }
        }

        if (!err) try stdout.print("\nHasil = {d}\n", .{operand_1});
    }

    // todo: error handling
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    try stdout.print("===========Klak===========\n", .{});
    try stdout.print("Valid Operators: + - * /\n", .{});
    try stdout.print("Input example: 1 + 2 * 3\n", .{});
    try stdout.print("Note: separate operands and operators using ' ' (single space)\n", .{});
    try stdout.print("Note: operations evaluated from left to right\n", .{});

    try readExpression();
}
