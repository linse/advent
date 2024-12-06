package main

import (
    "bufio"
    "fmt"
    "log"
    "os"
    "strconv"
    "container/heap"
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

// Check if a list of pages satisfies all ordering rules
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
    
    // All rules are satisfied
    return true
}

// reorder the elements of the update according to the rules
func reorderUpdate(rules [][2]int, update []int) []int {
    // Filter out only the elements of interest based on the update
    inUpdate := make(map[int]bool)
    for _, page := range update {
        inUpdate[page] = true
    }

    // Prepare graph and indegree information using only update elements
    inDegree := make(map[int]int)
    graph := make(map[int][]int)

    for _, rule := range rules {
        first, second := rule[0], rule[1]
        if inUpdate[first] && inUpdate[second] {
            graph[first] = append(graph[first], second)
            inDegree[second]++
        }
    }

    // Initialize queue using a min-heap to ensure stable ordering
    priorityQueue := &IntHeap{}
    heap.Init(priorityQueue)
    for _, page := range update {
        if inDegree[page] == 0 {
            heap.Push(priorityQueue, page)
        }
    }

    // Perform topological sort
    orderedUpdate := make([]int, 0, len(update))
    for priorityQueue.Len() > 0 {
        current := heap.Pop(priorityQueue).(int)
        orderedUpdate = append(orderedUpdate, current)

        for _, neighbor := range graph[current] {
            inDegree[neighbor]--
            if inDegree[neighbor] == 0 {
                heap.Push(priorityQueue, neighbor)
            }
        }
    }

    // orderedUpdate should now contain all elements in a valid order
    return orderedUpdate
}

// IntHeap is a min-heap of integers, implementing heap.Interface
type IntHeap []int

// Len returns the number of elements in the heap.
func (h IntHeap) Len() int {
    return len(h)
}

// Less reports whether the element with index i should sort before or after the element with index j.
func (h IntHeap) Less(i, j int) bool {
    return h[i] < h[j] // We want a min-heap, so "less" means "less than".
}

// Swap swaps the elements with indexes i and j.
func (h IntHeap) Swap(i, j int) {
    h[i], h[j] = h[j], h[i]
}

// Push adds a new element x to the heap.
func (h *IntHeap) Push(x interface{}) {
    // Cast x to int and append it to the heap.
    *h = append(*h, x.(int))
}

// Pop removes and returns the smallest element from the heap.
func (h *IntHeap) Pop() interface{} {
    // Remove and return the last element, which is the smallest due to the heap properties.
    old := *h
    n := len(old)
    x := old[n-1]
    *h = old[0 : n-1]
    return x
}

// Calculate the sum of the middle pages from correctly ordered updates
func calculateSumOfMiddlePages(filePath string) (int, error) {
    orderingRules, updates, err := parseInput(filePath)
    if err != nil {
        return 0, err
    }

    sumMiddlePages := 0

    for _, update := range updates {
        fmt.Printf("update %#v\n", update)
        if !isCorrectlyOrdered(orderingRules, update) {
            // Reorder the update if it's incorrect
            update = reorderUpdate(orderingRules, update)
            fmt.Printf("reordered update %#v\n", update)

            if len(update) > 0 {
                // Find the middle page
                middleIndex := len(update) / 2
                middlePage := update[middleIndex]

                // Add the middle page to the sum
                sumMiddlePages += middlePage
            }
        }
    }
    return sumMiddlePages, nil
}


func main() {
    filePath := "input.txt"

    // Calculate the sum of the middle pages
    sum, err := calculateSumOfMiddlePages(filePath)
    if err != nil {
        log.Fatalf("Error: %v", err)
    }
    fmt.Printf("Sum of middle pages: %d\n", sum)
}
