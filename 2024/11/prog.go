package main

import (
    "fmt"
    "strconv"
)

// apply rules, memoize repeated calculations
func applyRules(number int, table map[int][]int) []int {
    if res, found := table[number]; found {
        return res
    }

    var res []int
    if number == 0 {
        res = []int{1}
    } else if len(strconv.Itoa(number))%2 == 0 {
        s := strconv.Itoa(number)
        m := len(s) / 2
        left, _ := strconv.Atoi(s[:m])
        right, _ := strconv.Atoi(s[m:])
        res = []int{left, right}
    } else {
        res = []int{number * 2024}
    }

    table[number] = res
    return res
}

// count numberber of stones after n blinks
func blinkAndCount(stones []int, blinks int) (int, map[int]int) {
    // start before first blink
    counts := make(map[int]int)
    for _, number := range stones {
        counts[number]++
    }

    table := make(map[int][]int)

    for blink := 0; blink < blinks; blink++ {
        nextCounts := make(map[int]int)
        for number, count := range counts {
            children := applyRules(number, table)
            for _, child := range children {
                nextCounts[child] += count
            }
        }
        counts = nextCounts
    }

    // sum of stones after final blink
    sum := 0
    for _, count := range counts {
        sum += count
    }
    return sum, counts
}

func main() {
    stones := []int{475449, 2599064, 213, 0, 2, 65, 5755, 51149}
    blinks := 75

    total, counts := blinkAndCount(stones, blinks)
    fmt.Printf("Total number of stones after %d blinks: %d\n", blinks, total)

    // fmt.Println("Counts in this step:", counts)
    _ = counts
}
