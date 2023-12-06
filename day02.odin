package aoc

import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"
import "core:testing"

day02 :: proc(input: string) -> (ResultT, ResultT) {
    input := input
    part01 := 0
    part02 := 0
    game: for line in strings.split_iterator(&input, "\n") {
        // Part 01
        header_games := strings.split(line, ":")
        game_num, _ := strconv.parse_int(header_games[0][5:])
        for set in strings.split(header_games[1], ";") {
            r, b, g: int
            colors := strings.split(set, ",")
            for num_color_str in colors {
                num_color := strings.split(strings.trim(num_color_str, " "), " ")
                num, _ := strconv.parse_int(num_color[0])
                switch num_color[1] {
                case "red":
                    r = num
                case "green":
                    g = num
                case "blue":
                    b = num
                }
            }
            if r > 12 || g > 13 || b > 14 {
                continue game
            }
        }
        part01 += game_num
    }
    return part01, part02
}

@(test)
test_day02_part01 :: proc(t: ^testing.T) {
    input := `Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green`

    part01, _ := day02(input)
    testing.expect_value(t, part01, int(8))
}
