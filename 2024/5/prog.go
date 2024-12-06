package main

import (
    "bufio"
    "fmt"
    "os"
    "strconv"
    "strings"
)

// Parse the input file and return ordering rules and page updates
func parseInput(filePath string) ([][2]int, [][]int, error) {
    file, err := os.Open(filePath)
    if err != nil {
        return nil, nil, err
    }
    defer file.Close()

    var orderingRules [][2]int
    var updates [][]int

    scanner := bufio.NewScanner(file)

    // Read ordering rules
    for scanner.Scan() {
        line := scanner.Text()
        if line == "" {
            break
        }
        parts := strings.Split(line, "|")
        a, _ := strconv.Atoi(parts[0])
        b, _ := strconv.Atoi(parts[1])
        orderingRules = append(orderingRules, [2]int{a, b})
    }

    // Read updates
    for scanner.Scan() {
        line := scanner.Text()
        pageStrings := strings.Split(line, ",")
        var pages []int
        for _, pageStr := range pageStrings {
            page, _ := strconv.Atoi(pageStr)
            pages = append(pages, page)
        }
        updates = append(updates, pages)
    }

    if err := scanner.Err(); err != nil {
        return nil, nil, err
    }

    return orderingRules, updates, nil
}

// Check if list of pages satisfies all ordering rules
func isCorrectlyOrdered(rules [][2]int, update []int) bool {
    pageIndex := make(map[int]int)
    for i, page := range update {
        pageIndex[page] = i
    }

    for _, rule := range rules {
        first, second := rule[0], rule[1]
        if firstIndex, ok := pageIndex[first]; ok {
            if secondIndex, ok := pageIndex[second]; ok {
                if firstIndex >= secondIndex {
                    return false
                }
            }
        }
    }
    return true
}


// Calculate the sum of the middle pages from correctly ordered updates
func calculateSumOfMiddlePages(filePath string) (int, error) {
    orderingRules, updates, err := parseInput(filePath)
    if err != nil {
        return 0, err
    }

    sumMiddlePages := 0
    for _, update := range updates {
        if isCorrectlyOrdered(orderingRules, update) {
            // Find the middle page without sorting
            middleIndex := len(update) / 2
            middlePage := update[middleIndex]

            // Add the middle page to the sum
            sumMiddlePages += middlePage
        }
    }
    return sumMiddlePages, nil
}


func main() {
    filePath := "input.txt"
    result, err := calculateSumOfMiddlePages(filePath)
    if err != nil {
        fmt.Println("Error:", err)
    } else {
        fmt.Println(result)
    }
}
