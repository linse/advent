package main

import (
    "bufio"
    "fmt"
    "log"
    "os"
    "strconv"
    "strings"
)

// Generate all combinations of operators for n - 1 positions (between n numbers)
func generateOperatorCombinations(n int) [][]string {
    var combinations [][]string
    var backtrack func(int, []string)
    backtrack = func(pos int, current []string) {
        if pos == n-1 {
            // Copy the current slice to prevent mutation in subsequent iterations
            combination := make([]string, len(current))
            copy(combination, current)
            combinations = append(combinations, combination)
            return
        }

        current = append(current, "+")
        backtrack(pos+1, current)
        current[pos] = "*"
        backtrack(pos+1, current)
        current = current[:len(current)-1]
    }

    backtrack(0, []string{})
    return combinations
}

// Evaluate an expression with left-to-right operator rules
func evaluateExpression(numbers []int, operators []string) int {
    if len(numbers) == 0 {
        return 0
    }
    res := numbers[0]
    for i, op := range operators {
        switch op {
        case "+":
            res += numbers[i+1]
        case "*":
            res *= numbers[i+1]
        }
    }
    return res
}

func main() {
    // Open the input file
    file, err := os.Open("input.txt")
    if err != nil {
        log.Fatalf("Failed to open file: %v", err)
    }
    defer file.Close()

    scanner := bufio.NewScanner(file)
    calibrationResult := 0

    // Process each line in the input
    for scanner.Scan() {
        line := scanner.Text()
        parts := strings.Split(line, ":")
        if len(parts) != 2 {
            continue // Skip malformed lines
        }

        // Parse the expected result
        expectedResult, err := strconv.Atoi(strings.TrimSpace(parts[0]))
        if err != nil {
            log.Fatalf("Error parsing expected result: %v", err)
        }

        // Parse the numbers
        numberStrings := strings.Fields(strings.TrimSpace(parts[1]))
        numbers := make([]int, len(numberStrings))
        for i, ns := range numberStrings {
            numbers[i], err = strconv.Atoi(ns)
            if err != nil {
                log.Fatalf("Error parsing number: %v", err)
            }
        }

        // Generate all combinations of operators
        operatorCombinations := generateOperatorCombinations(len(numbers))

        // Check if any combination of operators makes the equation valid
        valid := false
        for _, operators := range operatorCombinations {
            if evaluateExpression(numbers, operators) == expectedResult {
                valid = true
                break
            }
        }

        // if valid, add result to calibration total
        if valid {
            calibrationResult += expectedResult
        }
    }

    if err := scanner.Err(); err != nil {
        log.Fatalf("Error reading file: %v", err)
    }

    fmt.Printf("Calibration Result: %d\n", calibrationResult)
}        
