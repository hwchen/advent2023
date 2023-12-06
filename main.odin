package aoc

import "core:fmt"
import "core:os"
import "core:strings"
import "core:time"

DayProc :: proc(_: string) -> (ResultT, ResultT)
ResultT :: union {
    int,
    u64,
}

run :: proc(day: string, procedure: DayProc) -> f64 {
    filename := strings.concatenate({"./input/", day, ".txt"})
    defer delete(filename)

    content, ok := os.read_entire_file(filename)
    if !ok {
        fmt.println("Failed to read input file ", filename)
        return 0
    }
    defer delete(content)

    stopwatch: time.Stopwatch
    time.stopwatch_start(&stopwatch)
    part1, part2 := procedure(string(content))
    time.stopwatch_stop(&stopwatch)

    runtime := time.duration_milliseconds(stopwatch._accumulation)

    fmt.printf("%s -- %fms\n", day, runtime)
    fmt.printf("  part1: %v\n", part1)
    fmt.printf("  part2: %v\n", part2)

    return runtime
}

main :: proc() {
    days := map[string]DayProc {
        "day01" = day01,
        "day02" = day02,
    };defer delete(days)

    total_time := 0.0
    for day, procedure in days do total_time += run(day, procedure)

    fmt.println("total time: ", total_time, "ms")
}
