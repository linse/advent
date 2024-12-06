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

    // Calculate sum of all mul instruction results
    sum := sumMulInstructions(string(input))
    fmt.Printf("The sum of all mul instruction results is: %d\n", sum)
}

// Find all mul instructions and sum up their results
func sumMulInstructions(input string) int {
    // Regular expression to match the pattern mul(x,y)
    re := regexp.MustCompile(`mul\((\d+),(\d+)\)`)

    totalSum := 0
    matches := re.FindAllStringSubmatch(input, -1)
    for _, match := range matches {
        if len(match) == 3 {
            arg1, err1 := strconv.Atoi(match[1])
            arg2, err2 := strconv.Atoi(match[2])
            if err1 == nil && err2 == nil {
                // Compute the product and add to the total sum
                totalSum += arg1 * arg2
            }
        }
    }
    return totalSum
}
