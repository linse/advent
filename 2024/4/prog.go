package main

import (
    "bufio"
    "fmt"
    "log"
    "os"
)

func main() {
    grid, err := readGridFromFile("input.txt")
    if err != nil {
        log.Fatalf("Failed to read input file: %s", err)
    }
    fmt.Printf("Total instances of 'XMAS' found: %d\n", countXMASInstances(grid))
}

// Read the grid from a file
func readGridFromFile(filename string) ([][]rune, error) {
    file, err := os.Open(filename)
    if err != nil {
        return nil, err
    }
    defer file.Close()

    var grid [][]rune
    scanner := bufio.NewScanner(file)
    for scanner.Scan() {
        line := scanner.Text()
        grid = append(grid, []rune(line))
    }

    if err := scanner.Err(); err != nil {
        return nil, err
    }

    return grid, nil
}

// Search for "XMAS" in all directions
func countXMASInstances(grid [][]rune) int {
    word := "XMAS"
    count := 0

    rows := len(grid)
    if rows == 0 {
        return count
    }
    cols := len(grid[0])

    directions := [][]int{
        {0, 1},  // right
        {0, -1}, // left
        {1, 0},  // down
        {-1, 0}, // up
        {1, 1},  // down-right diagonal
        {1, -1}, // down-left diagonal
        {-1, 1}, // up-right diagonal
        {-1, -1}, // up-left diagonal
    }

    for i := 0; i < rows; i++ {
        for j := 0; j < cols; j++ {
            if grid[i][j] == rune(word[0]) {
                for _, dir := range directions {
                    if searchFrom(grid, i, j, dir, word) {
                        count++
                    }
                }
            }
        }
    }
    return count
}

// Search for the word from a starting point in a given direction
func searchFrom(grid [][]rune, startRow, startCol int, dir []int, word string) bool {
    // Loop through each character in the word
    for k := 0; k < len(word); k++ {
        // Calculate the current position in the grid based on the direction
        newRow := startRow + k*dir[0]
        newCol := startCol + k*dir[1]

        // Check boundaries and character match
        if newRow < 0 || newRow >= len(grid) || newCol < 0 || newCol >= len(grid[0]) || grid[newRow][newCol] != rune(word[k]) {
            return false
        }
    }

    // If all characters match in the given direction
    return true
}
