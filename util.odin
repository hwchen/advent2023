package aoc

import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:testing"

parse_numbers :: proc(s: string, sep: u8) -> []int {
    res: [dynamic]int
    i: int
    n_start, n_end: Maybe(int)
    for i <= len(s) {
        if i < len(s) && is_digit(s[i]) {
            if _, eok := n_end.?; !eok {
                n_start = i
            }
            n_end = i
        } else if i == len(s) || s[i] == sep {
            start, sok := n_start.?
            end, eok := n_end.?
            if sok && eok {
                n, nok := strconv.parse_int(s[start:end + 1])
                append(&res, n)
            }
            n_start = nil
            n_end = nil
        } else {
            // error case
            panic("tried to parse a non-digit into a number")
        }
        i += 1
    }
    return res[:]
}

is_digit :: proc(c: u8) -> bool {
    switch c {
    case '0' ..= '9':
        return true
    case:
        return false
    }
}

@(test)
test_parse_numbers :: proc(t: ^testing.T) {
    input := " 1 2 3"
    expected := []int{1, 2, 3}
    parsed := parse_numbers(input, ' ')
    msg := fmt.tprintf("Expected %v, found %v for input %v", expected, parsed, input)
    testing.expect(t, slice.equal(parsed, []int{1, 2, 3}), msg)
}
