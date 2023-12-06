package aoc

import "core:bytes"
import "core:fmt"
import "core:strconv"
import "core:testing"

day03 :: proc(input: string) -> (ResultT, ResultT) {
    input := input
    part01 := 0
    part02 := 0
    schematic := bytes.split(transmute([]u8)input, {'\n'})
    symbols : map[Point]Symbol
    numbers : [dynamic]Number
    line_len := len(schematic[0])
    // unfortunate hacky parsing
    for line, y in schematic {
        x := 0
        curr_n_start, curr_n_end: Maybe(int)
        for x <= len(line) {
            if x < len(line) && is_digit(line[x]) {
                if _, ok := curr_n_end.?; !ok {
                    curr_n_start = x
                }
                curr_n_end = x
            } else if x == len(line) || !is_digit(line[x]) {
                // just handle symbols
                if x < len(line) && is_symbol(line[x]) {
                    symbols[Point{x, y}] = Symbol {c = line[x], point = Point{x, y}}
                }
                start, sok := curr_n_start.?
                end, eok := curr_n_end.?
                if sok && eok {
                    n, _ := strconv.parse_int(string(line[start:end + 1]))
                    append(&numbers, Number{n = n, y = y, x_start = start, x_end = end})
                }
                curr_n_start = nil
                curr_n_end = nil
            }
            x += 1
        }
    }
    n_block: for n in numbers {
        // adjecent points
        // hack, just also generate point for num itself to reduce logic
        coord: for y in clamp(n.y - 1, 0, len(schematic))..=clamp(n.y + 1, 0, len(schematic)) {
            for x in clamp(n.x_start - 1, 0, line_len - 1)..=clamp(n.x_end + 1, 0, line_len - 1) {
                point := Point{x, y}
                if point in symbols {
                    part01 += n.n
                    continue n_block
                }
            }
        }
    }
    return part01, part02
}

Point :: struct {
    x: int,
    y: int,
}

Symbol :: struct {
    c: u8,
    point: Point,
}
Number :: struct {
    n: int,
    y: int,
    x_start: int,
    x_end: int,
}

is_symbol :: proc(c: u8) -> bool {
    switch c {
        case '.', '0'..='9':
            return false
        case:
            return true
    }
}

is_digit :: proc(c: u8) -> bool {
    switch c {
        case '0'..='9':
            return true
        case:
            return false
    }
}

@(test)
test_day03 :: proc(t: ^testing.T) {
    input := `467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..`
    part01, part02 := day03(input)
    testing.expect_value(t, part01, int(4361))
    testing.expect_value(t, part02, int(0))
}
