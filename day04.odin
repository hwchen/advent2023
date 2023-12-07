package aoc

import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"
import "core:testing"

day04 :: proc(input: string) -> (ResultT, ResultT) {
    input := input
    part01 := 0
    part02 := 0
    for line in strings.split_iterator(&input, "\n") {
        header_body := strings.split(line, ":")
        //card_num, _ := strconv.parse_int(header_body[0][5:])
        sets := strings.split(header_body[1], "|")
        winners := parse_numbers(sets[0], ' ')
        mine := parse_numbers(sets[1], ' ')

        matches : uint
        for m in mine {
            for w in winners {
                if m == w {
                    matches += 1
                }
            }
        }
        part01 += 0 if matches == 0 else 1 << (matches - 1)
    }
    return part01, part02
}

@(test)
test_day04 :: proc(t: ^testing.T) {
    input := `Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11`

    part01, part02 := day04(input)
    testing.expect_value(t, part01, int(13))
    testing.expect_value(t, part02, int(0))
}
