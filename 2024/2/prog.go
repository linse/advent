package main

import (
    "bufio"
    "fmt"
    "log"
    "os"
    "strconv"
    "strings"
)

func main() {
    file, err := os.Open("input.txt")
    if err != nil {
        log.Fatalf("Failed to open file: %s", err)
    }
    defer file.Close()

    scanner := bufio.NewScanner(file)
    safeReportCount := 0
    for lineNumber := 1; scanner.Scan(); lineNumber++ {
        line := scanner.Text()
        numbers := strings.Fields(line)

        // Convert strings to a slice of integers
        var levels []int
        for _, str := range numbers {
            num, err := strconv.Atoi(str)
            if err != nil {
                log.Printf("Error parsing number %q in line %d: %q", str, lineNumber, line)
                continue
            }
            levels = append(levels, num)
        }

        // Check if report is safe
        isSafe := isSafeReport(levels)
        if isSafe {
            fmt.Printf("Report %d is safe.\n", lineNumber)
            safeReportCount++
        } else {
            fmt.Printf("Report %d is NOT safe.\n", lineNumber)
        }
    }

    if err := scanner.Err(); err != nil {
        log.Fatalf("Failed to scan file: %s", err)
    }
    fmt.Printf("Total number of safe reports: %d\n", safeReportCount)
}

// Calculate absolute value
func abs(x int) int {
    if x < 0 {
        return -x
    }
    return x
}

// Determine if a report is safe
func isSafeReport1(levels []int) bool {
    // Any single-level report is safe
    if len(levels) < 2 {
        return true
    }

    increasing := false
    decreasing := false
    for i := 1; i < len(levels); i++ {
        diff := abs(levels[i] - levels[i-1])

        // Adjacent levels do not differ by 1, 2, or 3
        if diff < 1 || 3 < diff {
            fmt.Printf("wrong difference %d - not safe\n", diff)
            return false
        }

        if levels[i] > levels[i-1] {
            increasing = true
        } else if levels[i] < levels[i-1] {
            decreasing = true
        }

        // the levels are neither exclusively increasing nor decreasing.
        if increasing && decreasing {
            fmt.Printf("increasing and decreasing - not safe\n")
            return false
        }
    }

    // At this point it's all increasing or all decreasing with valid differences
    return true
}


func isSafeReport(levels []int) bool {
    // Is the original report already safe?
    if checkSafety(levels) {
        return true
    }

    // Remove each level, one at a time, to check if it makes the report safe
    for i := 0; i < len(levels); i++ {
        // new slice without i-th level
        modifiedLevels := make([]int, len(levels)-1)
        copy(modifiedLevels, levels[:i])
        copy(modifiedLevels[i:], levels[i+1:])

        // without this level, is the report safe?
        if isSafeReport1(modifiedLevels) {
            fmt.Printf("phew we are safe without level %d\n", i)
            return true
        }
    }
    // none of the removals result in a safe report
    return false
}
