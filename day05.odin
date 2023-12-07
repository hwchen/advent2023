package aoc

import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"
import "core:testing"

day05 :: proc(input: string) -> (ResultT, ResultT) {
    input := input
    part01 := 0
    part02 := 0

    sections := strings.split(input, "\n\n")

    // just mutate the seeds
    seeds := parse_numbers(strings.split(sections[0], ":")[1], ' ')

    for section in sections[1:] {
        range_lines := strings.trim(strings.split(section, ":")[1], "\n")
        map_ranges: [dynamic]MapRange
        for range_line in strings.split(range_lines, "\n") {
            append(&map_ranges, (transmute(^MapRange)raw_data(parse_numbers(range_line, ' ')))^)
        }
        // part01
        map_part01(&seeds, map_ranges[:])
    }
    part01 = slice.min(seeds)

    return part01, part02
}

map_part01 :: proc(seeds: ^[]int, ranges: []MapRange) {
    for seed in seeds {
        for range in ranges {
            if seed >= range.source_start && seed < range.source_start + range.range_length {
                seed = range.destination_start + seed - range.source_start
                break
            }
        }
    }
}

MapRange :: struct {
    destination_start: int,
    source_start:      int,
    range_length:      int,
}

@(test)
test_day05 :: proc(t: ^testing.T) {
    input := `seeds: 79 14 55 13

seed-to-soil map:
50 98 2
52 50 48

soil-to-fertilizer map:
0 15 37
37 52 2
39 0 15

fertilizer-to-water map:
49 53 8
0 11 42
42 0 7
57 7 4

water-to-light map:
88 18 7
18 25 70

light-to-temperature map:
45 77 23
81 45 19
68 64 13

temperature-to-humidity map:
0 69 1
1 0 69

humidity-to-location map:
60 56 37
56 93 4`

    part01, part02 := day05(input)
    testing.expect_value(t, part01, int(35))
    testing.expect_value(t, part02, int(0))
}
