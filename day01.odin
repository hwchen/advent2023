package aoc

import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"
import "core:testing"

day01 :: proc(input: string) -> (ResultT, ResultT) {
    input := input

    part01 := 0
    part02 := 0

    for line in strings.split_iterator(&input, "\n") {
        // Part 01
        first_idx := strings.index_any(line, "0123456789")
        last_idx := strings.last_index_any(line, "0123456789")
        if first_idx != -1 && last_idx != -1 {
            cal01, _ := strconv.parse_int(string([]u8{line[first_idx], line[last_idx]}))
            part01 += cal01
        }

        // Part 02
        fw_d, fw_idx := first_written_digit(line)
        lw_d, lw_idx := last_written_digit(line)
        // hacky but works on this data

        // hacky; need to keep cases in this order to make sure the "not found" cases are considered first
        first_digit: u8
        switch {
        case first_idx == -1:
            first_digit = u8(fw_d + 48)
        case fw_idx == -1:
            first_digit = line[first_idx]
        case first_idx < fw_idx:
            first_digit = line[first_idx]
        case fw_idx < first_idx:
            first_digit = u8(fw_d + 48)
        }
        last_digit: u8
        switch {
        case last_idx == -1:
            last_digit = u8(lw_d + 48)
        case lw_idx == -1:
            last_digit = line[last_idx]
        case last_idx > lw_idx:
            last_digit = line[last_idx]
        case lw_idx > last_idx:
            last_digit = u8(lw_d + 48)
        }

        cal02, _ := strconv.parse_int(string([]u8{first_digit, last_digit}))
        part02 += cal02

    }

    return part01, part02
}

written_digits_fwd := [10]string {
    "zero",
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine",
}
written_digits_rev := [10]string {
    "orez",
    "eno",
    "owt",
    "eerht",
    "ruof",
    "evif",
    "xis",
    "neves",
    "thgie",
    "enin",
}

first_written_digit :: proc(s: string) -> (digit: int, idx: int) {
    digit = -1
    found_idx := len(s)
    i, width := strings.index_multi(s, written_digits_fwd[:])
    if i != -1 && i < found_idx {
        found_idx = i
        digit, _ = slice.linear_search(written_digits_fwd[:], string(s[i:][:width]))
    }
    return digit, found_idx if found_idx < len(s) else -1
}
last_written_digit :: proc(s: string) -> (digit: int, idx: int) {
    s := strings.reverse(s)
    digit = -1
    found_idx := -1
    i, width := strings.index_multi(s, written_digits_rev[:])
    if i != -1 && i > found_idx {
        found_idx = i
        digit, _ = slice.linear_search(written_digits_rev[:], string(s[i:][:width]))
    }
    return digit, len(s) - found_idx - width if found_idx >= 0 else -1
}

@(test)
test_day01_part01 :: proc(t: ^testing.T) {
    input := `1abc2
pqr3stu8vwx
a1b2c3d4e5fj
treb7uchet`

    part01, _ := day01(input)
    testing.expect_value(t, part01, int(142))
}

@(test)
test_day01_part02 :: proc(t: ^testing.T) {
    {
        input := `two1nine
eightwothree
abcone2threexyz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen`

        _, part02 := day01(input)
        testing.expect_value(t, part02, int(281))
    }
    {
        // input := "1" // this will fail until https://github.com/odin-lang/Odin/pull/3006 merged
        input := "a1"
        _, part02 := day01(input)
        testing.expect_value(t, part02, int(11))
    }
}

@(test)
test_written_digits :: proc(t: ^testing.T) {
    {
        input := "two1nine"
        fwd, fwidx := first_written_digit(input)
        lwd, lwidx := last_written_digit(input)
        testing.expect_value(t, fwd, int(2))
        testing.expect_value(t, lwd, int(9))
        testing.expect_value(t, fwidx, int(0))
        testing.expect_value(t, lwidx, int(4))
    }
    {
        input := "1"
        fwd, fwidx := first_written_digit(input)
        lwd, lwidx := last_written_digit(input)
        testing.expect_value(t, fwd, int(-1))
        testing.expect_value(t, lwd, int(-1))
        testing.expect_value(t, fwidx, int(-1))
        testing.expect_value(t, lwidx, int(-1))
    }
    {
        input := "twone"
        fwd, fwidx := first_written_digit(input)
        lwd, lwidx := last_written_digit(input)
        testing.expect_value(t, fwd, int(2))
        testing.expect_value(t, lwd, int(1))
        testing.expect_value(t, fwidx, int(0))
        testing.expect_value(t, lwidx, int(2))
        _, part02 := day01(input)
        testing.expect_value(t, part02, int(21))
    }
    {
        input := "one"
        fwd, fwidx := first_written_digit(input)
        lwd, lwidx := last_written_digit(input)
        testing.expect_value(t, fwd, int(1))
        testing.expect_value(t, lwd, int(1))
        testing.expect_value(t, fwidx, int(0))
        testing.expect_value(t, lwidx, int(0))
        _, part02 := day01(input)
        testing.expect_value(t, part02, int(11))
    }
}
