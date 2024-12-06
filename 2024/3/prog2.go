package main

import (
    "fmt"
    "io/ioutil"
    "log"
    "regexp"
    "strconv"
)

func main() {
    // Read input from file
    input, err := ioutil.ReadFile("input.txt")
    if err != nil {
        log.Fatalf("Failed to read input file: %s", err)
    }

    // Calculate the sum of all mul instruction results
    sum := sumMulInstructions(string(input))
    fmt.Printf("The sum of all mul instruction results is: %d\n", sum)
}

// Function to find all mul instructions and sum up their results
func sumMulInstructions(input string) int {
    // Regular expressions for matching patterns
    mulRe := regexp.MustCompile(`mul\((\d+),(\d+)\)`)
    doRe := regexp.MustCompile(`do\(\)`)
    dontRe := regexp.MustCompile(`don't\(\)`)

    totalSum := 0
    mulEnabled := true // Initially, mul instructions are enabled

    // Define a regular expression for finding all relevant instructions
    instructionRe := regexp.MustCompile(`mul\(\d+,\d+\)|do\(\)|don't\(\)`)

    // Find all instruction matches in the input
    matches := instructionRe.FindAllString(input, -1)
    for _, match := range matches {
        switch {
        case doRe.MatchString(match):
            fmt.Printf("Enable mul\n")
            mulEnabled = true
        case dontRe.MatchString(match):
            fmt.Printf("Disable mul\n")
            mulEnabled = false
        case mulEnabled && mulRe.MatchString(match):
            // Parse the arguments of the mul instruction
            args := mulRe.FindStringSubmatch(match)
            if len(args) == 3 {
                arg1, err1 := strconv.Atoi(args[1])
                arg2, err2 := strconv.Atoi(args[2])
                if err1 == nil && err2 == nil {
                    // Compute the product and add to the total sum
                    totalSum += arg1 * arg2
                }
            }
        }
    }
    return totalSum
}
