package main

import (
    "bufio"
    "fmt"
    "log"
    "os"
    "sort"
    "strconv"
    "strings"
)

// go run prog.go

func main() {
    file, err := os.Open("input.txt")
    if err != nil {
        log.Fatalf("failed to open file: %s", err)
    }
    defer file.Close()

    // Slices to store parsed integers
    var firstNumbers []int
    var secondNumbers []int

    scanner := bufio.NewScanner(file)
    for scanner.Scan() {
        // Read each line and split into words
        line := scanner.Text()
        words := strings.Fields(line)

        // Check if the line contains exactly two words
        if len(words) == 2 {
            // Parse first word as int
            firstNumber, err1 := strconv.Atoi(words[0])
            // Parse second word as int
            secondNumber, err2 := strconv.Atoi(words[1])

            // Handle parsing errors
            if err1 != nil || err2 != nil {
                log.Printf("error parsing numbers on line: %q", line)
                continue
            }

            firstNumbers = append(firstNumbers, firstNumber)
            secondNumbers = append(secondNumbers, secondNumber)
        } else {
            log.Printf("line does not contain exactly two words: %q", line)
        }
    }

    if err := scanner.Err(); err != nil {
        log.Fatalf("failed to scan file: %s", err)
    }

    // Count occurrences of each number in the second list
    secondCount := make(map[int]int)
    for _, num := range secondNumbers {
        secondCount[num]++
    }

    // Calculate similarity score
    similarityScore := 0
    for _, num := range firstNumbers {
        similarityScore += num * secondCount[num]
    }
    fmt.Printf("Similarity score: %d\n", similarityScore)

    // Sort the slices of integers
    sort.Ints(firstNumbers)
    sort.Ints(secondNumbers)
    fmt.Println("Sorted First Numbers:", firstNumbers)
    fmt.Println("Sorted Second Numbers:", secondNumbers)

    // Calculate distances between corresponding elements
    var distances []int
    if len(firstNumbers) != len(secondNumbers) {
        log.Fatal("First and second number lists are not of the same length")
    }
    for i := 0; i < len(firstNumbers); i++ {
        distance := abs(firstNumbers[i] - secondNumbers[i])
        distances = append(distances, distance)
    }
    fmt.Println("Distances between corresponding elements:", distances)
    
    // Calculate sum of distances
    sumDistances := 0
    for _, distance := range distances {
        sumDistances += distance
    }
    fmt.Printf("Sum of distances: %d\n", sumDistances)
}

// Calculate absolute value
func abs(x int) int {
    if x < 0 {
        return -x
    }
    return x
}
