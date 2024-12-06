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

    fmt.Printf("Total instances of 'X-MAS' patterns found: %d\n", countXMASPatterns(grid))
}

// Function to read the grid from a file
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

// Function to count the "X-MAS" patterns
func countXMASPatterns(grid [][]rune) int {
    count := 0

    rows := len(grid)
    if rows < 3 {
        return count
    }
    cols := len(grid[0])
    if cols < 3 {
        return count
    }

    // Traverse the grid, looking for 'X-MAS' patterns
    for i := 1; i < rows-1; i++ {
        for j := 1; j < cols-1; j++ {
            if checkXMASPattern(grid, i, j) {
                count++
            }
        }
    }

    return count
}

// Function to check for 'X-MAS' pattern centered at grid[i][j] following the 'X' or '+' shape
func checkXMASPattern(grid [][]rune, i, j int) bool {
    // Ensure we're not out of bounds to avoid runtime errors
    if i <= 0 || i >= len(grid)-1 || j <= 0 || j >= len(grid[0])-1 {
        return false
    }

    // Ensure the center is 'A'
    if grid[i][j] != 'A' {
        return false
    }

    // Check the 'X' pattern around (i, j)
    if checkXPattern(grid, i, j, i-1, j-1, i-1, j+1) {
        return true
    }

    return false
}

func checkMAndS(grid [][]rune, row1 int, col1 int, row2 int, col2 int) bool {
    // Ensure row and column indices are within the bounds of the grid
    if row1 >= 0 && row1 < len(grid) && col1 >= 0 && col1 < len(grid[0]) &&
        row2 >= 0 && row2 < len(grid) && col2 >= 0 && col2 < len(grid[0]) {
        // Check if one position has 'M' and the other has 'S'
        return (grid[row1][col1] == 'M' && grid[row2][col2] == 'S') ||
            (grid[row1][col1] == 'S' && grid[row2][col2] == 'M')
    }
    return false
}


// Check for the 'X' pattern by taking diagonal coordinate positions
func checkXPattern(grid [][]rune, i, j int, d1Row int, d1Col int, d2Row int, d2Col int) bool {
    // From top-left to bottom-right diagonal: M and S should be in the opposite corners around 'A'
    diagonal1 := checkMAndS(grid, d1Row, d1Col, 2*i-d1Row, 2*j-d1Col)
    // From bottom-right to top-left, reversed check
    diagonal1Reverse := checkMAndS(grid, 2*i-d1Row, 2*j-d1Col, d1Row, d1Col)

    // From top-right to bottom-left diagonal: M and S should be in the opposing corners around 'A'
    diagonal2 := checkMAndS(grid, d2Row, d2Col, 2*i-d2Row, 2*j-d2Col)
    // From bottom-left to top-right, reversed check
    diagonal2Reverse := checkMAndS(grid, 2*i-d2Row, 2*j-d2Col, d2Row, d2Col)

    return (diagonal1 || diagonal1Reverse) && (diagonal2 || diagonal2Reverse)
}
